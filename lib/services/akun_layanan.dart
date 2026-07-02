import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../config/konstanta.dart';
import '../models/pengguna_model.dart';
import 'logger_service.dart';

class LayananAkun {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String get uid => _auth.currentUser?.uid ?? '';

  // ====== WISHLIST ======
  Future<void> toggleWishlist(String idProduk) async {
    if (uid.isEmpty) return;
    try {
      final ref = _db
          .collection(Konstanta.KOLEKSI_PENGGUNA)
          .doc(uid)
          .collection(Konstanta.KOLEKSI_WISHLIST)
          .doc(idProduk);

      await _db.runTransaction((transaksi) async {
        final doc = await transaksi.get(ref);
        if (doc.exists) {
          transaksi.delete(ref);
        } else {
          transaksi.set(
            ref,
            WishlistItem(
              id: idProduk,
              idProduk: idProduk,
              ditambahkanPada: DateTime.now(),
            ).toMap(),
          );
        }
      });
    } catch (e, t) {
      LayananLog.error("Ubah wishlist gagal", e, t);
      rethrow;
    }
  }

  Stream<List<WishlistItem>> streamWishlist() {
    if (uid.isEmpty) return Stream.value([]);
    return _db
        .collection(Konstanta.KOLEKSI_PENGGUNA)
        .doc(uid)
        .collection(Konstanta.KOLEKSI_WISHLIST)
        .orderBy(Konstanta.KUNCI_DITAMBAHKAN, descending: true)
        .snapshots()
        .map(
          (snap) => snap.docs
              .map((d) => WishlistItem.fromMap(d.id, d.data()))
              .toList(),
        );
  }

  // ====== ALAMAT ======
  Future<void> tambahAlamat(AlamatPengguna alamat) async {
    if (uid.isEmpty) return;
    if (!alamat.apakahValid())
      throw Exception("Data alamat tidak lengkap atau format salah");

    try {
      // Ambil dulu daftar alamat utama (cara kompatibel semua versi)
      final daftarUtama = await _db
          .collection(Konstanta.KOLEKSI_PENGGUNA)
          .doc(uid)
          .collection(Konstanta.KOLEKSI_ALAMAT)
          .where(Konstanta.KUNCI_ALAMAT_UTAMA, isEqualTo: true)
          .get();

      await _db.runTransaction((transaksi) async {
        if (alamat.utama) {
          for (final d in daftarUtama.docs) {
            transaksi.update(d.reference, {
              Konstanta.KUNCI_ALAMAT_UTAMA: false,
            });
          }
        }
        final refBaru = _db
            .collection(Konstanta.KOLEKSI_PENGGUNA)
            .doc(uid)
            .collection(Konstanta.KOLEKSI_ALAMAT)
            .doc();
        transaksi.set(refBaru, alamat.toMap());
      });
    } catch (e, t) {
      LayananLog.error("Tambah alamat gagal", e, t);
      rethrow;
    }
  }

  Future<void> ubahAlamat(String idAlamat, AlamatPengguna alamat) async {
    if (uid.isEmpty) return;
    if (!alamat.apakahValid())
      throw Exception("Data alamat tidak lengkap atau format salah");

    try {
      final daftarUtama = await _db
          .collection(Konstanta.KOLEKSI_PENGGUNA)
          .doc(uid)
          .collection(Konstanta.KOLEKSI_ALAMAT)
          .where(Konstanta.KUNCI_ALAMAT_UTAMA, isEqualTo: true)
          .get();

      await _db.runTransaction((transaksi) async {
        if (alamat.utama) {
          for (final d in daftarUtama.docs) {
            if (d.id != idAlamat) {
              transaksi.update(d.reference, {
                Konstanta.KUNCI_ALAMAT_UTAMA: false,
              });
            }
          }
        }
        final refAlamat = _db
            .collection(Konstanta.KOLEKSI_PENGGUNA)
            .doc(uid)
            .collection(Konstanta.KOLEKSI_ALAMAT)
            .doc(idAlamat);
        transaksi.update(refAlamat, alamat.toMap());
      });
    } catch (e, t) {
      LayananLog.error("Ubah alamat gagal", e, t);
      rethrow;
    }
  }

  Future<void> hapusAlamat(String idAlamat) async {
    if (uid.isEmpty) return;
    try {
      await _db
          .collection(Konstanta.KOLEKSI_PENGGUNA)
          .doc(uid)
          .collection(Konstanta.KOLEKSI_ALAMAT)
          .doc(idAlamat)
          .delete();
    } catch (e, t) {
      LayananLog.error("Hapus alamat gagal", e, t);
      rethrow;
    }
  }

  Future<void> jadikanUtama(String idAlamat) async {
    if (uid.isEmpty) return;
    try {
      final daftarUtama = await _db
          .collection(Konstanta.KOLEKSI_PENGGUNA)
          .doc(uid)
          .collection(Konstanta.KOLEKSI_ALAMAT)
          .where(Konstanta.KUNCI_ALAMAT_UTAMA, isEqualTo: true)
          .get();

      await _db.runTransaction((transaksi) async {
        for (final d in daftarUtama.docs) {
          transaksi.update(d.reference, {Konstanta.KUNCI_ALAMAT_UTAMA: false});
        }
        transaksi.update(
          _db
              .collection(Konstanta.KOLEKSI_PENGGUNA)
              .doc(uid)
              .collection(Konstanta.KOLEKSI_ALAMAT)
              .doc(idAlamat),
          {Konstanta.KUNCI_ALAMAT_UTAMA: true},
        );
      });
    } catch (e, t) {
      LayananLog.error("Ubah alamat utama gagal", e, t);
      rethrow;
    }
  }

  Stream<List<AlamatPengguna>> streamAlamat() {
    if (uid.isEmpty) return Stream.value([]);
    return _db
        .collection(Konstanta.KOLEKSI_PENGGUNA)
        .doc(uid)
        .collection(Konstanta.KOLEKSI_ALAMAT)
        .orderBy(Konstanta.KUNCI_ALAMAT_UTAMA, descending: true)
        .snapshots()
        .map(
          (snap) => snap.docs
              .map((d) => AlamatPengguna.fromMap(d.id, d.data()))
              .toList(),
        );
  }

  // ====== VOUCHER ======
  Stream<List<VoucherPengguna>> streamVoucherAktif() {
    if (uid.isEmpty) return Stream.value([]);
    final sekarang = Timestamp.now();
    return _db
        .collection(Konstanta.KOLEKSI_PENGGUNA)
        .doc(uid)
        .collection(Konstanta.KOLEKSI_VOUCHER)
        .where(Konstanta.KUNCI_TERPAKAI, isEqualTo: false)
        .where(Konstanta.KUNCI_SELESAI_BERLAKU, isGreaterThan: sekarang)
        .orderBy(Konstanta.KUNCI_SELESAI_BERLAKU)
        .snapshots()
        .map(
          (snap) => snap.docs
              .map((d) => VoucherPengguna.fromMap(d.id, d.data()))
              .toList(),
        );
  }
}
