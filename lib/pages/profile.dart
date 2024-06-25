import 'dart:io';

import 'package:chat4u/helpers/api.dart';
import 'package:chat4u/helpers/auth.dart';
import 'package:chat4u/helpers/link.dart';
import 'package:chat4u/helpers/show_dialog.dart';
import 'package:chat4u/main.dart';
import 'package:chat4u/models/user.dart';
import 'package:chat4u/widgets/ui_design.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  final UserModel user;

  ProfilePage({super.key, required this.user});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  var image = null;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      //for hiding keyboard
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Your Profile Page'),
        ),
        body: Form(
          key: formKey,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: mq.width * .05),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(width: mq.width, height: mq.height * .03),
                  Stack(children: [
                    image != null
                        ? ImageFile(image: image!, wh: .2, hb: .1)
                        : ImageURL(
                            image: widget.user.image,
                            wh: mq.height * .2,
                            hb: mq.height * .1),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: MaterialButton(
                        elevation: 1,
                        onPressed: () {
                          showBottomSheet();
                        },
                        shape: CircleBorder(),
                        color: Colors.white,
                        child: Icon(
                          Icons.edit,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ]),
                  SizedBox(width: mq.width, height: mq.height * .03),
                  Text(widget.user.email,
                      style: TextStyle(color: Colors.black, fontSize: 16)),
                  SizedBox(width: mq.width, height: mq.height * .03),
                  Input(
                      initVal: widget.user.name,
                      saved: (val) => Api.me.name = val ?? "",
                      checked: (val) => val != null && val.isNotEmpty
                          ? null
                          : "Required Field",
                      label: "Name",
                      icon: Icons.person,
                      hint: "eg. LANN Phorlly"),
                  Input(
                      initVal: widget.user.about,
                      saved: (val) => Api.me.about = val ?? "",
                      checked: (val) => val != null && val.isNotEmpty
                          ? null
                          : "Required Field",
                      label: "About",
                      icon: Icons.info,
                      hint: "eg. I'm Feeling Happy"),
                  Button(
                    click: () async {
                      if (formKey.currentState!.validate()) {
                        formKey.currentState!.save();
                        await Api.updateUser().whenComplete(() {
                          ShowDialog.timeSnackbar(
                            context,
                            message: "Has been updated!",
                            // snackbarType: AnimatedSnackBarType.info,
                          );
                          LinkPage.linkBack(context);
                        });
                      }
                    },
                    icon: Icons.update,
                    label: "Update",
                    color: Colors.green,
                    width: 500,
                  ),
                ],
              ),
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: Colors.redAccent,
          foregroundColor: Colors.white,
          onPressed: () async {
            await Auth.logout(context, routName: "/login");
          },
          icon: Icon(Icons.logout),
          label: Text("Logout"),
        ),
      ),
    );
  }

  void showBottomSheet() {
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
            padding:
                EdgeInsets.only(top: mq.height * .03, bottom: mq.height * .05),
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                child: Text(
                  "Pick a profile picture",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ImageButton(
                    width: .3,
                    height: .12,
                    click: () async {
                      await Api.fromCamera(context).then((value) async {
                        setState(() {
                          image = value.toString();
                        });
                        await Api.updateProfile(File(image!)).whenComplete(() {
                          ShowDialog.timeSnackbar(
                            context,
                            message: "Has been updated!",
                            // snackbarType: AnimatedSnackBarType.info,
                          );
                          LinkPage.linkBack(context);
                        });
                      });
                    },
                    imagePath: "images/camera.png",
                  ),
                  ImageButton(
                    width: .3,
                    height: .12,
                    click: () async {
                      await Api.fromGallery(context).then((value) {
                        setState(() {
                          image = value;
                        });
                        print("The image path => $image");
                        Api.updateProfile(File(image!)).whenComplete(() {
                          ShowDialog.timeSnackbar(
                            context,
                            message: "Has been updated!",
                            // snackbarType: AnimatedSnackBarType.info,
                          );
                          LinkPage.linkBack(context);
                        });
                      });
                    },
                    imagePath: "images/picture.png",
                  ),
                ],
              ),
            ],
          );
        });
  }
}
