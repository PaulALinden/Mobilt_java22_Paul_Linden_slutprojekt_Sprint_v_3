import 'package:flutter/material.dart';
import 'package:sprint_v3/model/user_model.dart';
import 'package:sprint_v3/view/chat_page.dart';
import 'package:sprint_v3/view/find_user_page.dart';
import '../controller/chat_controller.dart';

class ProfilePage extends StatelessWidget {
  final UserModel userModel;
  final ChatController chatController = ChatController();
  final TextEditingController searchController = TextEditingController();

  ProfilePage({required this.userModel, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String userName = userModel.username;

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
              userName[0].toUpperCase() + userName.substring(1).toLowerCase(),
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: StreamBuilder<List<Map<String, String>>>(
                stream: chatController.getChatsForUserStream(userModel.userId),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else {
                    List<Map<String, String>> chats = snapshot.data!;

                    return ListView.builder(
                      itemCount: chats.length,
                      itemBuilder: (context, index) {
                        String chatPartnerId = chats[index]['chatPartnerId']!;
                        String chatPartnerName = chats[index]['chatPartnerName']!;
                        return Container(
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          padding: const EdgeInsets.all(12.0),
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: ListTile(
                            title: Text(
                              '${chatPartnerName[0].toUpperCase()}${chatPartnerName.substring(1).toLowerCase()}',
                              style: const TextStyle(color: Colors.white),
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ChatDetailScreen(userId: userModel.userId, chatPartnerId: chatPartnerId),
                                ),
                              );
                            },
                          ),
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
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NewChatPage(userId: userModel.userId)),
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



