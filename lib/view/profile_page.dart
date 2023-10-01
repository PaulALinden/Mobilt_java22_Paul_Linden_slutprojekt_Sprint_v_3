import 'package:flutter/material.dart';
import 'package:sprint_v3/controller/user_controller.dart';
import 'package:sprint_v3/model/user_model.dart';
import 'package:sprint_v3/view/chat_page.dart';
import 'package:sprint_v3/view/find_user_page.dart';

import '../controller/chat_controller.dart';
import '../model/chats_model.dart';

class ProfilePage extends StatelessWidget {
  // UserModel instance passed from the previous screen
  final UserModel userModel;

  // Initializing controllers
  final UserController _userController = UserController();
  final ChatController _chatController = ChatController();

  ProfilePage({required this.userModel, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String userId = userModel.userId; // Extracting userId from userModel
    final String userName = userModel.username; // Extracting username from userModel
    String chatPartnerName; // Variable to store chat partner's name

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.blue[100],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              // Displaying formatted username
              userName[0].toUpperCase() + userName.substring(1).toLowerCase(),
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: StreamBuilder<List<ChatsModel>>(
                // Getting chats for the current user
                stream: _chatController.getChatsForUserStream(userId),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    // Displaying loading indicator while waiting for data
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    // Displaying error if data retrieval fails
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else {
                    // Extracting list of chat models
                    List<ChatsModel> chats = snapshot.data!;

                    return ListView.builder(
                      itemCount: chats.length,
                      itemBuilder: (context, index) {
                        String chatPartnerId = chats[index].members.firstWhere(
                            (memberId) => memberId != userModel.userId);
                        return FutureBuilder<String>(
                          // Getting the name of the chat partner
                          future: _userController.getUserName(chatPartnerId),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            } else if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            } else {
                              // Extracting chat partner's name
                              chatPartnerName = snapshot.data!;
                              return Container(
                                margin:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                padding: const EdgeInsets.all(12.0),
                                decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: ListTile(
                                  title: Text(
                                    // Displaying formatted chat partner name
                                    '${chatPartnerName[0].toUpperCase()}${chatPartnerName.substring(1).toLowerCase()}',
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ChatPage(
                                            chatModel: chats[index]),
                                      ),
                                    );
                                  },
                                ),
                              );
                            }
                          },
                        );
                      },
                    );
                  }
                },
              ),
            ),
            const SizedBox(height: 20),
            // Button to create a new message
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => FindUserPage(userModel: userModel)),
                );
              },
              child: const Text('Create New Message'),
            ),
          ],
        ),
      ),
    );
  }
}
