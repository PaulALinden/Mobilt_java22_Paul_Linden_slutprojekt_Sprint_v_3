import 'package:sprint_v3/model/messages_model.dart';

class ChatsModel {
    late String chatId;
    late List<String> members;
    List<MessagesModel> messages;

    ChatsModel({
        required this.chatId,
        required this.members,
        required this.messages
    });
}
