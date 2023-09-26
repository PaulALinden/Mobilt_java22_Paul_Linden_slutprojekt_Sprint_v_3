import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sprint_v3/model/messages_model.dart';
import '../data/firestor_singelton.dart';

class ChatController{
  FirestoreService firestoreService = FirestoreService();

  Stream<List<MessagesModel>> getMessagesForChatStream(String chatId) {
    return FirebaseFirestore.instance
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((QuerySnapshot query) {
      List<MessagesModel> messages = [];
      query.docs.forEach((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        messages.add(MessagesModel(
          messageId: doc.id,
          sender: data['sender'],
          receiver: data['receiver'],
          content: data['content'],
          timestamp: data['timestamp'].toDate(),
        ));
      });
      return messages;
    });
  }


  Future<String> getUserName(String userId) async {
    FirebaseFirestore firestore = firestoreService.firestore;

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

  Future<List<Map<String, String>>> getChatsForUser(String userId) async {
    FirebaseFirestore firestore = firestoreService.firestore;

    try {
      QuerySnapshot chatSnapshot = await firestore
          .collection('chats')
          .where('members', arrayContains: userId)
          .get();

      List<Map<String, String>> chats = [];

      for (QueryDocumentSnapshot chatDoc in chatSnapshot.docs) {
        List<String> members = List<String>.from(chatDoc['members']);
        String chatPartnerId = members.firstWhere((memberId) => memberId != userId);
        String chatPartnerName = await getUserName(chatPartnerId);

        chats.add({
          'chatId': chatDoc.id,
          'chatPartnerId': chatPartnerId,
          'chatPartnerName': chatPartnerName,
        });
      }

      return chats;
    } catch (e) {
      print("Error getting chats: $e");
      return [];
    }
  }

  Future<void> createNewMessage({
    required String chatId,
    required String sender,
    required String receiver,
    required String content,
  }) async {
    FirebaseFirestore firestore = firestoreService.firestore;

    try {
      await firestore
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .add({
        'sender': sender,
        'receiver': receiver,
        'content': content,
        'timestamp': DateTime.now(),
      });
    } catch (e) {
      print("Error creating new message: $e");
    }
  }
}


