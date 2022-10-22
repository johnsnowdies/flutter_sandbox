class AnonymousUserData {
  bool loginState = false;
}

class LocalUserData extends AnonymousUserData {
  String email;
  String password;
  String alias;
  String avatar;

  LocalUserData(
      {required this.email,
      required this.password,
      required this.alias,
      required this.avatar}) {
    loginState = true;
  }
}
