import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/wallet_transaksi_model.dart';
import '../models/pengguna_model.dart';
import '../services/enkripsi_service.dart';

class LayananDompet {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  static const int batasTransferHarian = 10000000; // Rp 10 Juta

  Future<int> cekSaldo(String penggunaId) async {
    final snap = await _db.collection('pengguna').doc(penggunaId).get();
    if (!snap.exists || snap.data() == null) return 0;
    return PenggunaModel.dariMap(snap.data()!, snap.id).saldoDompet;
  }

  Future<Map<String, dynamic>> transferSaldo({
    required String dariId,
    required String keId,
    required int jumlah,
    required String pinPengguna,
    String keterangan = "",
  }) async {
    if (jumlah < 1000)
      return {"berhasil": false, "pesan": "Minimal transfer Rp 1.000"};
    if (dariId == keId)
      return {
        "berhasil": false,
        "pesan": "Tidak bisa transfer ke akun sendiri",
      };

    try {
      return await _db.runTransaction((tx) async {
        final snapDari = await tx.get(_db.collection('pengguna').doc(dariId));
        final snapKe = await tx.get(_db.collection('pengguna').doc(keId));

        if (!snapDari.exists || !snapKe.exists) {
          return {"berhasil": false, "pesan": "Akun tujuan tidak ditemukan"};
        }

        final dataDari = PenggunaModel.dariMap(snapDari.data()!, snapDari.id);
        if (dataDari.saldoDompet < jumlah) {
          return {"berhasil": false, "pesan": "Saldo tidak mencukupi"};
        }

        // Cek PIN
        final pinBenar = await _db
            .collection('pengaturan')
            .doc(dariId)
            .get()
            .then((s) {
              final hash = s.data()?['pinEnkripsi'] as String?;
              return hash != null && LayananEnkripsi.cekPIN(pinPengguna, hash);
            });
        if (!pinBenar) return {"berhasil": false, "pesan": "PIN Salah"};

        // Lakukan perubahan semuanya dalam satu transaksi
        final refTransaksiKeluar = _db.collection('transaksi_dompet').doc();
        final refTransaksiMasuk = _db.collection('transaksi_dompet').doc();

        tx.update(snapDari.reference, {
          "saldoDompet": FieldValue.increment(-jumlah),
        });
        tx.update(snapKe.reference, {
          "saldoDompet": FieldValue.increment(jumlah),
        });

        tx.set(refTransaksiKeluar, {
          'penggunaId': dariId,
          'jenis': 'transferKeluar',
          'jumlah': jumlah,
          'keterangan': 'Ke $keId: $keterangan',
          'dibuatPada': FieldValue.serverTimestamp(),
        });

        tx.set(refTransaksiMasuk, {
          'penggunaId': keId,
          'jenis': 'terimaTransfer',
          'jumlah': jumlah,
          'keterangan': 'Dari $dariId: $keterangan',
          'dibuatPada': FieldValue.serverTimestamp(),
        });

        return {"berhasil": true, "pesan": "Transfer Berhasil"};
      });
    } catch (e) {
      return {"berhasil": false, "pesan": e.toString()};
    }
  }

  Future<List<WalletTransaksiModel>> ambilRiwayat(
    String penggunaId, {
    int batas = 30,
  }) async {
    final snap = await _db
        .collection('transaksi_dompet')
        .where('penggunaId', isEqualTo: penggunaId)
        .orderBy('dibuatPada', descending: true)
        .limit(batas)
        .get();
    return snap.docs
        .map((d) => WalletTransaksiModel.dariMap(d.data(), d.id))
        .toList();
  }
}
