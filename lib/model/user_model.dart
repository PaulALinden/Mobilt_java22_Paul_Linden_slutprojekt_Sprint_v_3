class UserModel {
    late String username;
    late String password;

    UserModel(this.username, this.password);

    String getUserName() {
        return username;
    }

    String getPassword() {
        return password;
    }

}
