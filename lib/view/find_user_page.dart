import 'package:flutter/material.dart';
import 'package:sprint_v3/controller/user_controller.dart';
import 'package:sprint_v3/model/chats_model.dart';
import 'package:sprint_v3/model/user_model.dart';
import 'package:sprint_v3/view/chat_page.dart';

class NewChatPage extends StatefulWidget {
  final UserModel userModel;
  const NewChatPage({required this.userModel, Key? key}) : super(key: key);

  @override
  NewChatPageState createState() => NewChatPageState();
}

class NewChatPageState extends State<NewChatPage> {
  // Controller for handling user input
  final TextEditingController _searchController = TextEditingController();
  final UserController _userController = UserController();
  List<List<String>> _searchResults = [];

  // Function to perform user search
  void _performSearch(String name) async {
    List<List<String>>? resultList = await _userController.searchUser(name.toLowerCase());

    setState(() {
      _searchResults = resultList ?? [];
    });
  }

  // Clean up the TextEditingController
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              onChanged: _performSearch,
              decoration: const InputDecoration(
                labelText: 'Search',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _searchResults.length,
              itemBuilder: (BuildContext context, int index) {
                return Center(
                  child: GestureDetector(
                    onTap: () {
                      List<String> searchResult = _searchResults[index];

                      String userId = widget.userModel.userId;
                      String chatPartnerId = searchResult.first;

                      ChatsModel chatModel = ChatsModel();
                      chatModel.chatId = "New Chat";
                      chatModel.members = [userId, chatPartnerId];
                      chatModel.messages = [];

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ChatDetailScreen(chatModel: chatModel),
                        ),
                      );
                    },
                    child: SizedBox(
                      height: 70.0,
                      child: FractionallySizedBox(
                        widthFactor: 0.8,
                        child: Container(
                          margin: const EdgeInsets.only(top: 16.0),
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Text(
                            _searchResults[index][1][0].toUpperCase() +
                                _searchResults[index][1]
                                    .substring(1)
                                    .toLowerCase(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 26,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
