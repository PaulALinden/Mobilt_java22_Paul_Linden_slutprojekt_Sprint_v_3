import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sprint_v3/model/messages_model.dart';

import '../model/chats_model.dart';

class ChatController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Retrieves a stream of messages for a given chat model
  Stream<List<MessagesModel>> getMessagesForChatStream(chatModel) {
    return Stream.fromFuture(
            findChatId(chatModel.members[0], chatModel.members[1]))
        .asyncExpand((chatId) async* {
      if (chatId != null) {
        // Chat ID found, yield a stream of messages for this chat
        yield* _firestore
            .collection('chats')
            .doc(chatId)
            .collection('messages')
            .orderBy('timestamp', descending: false)
            .snapshots()
            .map((QuerySnapshot query) {
          List<MessagesModel> messages = [];

          // Iterate through each message document in the query result
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
          return messages;
        });
      } else {
        // Chat ID not found, retry after a delay
        await Future.delayed(const Duration(seconds: 2));
        yield* getMessagesForChatStream(chatModel);
      }
    });
  }

  // Retrieves a stream of chats for a given user ID
  Stream<List<ChatsModel>> getChatsForUserStream(String userId) {
    return _firestore
        .collection('chats')
        .where('members', arrayContains: userId)
        .snapshots()
        .asyncMap((QuerySnapshot chatSnapshot) async {
      List<ChatsModel> chats = [];

      for (QueryDocumentSnapshot chatDoc in chatSnapshot.docs) {
        List<String> members = List<String>.from(chatDoc['members']);
        String chatPartnerId =
            members.firstWhere((memberId) => memberId != userId);

        ChatsModel chatModel = ChatsModel();
        chatModel.chatId = chatDoc.id;
        chatModel.members = [userId, chatPartnerId];
        chatModel.messages = [];

        chats.add(chatModel);
      }
      return chats;
    });
  }

  // Creates a new message and adds it to an existing chat or creates a new chat if it doesn't exist
  Future<ChatsModel> createNewMessage(
      {required String content, required ChatsModel chatModel}) async {
    // Check if chatId exists
    var chatDoc =
        await _firestore.collection('chats').doc(chatModel.chatId).get();

    if (chatDoc.exists) {
      // Chat exists, add message to existing chat
      _firestore
          .collection('chats')
          .doc(chatModel.chatId)
          .collection('messages')
          .add({
        'sender': chatModel.members[0],
        'receiver': chatModel.members[1],
        'content': content,
        'timestamp': Timestamp.now(),
      });
    } else {
      // Chat doesn't exist, create new chat and add message
      DocumentReference chatRef = await _firestore.collection('chats').add({
        'members': [chatModel.members[0], chatModel.members[1]],
      });
      // Set chat id
      chatModel.chatId = chatRef.id;

      await chatRef.collection('messages').add({
        'sender': chatModel.members[0],
        'receiver': chatModel.members[1],
        'content': content,
        'timestamp': Timestamp.now(),
      });
    }
    return chatModel;
  }

  // Finds the chat ID for two given user IDs
  Future<String?> findChatId(String userId1, String userId2) async {
    QuerySnapshot querySnapshot1 = await _firestore
        .collection('chats')
        .where('members', arrayContains: userId1)
        .get();

    QuerySnapshot querySnapshot2 = await _firestore
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
