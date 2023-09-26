class MessagesModel {
    late String messageId;
    late String content;
    late String receiver;
    late String sender;
    late DateTime timestamp;

    MessagesModel({
        required this.messageId,
        required this.sender,
        required this.receiver,
        required this.content,
        required this.timestamp
    });
}
