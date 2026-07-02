import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:map_launcher/map_launcher.dart';
import '../config/konstanta.dart';
import '../models/toko_model.dart';
import 'logger_service.dart';

class LayananToko {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  static const int BATAS_HALAMAN = 20;

  String get uid => _auth.currentUser?.uid ?? '';

  Future<bool> apakahSudahPunyaToko() async {
    if (uid.isEmpty) return false;
    final QuerySnapshot<Map<String, dynamic>> snap = await _db
        .collection(Konstanta.KOLEKSI_TOKO)
        .where(Konstanta.KUNCI_ID_PEMILIK, isEqualTo: uid)
        .limit(1)
        .get();
    return snap.docs.isNotEmpty;
  }

  Future<Toko?> ambilTokoSaya() async {
    if (uid.isEmpty) return null;
    final QuerySnapshot<Map<String, dynamic>> snap = await _db
        .collection(Konstanta.KOLEKSI_TOKO)
        .where(Konstanta.KUNCI_ID_PEMILIK, isEqualTo: uid)
        .limit(1)
        .get();
    if (snap.docs.isEmpty) return null;
    return Toko.fromMap(snap.docs.first.id, snap.docs.first.data());
  }

  Stream<Toko?> streamTokoSaya() {
    if (uid.isEmpty) return Stream.value(null);
    return _db
        .collection(Konstanta.KOLEKSI_TOKO)
        .where(Konstanta.KUNCI_ID_PEMILIK, isEqualTo: uid)
        .limit(1)
        .snapshots()
        .map(
          (snap) => snap.docs.isNotEmpty
              ? Toko.fromMap(snap.docs.first.id, snap.docs.first.data())
              : null,
        );
  }

  Future<String> daftarToko(Toko toko) async {
    if (uid.isEmpty) throw Exception("Belum login");
    if (!toko.apakahValid())
      throw Exception("Data toko tidak lengkap atau format salah");
    if (await apakahSudahPunyaToko())
      throw Exception("Anda sudah memiliki toko");

    try {
      final DocumentReference<Map<String, dynamic>> ref = _db
          .collection(Konstanta.KOLEKSI_TOKO)
          .doc();
      final tokoDenganId = toko.copyWith(id: ref.id, idPemilik: uid);
      await ref.set(tokoDenganId.toCreateMap());
      return ref.id;
    } catch (e, t) {
      LayananLog.error("Daftar toko gagal", e);
      rethrow;
    }
  }

  Future<void> ubahToko(String idToko, Toko toko) async {
    if (uid.isEmpty) return;
    if (!toko.apakahValid())
      throw Exception("Data toko tidak lengkap atau format salah");

    try {
      await _db
          .collection(Konstanta.KOLEKSI_TOKO)
          .doc(idToko)
          .update(toko.toUpdateMap());
    } catch (e, t) {
      LayananLog.error("Ubah toko gagal", e);
      rethrow;
    }
  }

  Future<Toko?> ambilToko(String idToko) async {
    final DocumentSnapshot<Map<String, dynamic>> snap = await _db
        .collection(Konstanta.KOLEKSI_TOKO)
        .doc(idToko)
        .get();
    return snap.exists ? Toko.fromMap(snap.id, snap.data()!) : null;
  }

  Stream<Toko?> streamToko(String idToko) {
    return _db
        .collection(Konstanta.KOLEKSI_TOKO)
        .doc(idToko)
        .snapshots()
        .map((d) => d.exists ? Toko.fromMap(d.id, d.data()!) : null);
  }

  Query<Map<String, dynamic>> _filterDasar() {
    return _db
        .collection(Konstanta.KOLEKSI_TOKO)
        .where(
          Konstanta.KUNCI_STATUS_VERIFIKASI,
          isEqualTo: StatusVerifikasi.disetujui.index,
        )
        .orderBy(Konstanta.KUNCI_BERGABUNG_PADA, descending: true)
        .limit(BATAS_HALAMAN);
  }

  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>>
  ambilHalamanPertamaDokumen() async {
    final QuerySnapshot<Map<String, dynamic>> snap = await _filterDasar().get();
    return snap.docs;
  }

  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>>
  ambilHalamanBerikutnyaDokumen(
    QueryDocumentSnapshot<Map<String, dynamic>> dokumenTerakhir,
  ) async {
    try {
      final QuerySnapshot<Map<String, dynamic>> snap = await _filterDasar()
          .startAfterDocument(dokumenTerakhir)
          .get();
      return snap.docs;
    } catch (e, t) {
      LayananLog.error("Paginasi toko gagal, muat ulang halaman pertama", e);
      return ambilHalamanPertamaDokumen();
    }
  }

  Future<List<Toko>> ambilHalamanPertama() async {
    return (await ambilHalamanPertamaDokumen())
        .map((d) => Toko.fromMap(d.id, d.data()))
        .toList();
  }

  Future<List<Toko>> ambilHalamanBerikutnya(
    QueryDocumentSnapshot<Map<String, dynamic>> dokumenTerakhir,
  ) async {
    return (await ambilHalamanBerikutnyaDokumen(
      dokumenTerakhir,
    )).map((d) => Toko.fromMap(d.id, d.data())).toList();
  }

  Stream<List<Toko>> streamSupplierResmi() {
    return _db
        .collection(Konstanta.KOLEKSI_TOKO)
        .where(
          Konstanta.KUNCI_STATUS_VERIFIKASI,
          isEqualTo: StatusVerifikasi.disetujui.index,
        )
        .where(Konstanta.KUNCI_IS_SUPPLIER_RESMI, isEqualTo: true)
        .orderBy(Konstanta.KUNCI_RATING_TOKO, descending: true)
        .limit(BATAS_HALAMAN)
        .snapshots()
        .map(
          (snap) => snap.docs.map((d) => Toko.fromMap(d.id, d.data())).toList(),
        );
  }

  Stream<List<Toko>> streamTokoTerbaik() {
    return _db
        .collection(Konstanta.KOLEKSI_TOKO)
        .where(
          Konstanta.KUNCI_STATUS_VERIFIKASI,
          isEqualTo: StatusVerifikasi.disetujui.index,
        )
        .orderBy(Konstanta.KUNCI_RATING_TOKO, descending: true)
        .limit(BATAS_HALAMAN)
        .snapshots()
        .map(
          (snap) => snap.docs.map((d) => Toko.fromMap(d.id, d.data())).toList(),
        );
  }

  Future<List<Toko>> cariToko({
    String? kataKunci,
    String? provinsi,
    String? kabupaten,
    bool? supplierSaja,
  }) async {
    Query<Map<String, dynamic>> query = _db
        .collection(Konstanta.KOLEKSI_TOKO)
        .where(
          Konstanta.KUNCI_STATUS_VERIFIKASI,
          isEqualTo: StatusVerifikasi.disetujui.index,
        );

    if (provinsi != null)
      query = query.where(Konstanta.KUNCI_PROVINSI, isEqualTo: provinsi);
    if (kabupaten != null)
      query = query.where(Konstanta.KUNCI_KABUPATEN, isEqualTo: kabupaten);
    if (supplierSaja == true)
      query = query.where(Konstanta.KUNCI_IS_SUPPLIER_RESMI, isEqualTo: true);

    query = query.limit(50);
    final QuerySnapshot<Map<String, dynamic>> snap = await query.get();
    List<Toko> hasil = snap.docs
        .map((d) => Toko.fromMap(d.id, d.data()))
        .toList();

    if (kataKunci != null && kataKunci.trim().isNotEmpty) {
      final kunci = kataKunci.trim().toLowerCase();
      hasil = hasil
          .where(
            (t) =>
                t.namaToko.toLowerCase().contains(kunci) ||
                t.namaPemilik.toLowerCase().contains(kunci) ||
                t.deskripsiToko.toLowerCase().contains(kunci),
          )
          .toList();
    }
    return hasil;
  }

  Future<void> ubahStatusBukaTutup(String idToko, bool status) async {
    if (uid.isEmpty) return;
    try {
      await _db.collection(Konstanta.KOLEKSI_TOKO).doc(idToko).update({
        Konstanta.KUNCI_IS_BUKA: status,
        Konstanta.KUNCI_DIPERBARUI_PADA: FieldValue.serverTimestamp(),
      });
    } catch (e, t) {
      LayananLog.error("Ubah status buka tutup gagal", e);
      rethrow;
    }
  }

  Future<void> teleponToko(String noTelp) async {
    final uri = Uri.parse('tel:$noTelp');
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }

  Future<void> kirimEmail(String alamatEmail) async {
    final uri = Uri.parse('mailto:$alamatEmail');
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }

  Future<void> bukaPeta(Toko toko) async {
    if (await MapLauncher.isMapAvailable(MapType.google) ?? false) {
      await MapLauncher.showMarker(
        mapType: MapType.google,
        coords: Coords(toko.latitude, toko.longitude),
        title: toko.namaToko,
        description: toko.alamat,
      );
    } else if (await MapLauncher.isMapAvailable(MapType.waze) ?? false) {
      await MapLauncher.showMarker(
        mapType: MapType.waze,
        coords: Coords(toko.latitude, toko.longitude),
        title: toko.namaToko,
      );
    }
  }
}
