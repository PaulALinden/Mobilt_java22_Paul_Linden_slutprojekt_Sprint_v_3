import 'package:cloud_firestore/cloud_firestore.dart';

class UserController {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Searches for a user by their name and returns a list of matching user IDs and names
  Future<List<List<String>>?> searchUser(String name) async {
    try {
      CollectionReference users = firestore.collection('users');
      QuerySnapshot querySnapshot = await users.get();

      List<List<String>> resultList = [];

      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        String dbName = data['name'];
        String userId = doc.id;

        if (dbName == name) {
          resultList.add([userId, dbName]);
        }
      }

      return resultList.isNotEmpty ? resultList : null;
    } catch (e) {
      print("Error getting data: $e");
      return null;
    }
  }

  // Gets the user name for a given user ID
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

  // Creates a new user with the provided name and password
  Future<void> createNewUser(
      {required String name, required String password}) async {
    try {
      await firestore.collection('users').add({
        'name': name,
        'password': password,
      });
    } catch (e) {
      print("Error creating new message: $e");
    }
  }
}
