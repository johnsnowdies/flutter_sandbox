import 'package:flutter/material.dart';
import 'package:flutter_sandbox/screens/homePage.dart';
import 'package:flutter_sandbox/screens/loginPage.dart';

import 'controllers/localUserController.dart';

void main() {
  runApp(const MainPage());
}

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'My Dudes',
        routes: {
          '/home' : (BuildContext context)=>const HomePage(),
          '/login' : (BuildContext context)=>const LoginPage(),
        },
        theme: ThemeData(
          primarySwatch: Colors.green,
        ),
        debugShowCheckedModeBanner: false,
        home: LocalUserController().isLogin()
            ? const HomePage()
            : const LoginPage());
  }
}
