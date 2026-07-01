import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/firebase_service.dart';

class BaseRepository {
  final FirebaseFirestore db = LayananFirebase.db;
}
