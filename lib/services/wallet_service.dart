import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/wallet_model.dart';
import '../models/wallet_transaksi_model.dart';

class LayananDompet {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<DompetModel> ambilAtauBuat(String penggunaId) async {
    final ref = _db.collection('dompet').doc(penggunaId);
    return _db.runTransaction((tx) async {
      final snap = await tx.get(ref);
      if (snap.exists) {
        return DompetModel.dariMap(snap.data()!, penggunaId);
      }
      final dompetBaru = DompetModel(
        penggunaId: penggunaId,
        saldo: 0,
        dibuatPada: DateTime.now(),
      );
      tx.set(ref, dompetBaru.keMap(), SetOptions(merge: true));
      return dompetBaru;
    });
  }

  Future<bool> tambahSaldoAman(
    String penggunaId,
    double jumlah,
    String keterangan, {
    String? refId,
  }) async {
    if (jumlah <= 0) return false;
    final dompetRef = _db.collection('dompet').doc(penggunaId);
    final transaksiRef = _db.collection('dompet_transaksi').doc();

    return _db.runTransaction((tx) async {
      final dompetSnap = await tx.get(dompetRef);
      final saldoSebelum = dompetSnap.exists
          ? (dompetSnap.data()?['saldo'] as num? ?? 0).toDouble()
          : 0;
      final saldoSesudah = saldoSebelum + jumlah;

      tx.set(dompetRef, {
        'saldo': saldoSesudah,
        'diperbaruiPada': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      tx.set(
        transaksiRef,
        WalletTransaksiModel(
          id: transaksiRef.id,
          penggunaId: penggunaId,
          jenis: JenisTransaksiDompet.isiSaldo,
          jumlah: jumlah,
          saldoSebelum: saldoSebelum,
          saldoSesudah: saldoSesudah,
          keterangan: keterangan,
          referensiId: refId,
          dibuatPada: DateTime.now(),
        ).keMap(),
      );

      return true;
    });
  }

  Future<bool> kurangiSaldoAman(
    String penggunaId,
    double jumlah,
    String keterangan, {
    String? refId,
  }) async {
    if (jumlah <= 0) return false;
    final dompetRef = _db.collection('dompet').doc(penggunaId);
    final transaksiRef = _db.collection('dompet_transaksi').doc();

    return _db.runTransaction((tx) async {
      final dompetSnap = await tx.get(dompetRef);
      final saldoSebelum = dompetSnap.exists
          ? (dompetSnap.data()?['saldo'] as num? ?? 0).toDouble()
          : 0;
      if (saldoSebelum < jumlah) return false;
      final saldoSesudah = saldoSebelum - jumlah;

      tx.set(dompetRef, {
        'saldo': saldoSesudah,
        'diperbaruiPada': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      tx.set(
        transaksiRef,
        WalletTransaksiModel(
          id: transaksiRef.id,
          penggunaId: penggunaId,
          jenis: JenisTransaksiDompet.bayarPesanan,
          jumlah: jumlah,
          saldoSebelum: saldoSebelum,
          saldoSesudah: saldoSesudah,
          keterangan: keterangan,
          referensiId: refId,
          dibuatPada: DateTime.now(),
        ).keMap(),
      );

      return true;
    });
  }

  Future<List<WalletTransaksiModel>> ambilRiwayat(String penggunaId) async {
    final snap = await _db
        .collection('dompet_transaksi')
        .where('penggunaId', isEqualTo: penggunaId)
        .orderBy('dibuatPada', descending: true)
        .limit(50)
        .get();
    return snap.docs
        .map((d) => WalletTransaksiModel.dariMap(d.data(), d.id))
        .toList();
  }
}
