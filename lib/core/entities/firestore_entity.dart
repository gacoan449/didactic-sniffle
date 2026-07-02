import 'package:cloud_firestore/cloud_firestore.dart';

abstract interface class FirestoreEntity {
  String get id;
  DateTime get dibuatPada;
  DateTime get diperbaruiPada;
  String get dibuatOleh;
  String get diubahOleh;
  int get versiData;

  Map<String, dynamic> toJson();
  Map<String, dynamic> toFirestore();

  static T fromFirestore<T>(
    DocumentSnapshot doc,
    T Function(Map<String, dynamic>) fromJson,
  ) {
    final data = doc.data() as Map<String, dynamic>;
    return fromJson({...data, 'id': doc.id});
  }
}
