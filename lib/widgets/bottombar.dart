import 'package:chat4u/helpers/api.dart';
import 'package:chat4u/main.dart';
import 'package:chat4u/models/user.dart';
import 'package:flutter/material.dart';

class Bottombar extends StatefulWidget {
  final UserModel user;
  const Bottombar({super.key, required this.user});

  @override
  State<Bottombar> createState() => _BottombarState();
}

class _BottombarState extends State<Bottombar> {
  final message = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: mq.height * .01, horizontal: mq.width * .03),
      child: Row(
        children: [
          Expanded(
            child: Card(
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.emoji_emotions,
                      color: Colors.blue,
                      size: 25,
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      controller: message,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      decoration: InputDecoration(
                        hintText: "Type a message",
                        hintStyle: TextStyle(color: Colors.blueAccent),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.image_rounded,
                      color: Colors.blue,
                      size: 26,
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.camera_alt_outlined,
                      color: Colors.blue,
                      size: 26,
                    ),
                  ),
                ],
              ),
            ),
          ),
          MaterialButton(
            onPressed: () {
              if (message.text.isNotEmpty) {
                Api.sendMessage(model: widget.user, message: message.text)
                    .whenComplete(() {
                  Center(child: CircularProgressIndicator());
                  message.text = "";
                }).catchError((err) {
                  print("Has error: " + err.toString());
                });
              }
            },
            // enableFeedback: false,
            minWidth: 0,
            padding: EdgeInsets.only(top: 10, bottom: 10, right: 5, left: 10),
            shape: CircleBorder(),
            color: Colors.blueAccent,
            child: Icon(
              Icons.send,
              color: Colors.white,
              size: 26,
            ),
          ),
        ],
      ),
    );
  }
}
