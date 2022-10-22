import 'package:flutter/material.dart';
import 'package:flutter_sandbox/controllers/localUserController.dart';
import 'package:flutter_sandbox/main.dart';
import 'package:flutter_sandbox/screens/chatPage.dart';
import 'package:flutter_sandbox/screens/loginPage.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const ChatPage(),
      // Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.green.shade500,
        unselectedItemColor: Colors.grey.shade600,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
        type: BottomNavigationBarType.fixed,
        onTap: (value){
          if (value == 2) {
            LocalUserController().logout();
            Navigator.pushReplacementNamed(context, '/login');
          }
        },

        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: "Chats",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group_work),
            label: "Groups",
          ),
          BottomNavigationBarItem(

            icon: Icon(Icons.logout),
            label: "Logout",

          ),
        ],
      ),
    );
  }
}
