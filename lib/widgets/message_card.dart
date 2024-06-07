import 'package:chat4u/helpers/api.dart';
import 'package:chat4u/helpers/date_util.dart';
import 'package:chat4u/main.dart';
import 'package:chat4u/models/message.dart';
import 'package:flutter/material.dart';

class MessageCard extends StatefulWidget {
  final MessageModel message;

  const MessageCard({super.key, required this.message});

  @override
  State<MessageCard> createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> {
  @override
  Widget build(BuildContext context) {
    return Api.user.uid == widget.message.fromId
        ? greenMessage(context)
        : blueMessage(context);
  }

  Widget blueMessage(BuildContext context) {
    //update last read message if reader and receiver are different
    if (widget.message.read == '') {
      Api.updateStatus(model: widget.message);
      print("Status has been updated!");
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Container(
            padding: EdgeInsets.all(mq.width * .04),
            margin: EdgeInsets.symmetric(
                horizontal: mq.width * .04, vertical: mq.height * .01),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.lightBlue),
              color: Colors.lightBlueAccent,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(26),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Text(
              widget.message.message,
              style: TextStyle(fontSize: 15, color: Colors.black87),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(right: 14),
          child: Row(
            children: [
              //double tick blue icon for message read
              widget.message.read != ''
                  ? Icon(
                      Icons.done_all_outlined,
                      color: Colors.green,
                      size: 20,
                    )
                  : Text(""),
              SizedBox(width: 2),
              Text(
                DateUtil.getFormatedTime(context, time: widget.message.sent),
                style: TextStyle(fontSize: 13, color: Colors.black54),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget greenMessage(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 14),
          child: Row(
            children: [
              //double tick blue icon for message read
              widget.message.read != ''
                  ? Icon(
                      Icons.done_all_outlined,
                      color: Colors.green,
                      size: 20,
                    )
                  : Text(""),
              SizedBox(width: 2),
              Text(
                DateUtil.getFormatedTime(context, time: widget.message.sent),
                style: TextStyle(fontSize: 13, color: Colors.black54),
              ),
            ],
          ),
        ),
        Flexible(
          child: Container(
            padding: EdgeInsets.all(mq.width * .04),
            margin: EdgeInsets.symmetric(
                horizontal: mq.width * .04, vertical: mq.height * .01),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.lightGreen),
              color: Colors.greenAccent,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(26),
                bottomLeft: Radius.circular(30),
              ),
            ),
            child: Text(
              widget.message.message,
              style: TextStyle(fontSize: 15, color: Colors.black87),
            ),
          ),
        ),
      ],
    );
  }
}
