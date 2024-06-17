import 'package:chat4u/helpers/link.dart';
import 'package:chat4u/models/user.dart';
import 'package:chat4u/widgets/bottombar.dart';
import 'package:chat4u/widgets/chat_message.dart';
import 'package:chat4u/widgets/topbar.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  final UserModel user;
  const ChatPage({Key? key, required this.user}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        flexibleSpace: Topbar(
          photo: widget.user.image,
          title: widget.user.name,
          subtitle: widget.user.lastActive,
          click: () {
            LinkPage.linkBack(context);
          },
        ),
      ),
      body: Column(
        children: [
          ChatMessage(
            user: widget.user,
          ),
          Bottombar(
            user: widget.user,
          ),
        ],
      ),
    );
  }
}
