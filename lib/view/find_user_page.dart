import 'package:flutter/material.dart';
import 'package:sprint_v3/controller/chat_controller.dart';
import 'package:sprint_v3/controller/user_controller.dart';
import 'package:sprint_v3/view/chat_page.dart';

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

    //Printa lista istället så man kan hämta flera användare med samma namn
    setState(() {
      resultName = (resultList?[1] ?? '');
      resultId = (resultList?[0] ?? '');
    });
  }

  @override
  @override
  Widget build(BuildContext context) {
    String userId = widget.userId;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
      ),
      body: Column(
        children:[
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
          if (resultName.isNotEmpty)
            Center(
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatDetailScreen(userId: userId, chatPartnerId: resultId),
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
                        resultName[0].toUpperCase()+resultName.substring(1).toLowerCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}