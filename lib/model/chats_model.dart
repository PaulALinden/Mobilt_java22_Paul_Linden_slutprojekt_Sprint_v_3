class ChatsModel {
    late String chatId;
    late List<String> members;

    ChatsModel();

    String getChatId() {
        return chatId;
    }

    void setChatId(String chatId) {
        this.chatId = chatId;
    }

    List<String> getMembers() {
        return members;
    }

    void setMembers(List<String> members) {
        this.members = members;
    }
}
