import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:chat4u/helpers/api.dart';
import 'package:chat4u/main.dart';
import 'package:chat4u/models/user.dart';
import 'package:chat4u/widgets/ui_design.dart';
import 'package:flutter/material.dart';
import 'package:timer_snackbar/timer_snackbar.dart';

class ShowDialog {
  static snakbar(context, {required String message}) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text(message, textAlign: TextAlign.center),
          backgroundColor: Colors.red.withOpacity(.8),
          behavior: SnackBarBehavior.floating),
    );
  }

  static animatedSnakbar(context,
      {required String message, required AnimatedSnackBarType snackbarType}) {
    return AnimatedSnackBar.material(
      message,
      borderRadius: BorderRadius.circular(20),
      type: snackbarType,
      duration: Duration(seconds: 5),
    ).show(context);
  }

  static timeSnackbar(context, {required String message}) {
    return timerSnackbar(
      context: context,
      contentText: message,
      afterTimeExecute: () => print("Operation Execute."),
      second: 5,
    );
  }

  static pogressbar(context) {
    return showDialog(
        context: context,
        builder: (_) => Center(child: CircularProgressIndicator()));
  }

  static bottomSheet(context) {
    return showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      builder: (_) => ListView(
        shrinkWrap: true,
        padding: EdgeInsets.only(top: mq.height * .03, bottom: mq.height * .05),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
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
      ),
    );
  }

  static profile(context, {required UserModel model, void Function()? click}) {
    return showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.white.withOpacity(.9),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: SizedBox(
          width: mq.width * 6,
          height: mq.height * .35,
          child: Stack(
            children: [
              Positioned(
                top: mq.height * .075,
                left: mq.width * .1,
                child: ImageURL(
                    image: model.image, wh: mq.width * .5, hb: mq.height * .25),
              ),
              Positioned(
                top: mq.width * .04,
                left: mq.height * .02,
                width: mq.width * .55,
                child: Text(
                  model.name,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Positioned(
                right: 8,
                top: 6,
                child: MaterialButton(
                  minWidth: 0,
                  padding: EdgeInsets.all(0),
                  shape: CircleBorder(),
                  onPressed: click,
                  child: Icon(
                    Icons.info_outline,
                    color: Colors.blue,
                    size: 30,
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
