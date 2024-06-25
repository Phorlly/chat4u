import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:chat4u/helpers/api.dart';
import 'package:chat4u/helpers/date_util.dart';
import 'package:chat4u/helpers/link.dart';
import 'package:chat4u/helpers/show_dialog.dart';
import 'package:chat4u/main.dart';
import 'package:chat4u/models/message.dart';
import 'package:chat4u/widgets/ui_design.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MessageCard extends StatefulWidget {
  final MessageModel message;

  const MessageCard({super.key, required this.message});

  @override
  State<MessageCard> createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> {
  @override
  Widget build(BuildContext context) {
    bool isMe = Api.user.uid == widget.message.fromId;
    return InkWell(
      onLongPress: () {
        showBottomSheet(isMe);
        print("Your welcom");
      },
      child: isMe ? greenMessage() : blueMessage(),
    );
  }

  Widget blueMessage() {
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
            padding: EdgeInsets.all(widget.message.type == Type.image
                ? mq.width * .001
                : mq.width * .04),
            margin: EdgeInsets.symmetric(
                horizontal: mq.width * .04, vertical: mq.height * .01),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.lightBlue),
              color: Colors.lightBlueAccent,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25),
                topRight: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
            ),
            child: widget.message.type == Type.text
                ? Text(
                    widget.message.message,
                    style: TextStyle(fontSize: 15, color: Colors.black87),
                  )
                : ImageURL(
                    image: widget.message.message,
                    hb: 12,
                    size: 70,
                    icon: Icons.image,
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

  Widget greenMessage() {
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
            padding: EdgeInsets.all(widget.message.type == Type.image
                ? mq.width * .001
                : mq.width * .04),
            margin: EdgeInsets.symmetric(
                horizontal: mq.width * .04, vertical: mq.height * .01),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.lightGreen),
              color: Colors.greenAccent,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(25),
                bottomLeft: Radius.circular(12),
              ),
            ),
            child: widget.message.type == Type.text
                ? Text(
                    widget.message.message,
                    style: TextStyle(fontSize: 15, color: Colors.black87),
                  )
                : ImageURL(
                    image: widget.message.message,
                    hb: 12,
                    size: 70,
                    icon: Icons.image,
                  ),
          ),
        ),
      ],
    );
  }

  void showBottomSheet(bool isMe) {
    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        builder: (_) {
          return ListView(
            shrinkWrap: true,
            children: [
              Container(
                height: 4,
                margin: EdgeInsets.symmetric(
                    vertical: mq.height * .015, horizontal: mq.width * .4),
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              widget.message.type == Type.image
                  ? itemOption(
                      icon: Icon(
                        Icons.download_rounded,
                        color: Colors.blue,
                        size: 26,
                      ),
                      name: "Save Image",
                      tap: () {},
                    )
                  : itemOption(
                      icon: Icon(
                        Icons.copy_all_rounded,
                        color: Colors.blue,
                        size: 26,
                      ),
                      name: "Copy Text",
                      tap: () async {
                        await Clipboard.setData(
                                ClipboardData(text: widget.message.message))
                            .whenComplete(() {
                          LinkPage.linkBack(context);
                          ShowDialog.animatedSnakbar(context,
                              message: "Text Copied!",
                              snackbarType: AnimatedSnackBarType.info);
                        });
                      },
                    ),
              if (isMe)
                Divider(
                  color: Colors.black54,
                  endIndent: mq.width * .04,
                  indent: mq.width * .04,
                ),
              if (widget.message.type == Type.text && isMe)
                itemOption(
                  icon: Icon(
                    Icons.edit,
                    color: Colors.blue,
                    size: 26,
                  ),
                  name: "Edit Message",
                  tap: () {},
                ),
              if (isMe)
                itemOption(
                  icon: Icon(
                    Icons.delete_forever,
                    color: Colors.red,
                    size: 26,
                  ),
                  name: "Delete Message",
                  tap: () async {
                    await Api.deleteMessage(model: widget.message)
                        .whenComplete(() {
                      LinkPage.linkBack(context);
                      ShowDialog.animatedSnakbar(context,
                          message: "Message Deleted!",
                          snackbarType: AnimatedSnackBarType.success);
                    });
                  },
                ),
              Divider(
                color: Colors.black54,
                endIndent: mq.width * .04,
                indent: mq.width * .04,
              ),
              itemOption(
                icon: Icon(
                  Icons.remove_red_eye,
                  color: Colors.blue,
                  size: 26,
                ),
                name:
                    "Sent At: ${DateUtil.getMessageTime(context, time: widget.message.sent)}",
                tap: () {},
              ),
              itemOption(
                icon: Icon(
                  Icons.remove_red_eye,
                  color: Colors.green,
                  size: 26,
                ),
                name: widget.message.read == null
                    ? "Read At: Not seen yet!"
                    : "Read At: ${DateUtil.getMessageTime(context, time: widget.message.read)}",
                tap: () {},
              ),
            ],
          );
        });
  }

  Widget itemOption(
      {required Icon icon, required String name, required VoidCallback tap}) {
    return InkWell(
      onTap: () => tap(),
      child: Padding(
        padding: EdgeInsets.only(
          left: mq.width * .05,
          top: mq.height * .015,
          bottom: mq.height * .015,
        ),
        child: Row(
          children: [
            icon,
            Flexible(
              child: Text(
                '  $name',
                style: TextStyle(
                    fontSize: 15, color: Colors.black54, letterSpacing: .5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
