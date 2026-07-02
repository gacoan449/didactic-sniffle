import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/stok_model.dart';
import '../models/laporan_model.dart';
import 'laporan_service.dart';
import 'logger_service.dart';

class LayananStok {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final LayananAudit _audit = LayananAudit();
  String get _idAdmin => FirebaseAuth.instance.currentUser?.uid ?? 'sistem';

  Future<StokProduk?> ambilStok(String idProduk) async {
    try {
      final snap = await _db.collection('stok').doc(idProduk).get();
      return snap.exists ? StokProduk.dariSnapshot(snap) : null;
    } catch (e, t) {
      LayananLog.error("Ambil stok $idProduk gagal", e, t);
      return null;
    }
  }

  /// ✅ Pembersihan reservasi kadaluarsa
  Future<void> bersihkanReservasiKadaluarsa() async {
    try {
      final batas = DateTime.now();
      final snap = await _db
          .collection('reservasi')
          .where('kadaluarsa', isLessThanOrEqualTo: Timestamp.fromDate(batas))
          .get();

      for (final doc in snap.docs) {
        await lepasReservasi(doc.id);
      }
      if (snap.docs.isNotEmpty) {
        LayananLog.info(
          "Berhasil membersihkan ${snap.docs.length} reservasi kadaluarsa",
        );
      }
    } catch (e, t) {
      LayananLog.error("Bersihkan reservasi gagal", e, t);
    }
  }

  Future<bool> ubahStok({
    required String idProduk,
    required JenisPerubahanStok jenis,
    required int jumlahPerubahan,
    String? referensi,
    required String keterangan,
  }) async {
    if (jumlahPerubahan == 0) return false;

    bool berhasil = false;
    int stokSebelum = 0, stokSesudah = 0;

    try {
      await _db.runTransaction((tx) async {
        final doc = _db.collection('stok').doc(idProduk);
        final snap = await tx.get(doc);

        StokProduk stok = snap.exists
            ? StokProduk.dariSnapshot(snap)
            : StokProduk(
                idProduk: idProduk,
                jumlahSaatIni: 0,
                jumlahDireservasi: 0,
                stokMinimum: 5,
                stokMaksimum: 999999,
                stokRendah: true,
                diperbaruiPada: DateTime.now(),
              );

        stokSebelum = stok.jumlahSaatIni;
        stokSesudah = stok.jumlahSaatIni + jumlahPerubahan;

        if (stokSesudah < 0) throw Exception("Stok tidak mencukupi");
        if (stokSesudah > stok.stokMaksimum)
          throw Exception(
            "Melebihi batas maksimum produk (${stok.stokMaksimum})",
          );

        final stokBaru = stok.copyWith(
          jumlahSaatIni: stokSesudah,
          stokRendah: stok.jumlahTersedia <= stok.stokMinimum,
        );

        tx.set(doc, stokBaru.keMap(), SetOptions(merge: true));

        tx.set(_db.collection('riwayat_stok').doc(), {
          'idProduk': idProduk,
          'jenis': jenis.name,
          'sebelum': stokSebelum,
          'perubahan': jumlahPerubahan,
          'sesudah': stokSesudah,
          'idAdmin': _idAdmin,
          'referensi': referensi,
          'keterangan': keterangan,
          'waktu': FieldValue.serverTimestamp(),
        });

        berhasil = true;
      });

      if (berhasil) {
        await _audit.catatAktivitas(
          _idAdmin,
          JenisAudit.ubahStok,
          "$idProduk: $stokSebelum → $stokSesudah ($keterangan)",
        );
      }
      return berhasil;
    } catch (e, t) {
      LayananLog.error("Ubah stok $idProduk gagal", e, t);
      return false;
    }
  }

  /// ✅ OPTIMASI BATCH: Ambil semua stok SEKALI SAJA pakai Future.wait
  Future<Map<String, bool>> ubahBanyakStok(
    List<Map<String, dynamic>> daftar,
  ) async {
    Map<String, bool> hasil = {};
    final batch = _db.batch();
    List<Future> tugasAudit = [];

    try {
      // Ambil semua ID unik
      final daftarId = daftar
          .map((e) => e['idProduk'] as String)
          .toSet()
          .toList();

      // ✅ Ambil semua data stok SEKALI Jalan, bukan berulang
      final daftarStok = await Future.wait(daftarId.map((id) => ambilStok(id)));

      final petaStok = <String, StokProduk>{};
      for (int i = 0; i < daftarId.length; i++) {
        if (daftarStok[i] != null) {
          petaStok[daftarId[i]] = daftarStok[i]!;
        }
      }

      // Proses batch
      for (final item in daftar) {
        final id = item['idProduk'] as String;
        final jumlah = item['jumlah'] as int;
        final jenis = item['jenis'] as JenisPerubahanStok;
        final keterangan = item['keterangan'] ?? 'Perubahan massal';

        if (!petaStok.containsKey(id)) {
          hasil[id] = false;
          continue;
        }

        final stokSaatIni = petaStok[id]!;
        final sesudah = stokSaatIni.jumlahSaatIni + jumlah;

        if (sesudah < 0 || sesudah > stokSaatIni.stokMaksimum) {
          hasil[id] = false;
          continue;
        }

        final stokBaru = stokSaatIni.copyWith(
          jumlahSaatIni: sesudah,
          stokRendah: stokSaatIni.jumlahTersedia <= stokSaatIni.stokMinimum,
        );

        batch.set(
          _db.collection('stok').doc(id),
          stokBaru.keMap(),
          SetOptions(merge: true),
        );
        batch.set(_db.collection('riwayat_stok').doc(), {
          'idProduk': id,
          'jenis': jenis.name,
          'sebelum': stokSaatIni.jumlahSaatIni,
          'perubahan': jumlah,
          'sesudah': sesudah,
          'idAdmin': _idAdmin,
          'keterangan': keterangan,
          'waktu': FieldValue.serverTimestamp(),
        });

        tugasAudit.add(
          _audit.catatAktivitas(
            _idAdmin,
            JenisAudit.ubahStok,
            "$id: ${stokSaatIni.jumlahSaatIni} → $sesudah ($keterangan)",
          ),
        );
        hasil[id] = true;
      }

      await batch.commit();
      await Future.wait(tugasAudit);
      LayananLog.info(
        "Berhasil memproses ${daftar.length} perubahan stok massal",
      );
      return hasil;
    } catch (e, t) {
      LayananLog.error("Batch stok gagal", e, t);
      return daftar.map((e) => e['idProduk'] as String).fold({}, (map, id) {
        map[id] = false;
        return map;
      });
    }
  }

  Future<bool> reservasiStok(
    String idProduk,
    int jumlah,
    String idPesanan,
  ) async {
    if (jumlah <= 0) return false;
    bool berhasil = false;

    try {
      await _db.runTransaction((tx) async {
        final doc = _db.collection('stok').doc(idProduk);
        final snap = await tx.get(doc);
        if (!snap.exists) throw Exception("Produk tidak ditemukan");

        final stok = StokProduk.dariSnapshot(snap);
        if (stok.jumlahTersedia < jumlah)
          throw Exception("Stok tidak cukup untuk reservasi");

        final stokBaru = stok.copyWith(
          jumlahDireservasi: stok.jumlahDireservasi + jumlah,
          stokRendah: stok.jumlahTersedia <= stok.stokMinimum,
        );

        tx.set(doc, stokBaru.keMap(), SetOptions(merge: true));
        tx.set(_db.collection('reservasi').doc(idPesanan), {
          'idProduk': idProduk, 'jumlah': jumlah,
          // ✅ Selalu simpan sebagai Timestamp agar tipe konsisten
          'kadaluarsa': Timestamp.fromDate(
            DateTime.now().add(const Duration(minutes: 15)),
          ),
          'waktu': FieldValue.serverTimestamp(),
        });

        berhasil = true;
      });

      LayananLog.info(
        "Reservasi $jumlah unit $idProduk untuk $idPesanan BERHASIL",
      );
      return berhasil;
    } catch (e, t) {
      LayananLog.error("Reservasi gagal", e, t);
      return false;
    }
  }

  Future<bool> lepasReservasi(String idPesanan) async {
    bool berhasil = false;
    try {
      await _db.runTransaction((tx) async {
        final docRes = _db.collection('reservasi').doc(idPesanan);
        final snapRes = await tx.get(docRes);
        if (!snapRes.exists) return;

        final data = snapRes.data()!;
        final idProduk = data['idProduk'] as String;
        final jumlah = data['jumlah'] as int;

        final docStok = _db.collection('stok').doc(idProduk);
        final snapStok = await tx.get(docStok);
        if (!snapStok.exists) return;

        final stok = StokProduk.dariSnapshot(snapStok);
        final stokBaru = stok.copyWith(
          jumlahDireservasi: stok.jumlahDireservasi - jumlah,
          stokRendah: stok.jumlahTersedia <= stok.stokMinimum,
        );

        tx.set(docStok, stokBaru.keMap(), SetOptions(merge: true));
        tx.delete(docRes);
        berhasil = true;
      });
      return berhasil;
    } catch (e, t) {
      LayananLog.error("Lepas reservasi gagal", e, t);
      return false;
    }
  }

  Stream<StokProduk?> streamStok(String idProduk) => _db
      .collection('stok')
      .doc(idProduk)
      .snapshots()
      .map((s) => s.exists ? StokProduk.dariSnapshot(s) : null);

  Future<List<StokProduk>> ambilStokRendah() async {
    try {
      final snap = await _db
          .collection('stok')
          .where('stokRendah', isEqualTo: true)
          .limit(50)
          .get();
      return snap.docs.map((d) => StokProduk.dariSnapshot(d)).toList();
    } catch (e, t) {
      LayananLog.error("Ambil stok rendah gagal", e, t);
      return [];
    }
  }
}
