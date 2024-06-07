import 'package:chat4u/helpers/link.dart';
import 'package:chat4u/main.dart';
import 'package:chat4u/models/user.dart';
import 'package:chat4u/pages/chat.dart';
import 'package:chat4u/widgets/ui_design.dart';
import 'package:flutter/material.dart';

class UserCard extends StatefulWidget {
  final UserModel user;
  const UserCard({super.key, required this.user});

  @override
  State<UserCard> createState() => _UserCardState();
}

class _UserCardState extends State<UserCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: mq.width * .01, vertical: 2),
      // color: Colors.blue.shade100,
      elevation: .5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          LinkPage.link(context, widget: ChatPage(user: widget.user));
        },
        child: ListTile(
          // leading: CircleAvatar(
          //   child: Icon(Icons.person),
          // ),
          leading: ImageURL(image: widget.user.image, wh: .055, hb: .3),
          title: Text(widget.user.name),
          subtitle: Text(widget.user.about, maxLines: 1),
          trailing: Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: Colors.greenAccent.shade400,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          // trailing: Text(
          //   '12:00 PM',
          //   style: TextStyle(color: Colors.black54),
          // ),
        ),
      ),
    );
  }
}
