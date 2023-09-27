import 'package:cloud_firestore/cloud_firestore.dart';

class UserController {

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<List<String>?> searchUser(String name) async {
    try {
      CollectionReference users = firestore.collection('users');
      QuerySnapshot querySnapshot = await users.get();

      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        String dbName = data['name'];
        String userId = doc.id;

        if (dbName == name) {
          return [userId, dbName];
        }
      }
      return null;
    } catch (e) {
      print("Error getting data: $e");
      return null;
    }
  }


  Future<String> getUserName(String userId) async {
    try {
      DocumentSnapshot userDoc =
          await firestore.collection('users').doc(userId).get();
      if (userDoc.exists) {
        Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
        return userData['name'];
      } else {
        return 'Unknown User';
      }
    } catch (e) {
      print("Error getting user name: $e");
      return 'Unknown User';
    }
  }
}
