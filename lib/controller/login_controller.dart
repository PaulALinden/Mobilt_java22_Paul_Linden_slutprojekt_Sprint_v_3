import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sprint_v3/model/user_model.dart';
import '../data/firestor_singelton.dart';

class LoginController {
  Future<bool> login(UserModel user) async {
    String username = user.username;
    String password = user.password;

    FirestoreService firestoreService = FirestoreService();
    FirebaseFirestore firestore = firestoreService.firestore;

    try {
      // Get a reference to the collection
      CollectionReference users = firestore.collection('users');
      // Get the documents from the collection
      QuerySnapshot querySnapshot = await users.get();
      // Loop through and check users
      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        String dbname = data['name'];
        String dbpassword = data['password'];
        String dbUserId = doc.id;

        if(dbname == username && dbpassword == password){
          user.userId = dbUserId;
          return true;
        }
      }
    } catch (e) {
      print("Error getting data: $e");
    }
    return false;
  }
}



