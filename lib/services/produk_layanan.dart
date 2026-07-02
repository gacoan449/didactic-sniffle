import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../config/konstanta.dart';
import '../models/produk_model.dart';
import 'logger_service.dart';

class LayananProduk {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  static const int BATAS_HALAMAN = 20;

  String get uid => _auth.currentUser?.uid ?? '';

  // ====== CRUD PRODUK ======
  Future<String> tambahProduk(Produk produk) async {
    if (uid.isEmpty) throw Exception("Belum login");
    if (!produk.apakahValid())
      throw Exception("Data produk tidak lengkap atau tidak valid");

    try {
      final ref = _db.collection(Konstanta.KOLEKSI_PRODUK).doc();
      final produkDenganId = produk.copyWith(id: ref.id);
      await ref.set(produkDenganId.toCreateMap());
      return ref.id;
    } catch (e, t) {
      LayananLog.error("Tambah produk gagal", e, t);
      rethrow;
    }
  }

  Future<void> ubahProduk(String idProduk, Produk produk) async {
    if (uid.isEmpty) return;
    if (!produk.apakahValid())
      throw Exception("Data produk tidak lengkap atau tidak valid");

    try {
      await _db
          .collection(Konstanta.KOLEKSI_PRODUK)
          .doc(idProduk)
          .update(produk.toUpdateMap());
    } catch (e, t) {
      LayananLog.error("Ubah produk gagal", e, t);
      rethrow;
    }
  }

  Future<void> hapusProduk(String idProduk) async {
    if (uid.isEmpty) return;
    try {
      await _db
          .collection(Konstanta.KOLEKSI_PRODUK)
          .doc(idProduk)
          .update(Produk.softDeleteMap(uid));
    } catch (e, t) {
      LayananLog.error("Hapus produk gagal", e, t);
      rethrow;
    }
  }

  Stream<Produk?> ambilProduk(String idProduk) {
    return _db
        .collection(Konstanta.KOLEKSI_PRODUK)
        .doc(idProduk)
        .snapshots()
        .map((d) => d.exists ? Produk.fromMap(d.id, d.data()!) : null);
  }

  // ====== DAFTAR PRODUK DENGAN PAGINASI AMAN ======
  Query _filterDasar() {
    return _db
        .collection(Konstanta.KOLEKSI_PRODUK)
        .where(Konstanta.KUNCI_DIPUBLIKASIKAN, isEqualTo: true)
        .orderBy(Konstanta.KUNCI_DIBUAT_PADA, descending: true)
        .limit(BATAS_HALAMAN);
  }

  Future<List<Produk>> ambilHalamanPertama() async {
    final snap = await _filterDasar().get();
    return snap.docs.map((d) => Produk.fromMap(d.id, d.data())).toList();
  }

  Future<List<Produk>> ambilHalamanBerikutnya(Produk produkTerakhir) async {
    try {
      final snap = await _filterDasar().startAfter([
        produkTerakhir.dibuatPada,
      ]).get();
      return snap.docs.map((d) => Produk.fromMap(d.id, d.data())).toList();
    } catch (e, t) {
      LayananLog.error(
        "Ambil halaman berikutnya gagal, ambil halaman baru",
        e,
        t,
      );
      return ambilHalamanPertama();
    }
  }

  Stream<List<Produk>> streamProdukPromo() {
    return _db
        .collection(Konstanta.KOLEKSI_PRODUK)
        .where(Konstanta.KUNCI_DIPUBLIKASIKAN, isEqualTo: true)
        .where(Konstanta.KUNCI_IS_PROMO, isEqualTo: true)
        .orderBy(Konstanta.KUNCI_TERJUAL, descending: true)
        .limit(BATAS_HALAMAN)
        .snapshots()
        .map(
          (snap) =>
              snap.docs.map((d) => Produk.fromMap(d.id, d.data())).toList(),
        );
  }

  Stream<List<Produk>> streamProdukTerlaris() {
    return _db
        .collection(Konstanta.KOLEKSI_PRODUK)
        .where(Konstanta.KUNCI_DIPUBLIKASIKAN, isEqualTo: true)
        .orderBy(Konstanta.KUNCI_TERJUAL, descending: true)
        .limit(BATAS_HALAMAN)
        .snapshots()
        .map(
          (snap) =>
              snap.docs.map((d) => Produk.fromMap(d.id, d.data())).toList(),
        );
  }

  // ====== PENCARIAN & FILTER ======
  Future<List<Produk>> cariProduk({
    String? kataKunci,
    int? hargaMin,
    int? hargaMaks,
    bool? organikSaja,
    String? idToko,
  }) async {
    Query query = _db
        .collection(Konstanta.KOLEKSI_PRODUK)
        .where(Konstanta.KUNCI_DIPUBLIKASIKAN, isEqualTo: true);

    if (idToko != null)
      query = query.where(Konstanta.KUNCI_ID_TOKO, isEqualTo: idToko);
    if (organikSaja == true)
      query = query.where(Konstanta.KUNCI_IS_ORGANIK, isEqualTo: true);
    if (hargaMin != null)
      query = query.where(
        Konstanta.KUNCI_HARGA,
        isGreaterThanOrEqualTo: hargaMin,
      );
    if (hargaMaks != null)
      query = query.where(
        Konstanta.KUNCI_HARGA,
        isLessThanOrEqualTo: hargaMaks,
      );

    query = query.limit(50);
    final snap = await query.get();

    List<Produk> hasil = snap.docs
        .map((d) => Produk.fromMap(d.id, d.data()))
        .toList();

    if (kataKunci != null && kataKunci.trim().isNotEmpty) {
      final kunci = kataKunci.trim().toLowerCase();
      hasil = hasil
          .where(
            (p) =>
                p.nama.toLowerCase().contains(kunci) ||
                p.deskripsi.toLowerCase().contains(kunci),
          )
          .toList();
    }

    return hasil;
  }

  // ====== REVIEW & PENILAIAN ======
  Future<void> kirimReview(String idProduk, ReviewProduk review) async {
    if (uid.isEmpty) return;
    if (!review.apakahValid())
      throw Exception("Ulasan tidak valid: Bintang 1-5 & minimal 5 karakter");

    try {
      // Gunakan ID otomatis jika review.id kosong
      final refReview = _db
          .collection(Konstanta.KOLEKSI_PRODUK)
          .doc(idProduk)
          .collection(Konstanta.KOLEKSI_REVIEW)
          .doc(review.id.trim().isEmpty ? null : review.id);

      await refReview.set(review.toMap());
    } catch (e, t) {
      LayananLog.error("Kirim review gagal", e, t);
      rethrow;
    }
  }

  Stream<List<ReviewProduk>> streamReview(String idProduk) {
    return _db
        .collection(Konstanta.KOLEKSI_PRODUK)
        .doc(idProduk)
        .collection(Konstanta.KOLEKSI_REVIEW)
        .orderBy(Konstanta.KUNCI_DIBUAT_ULASAN, descending: true)
        .limit(BATAS_HALAMAN)
        .snapshots()
        .map(
          (snap) => snap.docs
              .map((d) => ReviewProduk.fromMap(d.id, d.data()))
              .toList(),
        );
  }

  // ====== TANYA JAWAB ======
  Future<void> tanyaProduk(String idProduk, TanyaJawab tanya) async {
    if (uid.isEmpty) return;
    try {
      await _db
          .collection(Konstanta.KOLEKSI_PRODUK)
          .doc(idProduk)
          .collection(Konstanta.KOLEKSI_TANYA_JAWAB)
          .doc()
          .set(tanya.toMapTanya());
    } catch (e, t) {
      LayananLog.error("Kirim pertanyaan gagal", e, t);
      rethrow;
    }
  }

  Future<void> jawabPertanyaan(
    String idProduk,
    String idTanya,
    String jawaban,
    String namaPenjawab,
  ) async {
    if (uid.isEmpty) return;
    try {
      await _db
          .collection(Konstanta.KOLEKSI_PRODUK)
          .doc(idProduk)
          .collection(Konstanta.KOLEKSI_TANYA_JAWAB)
          .doc(idTanya)
          .update(
            TanyaJawab(
                  id: idTanya,
                  pertanyaan: '',
                  namaPenanya: '',
                  tglTanya: DateTime.now(),
                )
                .copyWith(jawaban: jawaban, namaPenjawab: namaPenjawab)
                .toMapJawab(),
          );
    } catch (e, t) {
      LayananLog.error("Kirim jawaban gagal", e, t);
      rethrow;
    }
  }

  Stream<List<TanyaJawab>> streamTanyaJawab(String idProduk) {
    return _db
        .collection(Konstanta.KOLEKSI_PRODUK)
        .doc(idProduk)
        .collection(Konstanta.KOLEKSI_TANYA_JAWAB)
        .orderBy(Konstanta.KUNCI_TGL_TANYA, descending: true)
        .limit(BATAS_HALAMAN)
        .snapshots()
        .map(
          (snap) =>
              snap.docs.map((d) => TanyaJawab.fromMap(d.id, d.data())).toList(),
        );
  }
}
