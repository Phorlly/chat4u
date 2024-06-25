import 'package:chat4u/helpers/api.dart';
import 'package:chat4u/main.dart';
import 'package:chat4u/models/message.dart';
import 'package:chat4u/models/user.dart';
import 'package:chat4u/widgets/message_card.dart';
import 'package:flutter/material.dart';

class ChatMessage extends StatefulWidget {
  final UserModel user;
  const ChatMessage({super.key, required this.user});

  @override
  State<ChatMessage> createState() => _ChatMessageState();
}

class _ChatMessageState extends State<ChatMessage> {
  List<MessageModel> listItems = [];

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: StreamBuilder(
        stream: Api.getMessages(model: widget.user),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            //if data id loading
            case ConnectionState.waiting:
            case ConnectionState.none:
              return Center(child: CircularProgressIndicator());

            //if some  or all data is loaded then show it
            case ConnectionState.active:
            case ConnectionState.done:
              // Extract data from snapshot
              var datas = snapshot.data!.docs;

              listItems = datas
                  .map((res) => MessageModel.fromJson(res.data()))
                  .toList();

              return listItems.isNotEmpty
                  ? ListView.builder(
                    reverse: true,
                      itemCount: listItems.length,
                      physics: BouncingScrollPhysics(),
                      padding: EdgeInsets.only(top: mq.height * .01),
                      itemBuilder: (context, index) {
                        return MessageCard(message: listItems[index]);
                      })
                  : Center(
                      child: Text(
                        "Say Hi! 👋",
                        style: TextStyle(fontSize: 24),
                      ),
                    );
          }
        },
      ),
    );
  }
}
