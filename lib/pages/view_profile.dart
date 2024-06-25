import 'package:chat4u/helpers/date_util.dart';
import 'package:chat4u/main.dart';
import 'package:chat4u/models/user.dart';
import 'package:chat4u/widgets/ui_design.dart';
import 'package:flutter/material.dart';

class ViewProfilePage extends StatefulWidget {
  final UserModel user;

  ViewProfilePage({super.key, required this.user});

  @override
  State<ViewProfilePage> createState() => _ViewProfilePageState();
}

class _ViewProfilePageState extends State<ViewProfilePage> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      //for hiding keyboard
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.user.name),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: mq.width * .05),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(width: mq.width, height: mq.height * .03),
                ImageURL(
                    image: widget.user.image,
                    wh: mq.height * .2,
                    hb: mq.height * .1),
                SizedBox(width: mq.width, height: mq.height * .03),
                Text(
                  widget.user.email,
                  style: TextStyle(color: Colors.black87, fontSize: 16),
                ),
                SizedBox(width: mq.width, height: mq.height * .02),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "About: ",
                      style: TextStyle(
                          color: Colors.black87,
                          fontSize: 15,
                          fontWeight: FontWeight.w500),
                    ),
                    Text(
                      widget.user.about,
                      style: TextStyle(color: Colors.black54, fontSize: 15),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Joined On: ",
              style: TextStyle(
                  color: Colors.black87,
                  fontSize: 15,
                  fontWeight: FontWeight.w500),
            ),
            Text(
              DateUtil.getLastMessageTime(context,
                  time: widget.user.created, showYear: true),
              style: TextStyle(color: Colors.black54, fontSize: 15),
            ),
          ],
        ),
      ),
    );
  }
}
