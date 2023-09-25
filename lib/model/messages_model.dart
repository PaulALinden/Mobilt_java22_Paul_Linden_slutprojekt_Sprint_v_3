class MessagesModel {
    late String messagesId;
    late String content;
    late String receiver;
    late String sender;
    late DateTime timestamp;

    MessagesModel();

    String getMessagesId() {
        return messagesId;
    }

    void setMessagesId(String messagesId) {
        this.messagesId = messagesId;
    }

    String getContent() {
        return content;
    }

    void setContent(String content) {
        this.content = content;
    }

    String getReceiver() {
        return receiver;
    }

    void setReceiver(String receiver) {
        this.receiver = receiver;
    }

    String getSender() {
        return sender;
    }

    void setSender(String sender) {
        this.sender = sender;
    }

    DateTime getTimestamp() {
        return timestamp;
    }

    void setTimestamp(DateTime timestamp) {
        this.timestamp = timestamp;
    }
}
