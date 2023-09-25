import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  static final FirestoreService _singleton = FirestoreService._internal();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  factory FirestoreService() {
    return _singleton;
  }

  FirestoreService._internal();

  FirebaseFirestore get firestore => _firestore;
}
