import 'package:flutter/material.dart';
import 'package:sprint_v3/controller/chat_controller.dart';
import 'package:sprint_v3/controller/user_controller.dart';
import 'package:sprint_v3/view/chat_details_page.dart';

class NewChatPage extends StatefulWidget {

  final String userId;
  const NewChatPage({required this.userId, Key? key}) : super(key: key);

  @override
  NewChatPageState createState() => NewChatPageState();
}

class NewChatPageState extends State<NewChatPage> {

  TextEditingController searchController = TextEditingController();

  final UserController userController = UserController();

  late String resultName = '';
  late String resultId = '';

  void _performSearch(String name) async {
    List<String>? resultList = await userController.searchUser(name);

    setState(() {
      resultName = (resultList?[1] ?? '');
      resultId = (resultList?[0] ?? '');
    });
  }

  @override
  Widget build(BuildContext context) {
    String userId = widget.userId;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Field Example'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              onChanged: _performSearch,
              decoration: const InputDecoration(
                labelText: 'Search',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: GestureDetector(
                onTap: () {
                  String tempChatId = 'New chat';
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ChatDetailScreen(chatId: tempChatId, userId: userId, chatPartnerId: resultId)),
                  );
                },
                child: Text(resultName),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

