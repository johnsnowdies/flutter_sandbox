import 'package:flutter_sandbox/models/localUserDataModel.dart';
import 'package:flutter_sandbox/utils/exceptions.dart';
import 'package:flutter_sandbox/utils/sharedPrefs.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xmpp_stone/xmpp_stone.dart';

import '../models/chatMessageModel.dart';
import '../models/chatUsersModel.dart';
import '../xmpp/client.dart';

class LocalUserController {
  static final LocalUserController _localUserController = LocalUserController._internal();
  dynamic _localUser = AnonymousUserData();

  late List<ChatMessage> messages;
  late List<ChatUsers> chats;

  factory LocalUserController() {
    _localUserController._init();

    return _localUserController;
  }

  void _init() async {
      await SharedPrefs().init().then((value) => {_loadUser()});
      chats = [
        ChatUsers(name: "Анастейшa Умбер", messageText: "Awesome Setup", imageURL: "https://eslider.ru/images/userImage1.jpeg", time: "Now"),
        ChatUsers(name: "Glady's Murphy", messageText: "That's Great", imageURL: "https://eslider.ru/images/userImage2.jpeg", time: "Yesterday"),
        ChatUsers(name: "Jorge Henry", messageText: "Hey where are you?", imageURL: "https://eslider.ru/images/userImage3.jpeg", time: "31 Mar"),
        ChatUsers(name: "Philip Fox", messageText: "Busy! Call me in 20 mins", imageURL: "https://eslider.ru/images/userImage4.jpeg", time: "28 Mar"),
        ChatUsers(name: "Debra Hawkins", messageText: "Thankyou, It's awesome", imageURL: "https://eslider.ru/images/userImage5.jpeg", time: "23 Mar"),
        ChatUsers(name: "Jacob Pena", messageText: "will update you in evening", imageURL: "https://eslider.ru/images/userImage6.jpeg", time: "17 Mar"),
        ChatUsers(name: "Andrey Jones", messageText: "Can you please share the file?", imageURL: "https://eslider.ru/images/userImage7.jpeg", time: "24 Feb"),
        ChatUsers(name: "John Wick", messageText: "How are you?", imageURL: "https://eslider.ru/images/userImage8.jpeg", time: "18 Feb"),
      ];

  }

  void _loadUser() async {
    if (SharedPrefs().getBool('local_user_is_login') ?? false) {
      _localUser = LocalUserData(
        email: SharedPrefs().getString('local_user_email') ?? '',
        password: SharedPrefs().getString('local_user_password') ?? '',
        alias: SharedPrefs().getString('local_user_alias') ?? '',
        avatar: SharedPrefs().getString('local_user_avatar') ?? '',
      );

      await login(_localUser.email, _localUser.password);
    }
  }

  void _flushUser() {
    _localUser = AnonymousUserData();
  }

  bool isLogin() {
    return _localUser.loginState;
  }

  Future<void> login(String email, String password) async {

    await XMPPClient().init(email: email, password: password).openConnection();

    var state = XMPPClient().getConnectionState();

    if (state == XmppConnectionState.ForcefullyClosed){
      throw XMPPServerConnectionException();
    }

    if (!XMPPClient().isAuthenticated()){
      throw XMPPAuthenticationException();
    }

    SharedPrefs().setBool('local_user_is_login', true);
    SharedPrefs().setString('local_user_email', email);
    SharedPrefs().setString('local_user_password', password);

    _loadUser();
  }

  void logout() {
    XMPPClient().closeConnection();
    SharedPrefs().setBool('local_user_is_login', false);
    SharedPrefs().setString('local_user_email', '');
    SharedPrefs().setString('local_user_password', '');

    _flushUser();
  }

  LocalUserController._internal();
}
