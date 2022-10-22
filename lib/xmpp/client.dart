import 'dart:async';
import 'dart:convert';

import 'package:xmpp_stone/xmpp_stone.dart' as xmpp;
import 'dart:io';
import 'package:console/console.dart';
import 'package:image/image.dart' as image;

final String TAG = 'example';

class XMPPClient {
  static final XMPPClient _xmppClient = XMPPClient._internal();
  late xmpp.Connection _connection;
  xmpp.MessagesListener _messagesListener = MessagesListener();

  factory XMPPClient() {
    return _xmppClient;
  }

  XMPPClient init({required String email, required String password}){
    var jid = xmpp.Jid.fromFullJid(email);
    _connection = xmpp.Connection(xmpp.XmppAccountSettings(
        email, jid.local, jid.domain, password, 5222,
        resource: 'xmppstone'));

    return _xmppClient;
  }

  Future<void> openConnection() async{
    _connection.connect();

    ConnectionStateChangedListener(_connection, _messagesListener);
    var presenceManager = xmpp.PresenceManager.getInstance(_connection);
    presenceManager.subscriptionStream.listen((streamEvent) {
      if (streamEvent.type == xmpp.SubscriptionEventType.REQUEST) {
        print('Accepting presence request');
        presenceManager.acceptSubscription(streamEvent.jid);
      }
    });

    await Future.delayed(const Duration(seconds: 5));
  }

  xmpp.XmppConnectionState getConnectionState(){
    return _connection.state;
  }

  void closeConnection() {
    _connection.close();
  }

  bool isAuthenticated(){
    return _connection.authenticated;
  }

  void getMessages() {}

  XMPPClient._internal();
}


class ConnectionStateChangedListener implements xmpp.ConnectionStateChangedListener {
  late xmpp.Connection _connection;
  late xmpp.MessagesListener _messagesListener;

  late StreamSubscription<String> subscription;

  ConnectionStateChangedListener(xmpp.Connection connection, xmpp.MessagesListener messagesListener) {
    _connection = connection;
    _messagesListener = messagesListener;
    _connection.connectionStateStream.listen(onConnectionStateChanged);
  }

  @override
  void onConnectionStateChanged(xmpp.XmppConnectionState state) {
    if (state == xmpp.XmppConnectionState.Ready) {
      print('Connected');
      var vCardManager = xmpp.VCardManager(_connection);
      vCardManager.getSelfVCard().then((vCard) {
        if (vCard != null) {
          print('Your info' + vCard.buildXmlString());
        }
      });
      var messageHandler = xmpp.MessageHandler.getInstance(_connection);
      var rosterManager = xmpp.RosterManager.getInstance(_connection);
      messageHandler.messagesStream.listen(_messagesListener.onNewMessage);
      sleep(const Duration(seconds: 1));
      var receiver = 'nemanja2@test';
      var receiverJid = xmpp.Jid.fromFullJid(receiver);
      rosterManager.addRosterItem(xmpp.Buddy(receiverJid)).then((result) {
        if (result.description != null) {
          print('add roster' + result.description);
        }
      });
      sleep(const Duration(seconds: 1));
      vCardManager.getVCardFor(receiverJid).then((vCard) {
        if (vCard != null) {
          print('Receiver info' + vCard.buildXmlString());
          if (vCard != null && vCard.image != null) {
            var file = File('test456789.jpg')..writeAsBytesSync(image.encodeJpg(vCard.image));
            print('IMAGE SAVED TO: ${file.path}');
          }
        }
      });
      var presenceManager = xmpp.PresenceManager.getInstance(_connection);
      presenceManager.presenceStream.listen(onPresence);
    }
  }

  void onPresence(xmpp.PresenceData event) {
    print('presence Event from ' + event.jid.fullJid + ' PRESENCE: ' + event.showElement.toString());
  }
}

Stream<String> getConsoleStream() {
  return Console.adapter.byteStream().map((bytes) {
    var str = ascii.decode(bytes);
    str = str.substring(0, str.length - 1);
    return str;
  });
}

class MessagesListener implements xmpp.MessagesListener {
  @override
  void onNewMessage(xmpp.MessageStanza message) {
    if (message.body != null) {
      print(format(
          'New Message from {color.blue}${message.fromJid.userAtDomain}{color.end} message: {color.red}${message.body}{color.end}'));
    }
  }
}