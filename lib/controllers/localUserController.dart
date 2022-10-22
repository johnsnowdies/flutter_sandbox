import 'package:flutter_sandbox/models/localUserDataModel.dart';
import 'package:flutter_sandbox/utils/exceptions.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xmpp_stone/xmpp_stone.dart';

import '../xmpp/client.dart';

class LocalUserController {
  static final LocalUserController _localUserController = LocalUserController._internal();
  late SharedPreferences _prefs;

  AnonymousUserData _localUser = AnonymousUserData();

  factory LocalUserController() {
    _localUserController._loadUser();
    _localUserController._init();
    return _localUserController;
  }

  void _init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  void _loadUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getBool('local_user_is_login') ?? false) {
      _localUser = LocalUserData(
        email: prefs.getString('local_user_email') ?? '',
        password: prefs.getString('local_user_password') ?? '',
        alias: prefs.getString('local_user_alias') ?? '',
        avatar: prefs.getString('local_user_avatar') ?? '',
      );
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

    print(state);

    if (state == XmppConnectionState.ForcefullyClosed){
      throw XMPPServerConnectionException();
    }

    print(XMPPClient().isAuthenticated());

    if (!XMPPClient().isAuthenticated()){
      throw XMPPAuthenticationException();
    }

    _prefs.setBool('local_user_is_login', true);
    _prefs.setString('local_user_email', email);
    _prefs.setString('local_user_password', password);

    _loadUser();
  }

  void logout() {
    _prefs.setBool('local_user_is_login', false);
    _prefs.setString('local_user_email', '');
    _prefs.setString('local_user_password', '');

    _flushUser();
  }

  LocalUserController._internal();
}
