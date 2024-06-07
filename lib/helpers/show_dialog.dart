import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:chat4u/helpers/api.dart';
import 'package:chat4u/main.dart';
import 'package:chat4u/widgets/ui_design.dart';
import 'package:flutter/material.dart';
import 'package:timer_snackbar/timer_snackbar.dart';

class ShowDialog {
  static showSnakbar(context, {message}) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text(message, textAlign: TextAlign.center),
          backgroundColor: Colors.red.withOpacity(.8),
          behavior: SnackBarBehavior.floating),
    );
  }

  static showAnimatedSnakbar(context, {message, snackbarType}) {
    return AnimatedSnackBar.material(
      message,
      borderRadius: BorderRadius.circular(20),
      type: snackbarType,
      duration: Duration(seconds: 5),
    ).show(context);
  }

  static showTimerSnackbar(context, {message}) {
    return timerSnackbar(
      context: context,
      contentText: message,
      afterTimeExecute: () => print("Operation Execute."),
      second: 5,
    );
  }

  static showProgressbar(context) {
    return showDialog(
        context: context,
        builder: (_) => Center(child: CircularProgressIndicator()));
  }

  static showBottomSheet(context) {
    return showModalBottomSheet(
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
                      await Api.fromCamera(context);
                    },
                    imagePath: "images/camera.png",
                  ),
                  ImageButton(
                    width: .3,
                    height: .12,
                    click: () async {
                      await Api.fromGallery(context);
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
