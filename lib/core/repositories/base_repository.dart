import 'package:cloud_firestore/cloud_firestore.dart';
import '../entities/firestore_entity.dart';

abstract class BaseRepository<T extends FirestoreEntity> {
  final FirebaseFirestore firestore;
  final String namaKoleksi;

  BaseRepository(this.firestore, this.namaKoleksi);

  CollectionReference get koleksi => firestore.collection(namaKoleksi);

  Future<T> simpan(T entitas);
  Future<T?> bacaBerdasarkanId(String id);
  Future<List<T>> bacaSemua();
  Future<T> perbarui(T entitas);
  Future<void> hapus(String id);
}
