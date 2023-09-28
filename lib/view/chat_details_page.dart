import 'package:flutter/material.dart';
import 'package:sprint_v3/controller/chat_controller.dart';
import 'package:sprint_v3/controller/user_controller.dart';
import '../model/messages_model.dart';

class ChatDetailScreen extends StatelessWidget {
  final String userId;
  final String chatPartnerId;

  final UserController userController = UserController();
  final ChatController chatController = ChatController();
  final TextEditingController messageController = TextEditingController();

  ChatDetailScreen({
    Key? key,
    required this.userId,
    required this.chatPartnerId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat'),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<MessagesModel>>(
              stream: chatController.getMessagesForChatStream(userId, chatPartnerId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Text('');
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  List<MessagesModel> messages = snapshot.data!;
                  return ListView(
                    children: messages.map((message) {
                      bool isUserMessage = message.sender == userId;

                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: isUserMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                color: isUserMessage ? Colors.green : Colors.blue,
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  FutureBuilder<String>(
                                    future: userController.getUserName(message.sender),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState == ConnectionState.waiting) {
                                        return const Text('Loading...');
                                      } else if (snapshot.hasError) {
                                        return Text('Error: ${snapshot.error}');
                                      } else {
                                        String user = snapshot.data!;
                                        return Text(
                                          user[0].toUpperCase() + user.substring(1).toLowerCase(),
                                          style: const TextStyle(color: Colors.white),
                                        );
                                      }
                                    },
                                  ),
                                  Text(
                                    message.content,
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  );
                }
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8.0),
            color: Colors.grey[200],
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: messageController,
                    decoration: const InputDecoration(
                      hintText: 'Type a message...',
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    String message = messageController.text;
                    chatController.createNewMessage(
                      sender: userId,
                      receiver: chatPartnerId,
                      content: message,
                    );
                    messageController.clear();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


