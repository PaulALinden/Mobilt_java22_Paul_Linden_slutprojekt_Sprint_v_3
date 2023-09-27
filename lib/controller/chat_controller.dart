import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sprint_v3/controller/user_controller.dart';
import 'package:sprint_v3/model/messages_model.dart';

class ChatController {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final UserController userController = UserController();

  Stream<List<MessagesModel>> getMessagesForChatStream(String chatId) {
    return firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((QuerySnapshot query) {
      List<MessagesModel> messages = [];
      for (var doc in query.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        messages.add(MessagesModel(
          messageId: doc.id,
          sender: data['sender'],
          receiver: data['receiver'],
          content: data['content'],
          timestamp: data['timestamp'].toDate(),
        ));
      }
      return messages;
    });
  }

  Future<List<Map<String, String>>> getChatsForUser(String userId) async {
    try {
      QuerySnapshot chatSnapshot = await firestore
          .collection('chats')
          .where('members', arrayContains: userId)
          .get();

      List<Map<String, String>> chats = [];

      for (QueryDocumentSnapshot chatDoc in chatSnapshot.docs) {
        List<String> members = List<String>.from(chatDoc['members']);
        String chatPartnerId =
            members.firstWhere((memberId) => memberId != userId);
        String chatPartnerName =
            await userController.getUserName(chatPartnerId);

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
    try {
      await firestore
          .collection('chats')
          .doc(chatId)// Kolla om chat finns med chatId// memb// skapa isåfall, annars meddelande.
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

  void newChat(String memberOne, String memberTwo) async {
    try {
      await firestore.collection('chats').add({
        'members': [memberOne, memberTwo]
      }).then((DocumentReference docRef) {
        docRef.collection('messages').doc().set({});
      });
    } catch (e) {
      print("Error creating new chat: $e");
    }
  }

}
