import 'package:chat4u/helpers/api.dart';
import 'package:chat4u/helpers/date_util.dart';
import 'package:chat4u/helpers/link.dart';
import 'package:chat4u/helpers/show_dialog.dart';
import 'package:chat4u/main.dart';
import 'package:chat4u/models/message.dart';
import 'package:chat4u/models/user.dart';
import 'package:chat4u/pages/chat.dart';
import 'package:chat4u/pages/view_profile.dart';
import 'package:chat4u/widgets/ui_design.dart';
import 'package:flutter/material.dart';

class UserCard extends StatefulWidget {
  final UserModel user;
  const UserCard({super.key, required this.user});

  @override
  State<UserCard> createState() => _UserCardState();
}

class _UserCardState extends State<UserCard> {
  MessageModel? messageModel;

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
        child: StreamBuilder(
          stream: Api.getLastMessage(model: widget.user),
          builder: (context, snapshot) {
            final data = snapshot.data?.docs;
            final items = data
                    ?.map((val) => MessageModel.fromJson(val.data()))
                    .toList() ??
                [];

            if (items.isNotEmpty) messageModel = items[0];

            return ListTile(
              // leading: CircleAvatar(
              //   child: Icon(Icons.person),
              // ),
              leading: InkWell(
                onTap: () {
                  ShowDialog.profile(context, model: widget.user, click: () {
                    LinkPage.linkBack(context);
                    LinkPage.link(
                      context,
                      widget: ViewProfilePage(user: widget.user),
                    );
                  });
                },
                child: ImageURL(
                    image: widget.user.image,
                    wh: mq.height * .055,
                    hb: mq.height * .3),
              ),
              title: Text(widget.user.name),
              subtitle: Text(
                  messageModel != null
                      ? messageModel!.message
                      : widget.user.about,
                  maxLines: 1),
              trailing: messageModel == null
                  ? null
                  : messageModel!.read == null &&
                          messageModel!.fromId != Api.user.uid
                      ? Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: Colors.greenAccent.shade400,
                            borderRadius: BorderRadius.circular(12),
                          ),
                        )
                      : Text(
                          DateUtil.getLastMessageTime(context,
                              time: messageModel!.sent),
                          style: TextStyle(color: Colors.black54),
                        ),
            );
          },
        ),
      ),
    );
  }
}
