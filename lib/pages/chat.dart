import 'package:chat4u/models/user.dart';
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
    return Container();
  }
}
