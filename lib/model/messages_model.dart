import 'package:cloud_firestore/cloud_firestore.dart';

class MessagesModel {
    late String messageId;
    late String content;
    late String receiver;
    late String sender;
    late Timestamp timestamp;

    MessagesModel({
        required this.messageId,
        required this.sender,
        required this.receiver,
        required this.content,
        required this.timestamp
    });
}
