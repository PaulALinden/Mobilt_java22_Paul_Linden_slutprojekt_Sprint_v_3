import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sprint_v3/controller/user_controller.dart';
import 'package:sprint_v3/model/messages_model.dart';

class ChatController {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final UserController userController = UserController();

  Stream<List<MessagesModel>> getMessagesForChatStream(String userId1, String userId2) {
    return Stream.fromFuture(findChatId(userId1, userId2))
        .asyncExpand((chatId) async* {
      if (chatId != null) {
        yield* firestore
            .collection('chats')
            .doc(chatId)
            .collection('messages')
            .orderBy('timestamp', descending: false)
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
              timestamp: data['timestamp'],
            ));
          }
          print('messages');
          return messages;
        });
      } else {
        print('Chat not found. Retrying...');
        await Future.delayed(const Duration(seconds: 1));
        yield* getMessagesForChatStream(userId1, userId2);
      }
    });
  }

  Stream<List<Map<String, String>>> getChatsForUserStream(String userId) {
    return firestore
        .collection('chats')
        .where('members', arrayContains: userId)
        .snapshots()
        .asyncMap((QuerySnapshot chatSnapshot) async {
      List<Map<String, String>> chats = [];

      for (QueryDocumentSnapshot chatDoc in chatSnapshot.docs) {
        List<String> members = List<String>.from(chatDoc['members']);
        String chatPartnerId =
        members.firstWhere((memberId) => memberId != userId);
        String chatPartnerName = await userController.getUserName(chatPartnerId);

        chats.add({
          'chatId': chatDoc.id,
          'chatPartnerId': chatPartnerId,
          'chatPartnerName': chatPartnerName,
        });
      }

      return chats;
    });
  }

  Future<void> createNewMessage({required String sender, required String receiver, required String content,}) async {
    try {
      String? chatId = await findChatId(sender, receiver);

      if (chatId != null) {
        await firestore
            .collection('chats')
            .doc(chatId)
            .collection('messages')
            .add({
          'sender': sender,
          'receiver': receiver,
          'content': content,
          'timestamp': DateTime.timestamp(),
        });
      } else {
        DocumentReference chatRef = await firestore.collection('chats').add({
          'members': [sender, receiver],
        });
        await chatRef.collection('messages').add({
          'sender': sender,
          'receiver': receiver,
          'content': content,
          'timestamp': DateTime.timestamp(),
        });
      }
    } catch (e) {
      print("Error creating new message: $e");
    }
  }

  Future<String?> findChatId(String userId1, String userId2) async {
    QuerySnapshot querySnapshot1 = await firestore
        .collection('chats')
        .where('members', arrayContains: userId1)
        .get();

    QuerySnapshot querySnapshot2 = await firestore
        .collection('chats')
        .where('members', arrayContains: userId2)
        .get();

    List<String> chatIds1 = querySnapshot1.docs.map((doc) => doc.id).toList();
    List<String> chatIds2 = querySnapshot2.docs.map((doc) => doc.id).toList();

    List<String> commonChatIds =
        chatIds1.toSet().intersection(chatIds2.toSet()).toList();

    if (commonChatIds.isNotEmpty) {
      String chatId = commonChatIds.first;
      return chatId;
    } else {
      return null;
    }
  }

}
