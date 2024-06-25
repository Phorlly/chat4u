import 'dart:io';

import 'package:chat4u/helpers/api.dart';
import 'package:chat4u/helpers/date_util.dart';
import 'package:chat4u/helpers/link.dart';
import 'package:chat4u/models/message.dart';
import 'package:chat4u/main.dart';
import 'package:chat4u/models/user.dart';
import 'package:chat4u/pages/view_profile.dart';
import 'package:chat4u/widgets/bottombar.dart';
import 'package:chat4u/widgets/chat_message.dart';
import 'package:chat4u/widgets/topbar.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ChatPage extends StatefulWidget {
  final UserModel user;
  const ChatPage({Key? key, required this.user}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final message = new TextEditingController();
  final scroller = ScrollController();
  bool isShowEmoji = false, isUploading = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            flexibleSpace: StreamBuilder(
              stream: Api.getUserInfo(widget.user),
              builder: (context, snapshot) {
                final data = snapshot.data?.docs;
                final items = data
                        ?.map((val) => UserModel.fromJson(val.data()))
                        .toList() ??
                    [];

                return Topbar(
                  tap: () {
                    LinkPage.link(context,
                        widget: ViewProfilePage(user: widget.user));
                  },
                  photo: items.isNotEmpty ? items[0].image : widget.user.image,
                  title: items.isNotEmpty ? items[0].name : widget.user.name,
                  subtitle: items.isNotEmpty
                      ? items[0].isOnline
                          ? "Online"
                          : DateUtil.getLastActive(context,
                              lastActive: items[0].lastActive)
                      : DateUtil.getLastActive(context,
                          lastActive: widget.user.lastActive),
                  colorSubtitle:
                      items[0].isOnline ? Colors.green : Colors.black54,
                  click: () {
                    LinkPage.linkBack(context);
                  },
                );
              },
            ),
          ),
          body: Column(
            children: [
              ChatMessage(
                user: widget.user,
              ),
              if (isUploading)
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 25),
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                    ),
                  ),
                ),
              Bottombar(
                user: widget.user,
                fromCamera: () async {
                  await Api.fromCamera(context).then((val) async {
                    setState(() => isUploading = true);
                    await Api.sendImage(model: widget.user, file: File(val));
                    setState(() => isUploading = false);
                  });
                },
                fromGallery: () async {
                  final picker = ImagePicker();
                  List<XFile> images =
                      await picker.pickMultiImage(imageQuality: 70);

                  for (var item in images) {
                    print("The image path: ${item.path}");
                    setState(() => isUploading = true);

                    await Api.sendImage(
                        model: widget.user, file: File(item.path));
                    setState(() => isUploading = false);
                  }
                },
                clickTap: () {
                  if (isShowEmoji) setState(() => isShowEmoji = !isShowEmoji);
                },
                inputMessage: message,
                showEmoji: () {
                  FocusScope.of(context).unfocus();
                  setState(() => isShowEmoji = !isShowEmoji);
                },
                sendMessage: () {
                  if (message.text.isNotEmpty) {
                    Api.sendMessage(
                            model: widget.user,
                            message: message.text,
                            type: Type.text)
                        .whenComplete(() {
                      Center(child: CircularProgressIndicator());
                      message.text = "";
                    }).catchError((err) {
                      print("Has error: " + err.toString());
                    });
                  }
                },
              ),
              if (isShowEmoji)
                SizedBox(
                  height: mq.height * .35,
                  child: EmojiPicker(
                    textEditingController: message,
                    scrollController: scroller,
                    config: Config(
                      emojiViewConfig: EmojiViewConfig(
                        emojiSizeMax: 28 * (Platform.isIOS ? 1.20 : 1.0),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
