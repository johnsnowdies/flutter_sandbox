import 'package:flutter/material.dart';
import 'package:flutter_sandbox/models/chatUsersModel.dart';
import 'package:flutter_sandbox/widgets/conversationList.dart';

class ChatPage extends StatefulWidget {

  const ChatPage({super.key});



  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {

  List<ChatUsers> getChatUsers(){
    return [
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

  List<ChatUsers> chatUsers = [];

  @override
  Widget build(BuildContext context) {
    chatUsers = getChatUsers();

    return Scaffold(
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(

          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[

            SafeArea(
              child: Padding(
                padding: EdgeInsets.only(left: 16, right: 16, top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      "My Dudes",
                      style:
                          TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                    ),
                    Container(
                      padding:
                          EdgeInsets.only(left: 8, right: 8, top: 2, bottom: 2),
                      height: 30,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.green[50],
                      ),
                      child: Row(
                        children: <Widget>[
                          Icon(
                            Icons.add,
                            color: Colors.green.shade500,
                            size: 20,
                          ),
                          SizedBox(
                            width: 2,
                          ),
                          Text(
                            "Add New",
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                        ],

                      ),
                    ),

                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 16,left: 16,right: 16),
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Search...",
                  hintStyle: TextStyle(color: Colors.grey.shade600),
                  prefixIcon: Icon(Icons.search,color: Colors.grey.shade600, size: 20,),
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  contentPadding: EdgeInsets.all(8),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(
                          color: Colors.grey.shade100
                      )
                  ),
                ),
              ),
            ),
            ListView.builder(
              itemCount: chatUsers.length,
              shrinkWrap: true,
              padding: EdgeInsets.only(top: 16),
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index){
                return ConversationList(
                  user: chatUsers[index],
                  isMessageRead: (index == 0 || index == 3)?true:false,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
