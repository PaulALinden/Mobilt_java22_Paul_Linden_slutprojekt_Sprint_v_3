import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:sprint_v3/model/user_model.dart';

class LoginController {
  Future<UserModel?> login(String username, String password) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    try {
      // Get a reference to the collection
      CollectionReference users = firestore.collection('users');
      // Get the documents from the collection
      QuerySnapshot querySnapshot = await users.get();
      // Loop through and check users
      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        String dbName = data['name'];
        String dbPassword = data['password'];
        String dbId = doc.id;

        if (dbName == username && dbPassword == password) {
          UserModel userModel = UserModel(dbId, dbName, dbPassword);
          return userModel;
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error getting data: $e");
      }
    }
    return null;
  }
}
