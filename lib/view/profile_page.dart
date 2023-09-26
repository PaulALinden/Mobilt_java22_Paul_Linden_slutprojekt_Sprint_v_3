import 'package:flutter/material.dart';
import 'package:sprint_v3/model/user_model.dart';
import 'package:sprint_v3/view/chat_details_page.dart';

import '../controller/chat_controller.dart';

class ProfilePage extends StatelessWidget {
  final UserModel userModel;
  final ChatController chatController = ChatController();

  ProfilePage({required this.userModel, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String userName = userModel.username;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(userName),
            const SizedBox(height: 20),
            Container(
              height: 150, // Adjust the height as needed
              color: Colors.grey[300], // Placeholder for messages
              child: FutureBuilder<List<Map<String, String>>>(
                future: chatController.getChatsForUser(userModel.userId),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator(); // Placeholder for loading state
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    List<Map<String, String>> chats = snapshot.data!;

                    return ListView.builder(
                      itemCount: chats.length,
                      itemBuilder: (context, index) {
                        String chatId= chats[index]['chatId']!;
                        String chatPartnerId = chats[index]['chatPartnerId']!;
                        String chatPartnerName = chats[index]['chatPartnerName']!;
                        return ListTile(
                          title: Text('Chatting with: $chatPartnerName'),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => ChatDetailScreen(chatId: chatId, userId: userModel.userId, chatPartnerId: chatPartnerId)),
                            );
                          },
                        );
                      },
                    );
                  }
                },
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Add logic to create new message
              },
              child: const Text('Create New Message'),
            ),
          ],
        ),
      ),
    );
  }
}


