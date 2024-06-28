import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:chat4u/helpers/api.dart';
import 'package:chat4u/helpers/link.dart';
import 'package:chat4u/helpers/show_dialog.dart';
import 'package:chat4u/main.dart';
import 'package:chat4u/models/user.dart';
import 'package:chat4u/widgets/ui_design.dart';
import 'package:chat4u/widgets/user_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<UserModel> listItems = [];
  final List<UserModel> search = [];
  var isSearching = false;

  @override
  void initState() {
    super.initState();
    Api.getCurrentUser();
    //for setting user status to active
    // Api.updateActiveStatus(true);

    //for updating user active status according to lifecycle envents
    //resume --active or online
    //pause --inactive or offline
    SystemChannels.lifecycle.setMessageHandler((message) {
      print("Your message is: $message");

      if (Api.auth.currentUser != null) {
        if (message.toString().contains("resume")) Api.updateActiveStatus(true);
        if (message.toString().contains("pause")) Api.updateActiveStatus(false);
      }

      return Future.value(message);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      //for hiding keyboard when a tap is detected on search
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                LinkPage.linkReplaceName(context, route: "/");
              },
              icon: Icon(Icons.home)),
          title: isSearching
              ? TextField(
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Find by name or email..."),
                  autofocus: true,
                  style: TextStyle(fontSize: 16, letterSpacing: .5),
                  onChanged: (val) {
                    search.clear();
                    for (var item in listItems) {
                      if (item.name.toLowerCase().contains(val.toLowerCase()) ||
                          item.email
                              .toLowerCase()
                              .contains(val.toLowerCase())) {
                        search.add(item);
                      }
                      setState(() {
                        search;
                      });
                    }
                  },
                )
              : Text('Chat 4U'),
          actions: [
            IconButton(
                onPressed: () {
                  setState(() {
                    isSearching = !isSearching;
                  });
                },
                icon: Icon(isSearching ? Icons.clear : Icons.search)),
            IconButton(
                onPressed: () {
                  LinkPage.linkName(context, route: "/profile");
                },
                icon: Icon(Icons.person)),
          ],
        ),
        body: StreamBuilder(
          stream: Api.getFriendsId(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
              case ConnectionState.none:
                return Center(child: CircularProgressIndicator());

              //if some  or all data is loaded then show it
              case ConnectionState.active:
              case ConnectionState.done:
                return StreamBuilder(
                  stream: Api.getUsers(
                      friends:
                          snapshot.data?.docs.map((val) => val.id).toList() ??
                              []),
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      //if data id loading
                      case ConnectionState.waiting:
                      case ConnectionState.none:
                        return Center(child: CircularProgressIndicator());

                      //if some  or all data is loaded then show it
                      case ConnectionState.active:
                      case ConnectionState.done:
                        var datas = snapshot.data?.docs;
                        listItems = datas!
                            .map((res) => UserModel.fromJson(res.data()))
                            .toList();

                        if (listItems.isNotEmpty) {
                          return ListView.builder(
                              itemCount: isSearching
                                  ? search.length
                                  : listItems.length,
                              physics: BouncingScrollPhysics(),
                              padding: EdgeInsets.only(top: mq.height * .01),
                              itemBuilder: (context, index) {
                                return UserCard(
                                    user: isSearching
                                        ? search[index]
                                        : listItems[index]);
                              });
                        } else {
                          return Center(
                            child: Text(
                              "No Connections Found",
                              style: TextStyle(fontSize: 20),
                            ),
                          );
                        }
                    }
                  },
                );
            }
          },
        ),
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              showAddFriendDialog();
            },
            child: Icon(Icons.add_comment_rounded)),
      ),
    );
  }

  void showAddFriendDialog() {
    var email = "";

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Row(
          children: [
            Icon(
              Icons.person_add,
              color: Colors.blue,
              size: 28,
            ),
            Text(" Add Friend"),
          ],
        ),
        content: Input(
          hint: "Input Email-Address",
          label: "Email Address",
          changed: (val) => email = val!,
          icon: Icons.email,
        ),
        actions: [
          Button(
            label: "Cancel",
            icon: Icons.cancel,
            color: Colors.black,
            click: () {
              LinkPage.linkBack(context);
            },
          ),
          Button(
            label: "Add",
            icon: Icons.add,
            color: Colors.blue,
            click: () async {
              LinkPage.linkBack(context);

              if (email.isNotEmpty)
                await Api.addNew(email: email).then((val) {
                  if (!val)
                    ShowDialog.animatedSnakbar(context,
                        message: "User does not Exists!",
                        snackbarType: AnimatedSnackBarType.error);
                });
            },
          ),
        ],
      ),
    );
  }
}
