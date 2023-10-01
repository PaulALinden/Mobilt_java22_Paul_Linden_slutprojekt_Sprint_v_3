import 'package:flutter/material.dart';
import 'package:sprint_v3/controller/chat_controller.dart';
import 'package:sprint_v3/controller/user_controller.dart';

import '../model/chats_model.dart';
import '../model/messages_model.dart';

class ChatDetailScreen extends StatelessWidget {
  // ChatsModel instance passed from the previous screen
  final ChatsModel chatModel;

  final UserController _userController =
      UserController(); // Controller for user-related operations
  final ChatController _chatController =
      ChatController(); // Controller for chat-related operations
  final TextEditingController _messageController =
      TextEditingController(); // Controller for message input

  ChatDetailScreen({
    Key? key,
    required this.chatModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String userId =
        chatModel.members.first; // Extracting user ID from chatModel

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat'),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<MessagesModel>>(
              stream: _chatController.getMessagesForChatStream(chatModel),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  // Displaying loading indicator
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  // Displaying error if data retrieval fails
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  // Extracting list of messages
                  List<MessagesModel> messages = snapshot.data!;
                  return ListView(
                    children: messages.map((message) {
                      bool isUserMessage = message.sender == userId;

                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: isUserMessage
                              ? MainAxisAlignment.end
                              : MainAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                color:
                                    isUserMessage ? Colors.green : Colors.blue,
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  FutureBuilder<String>(
                                    future: _userController
                                        .getUserName(message.sender),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        // Displaying loading text while waiting for user name
                                        return const Text('Loading...');
                                      } else if (snapshot.hasError) {
                                        // Displaying error if user name retrieval fails
                                        return Text('Error: ${snapshot.error}');
                                      } else {
                                        // Extracting user name
                                        String user = snapshot.data!;
                                        return Text(
                                          user[0].toUpperCase() +
                                              user.substring(1).toLowerCase(),
                                          style: const TextStyle(
                                              color: Colors.white),
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
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText: 'Type a message...',
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    String message = _messageController.text;
                    _chatController.createNewMessage(
                      chatModel: chatModel,
                      content: message,
                    );
                    _messageController.clear();
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
