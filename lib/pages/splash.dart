import 'package:chat4u/helpers/api.dart';
import 'package:chat4u/helpers/link.dart';
import 'package:chat4u/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SplashPage extends StatefulWidget {
  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 2), () {
      //exit fullscreen
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
            statusBarColor: Colors.white,
            systemNavigationBarColor: Colors.white),
      );

      // log('\nUser: ${Api.auth.currentUser}');
      Api.auth.currentUser != null
          //navigate to home page
          ? LinkPage.linkReplaceName(context, route: "/home")

          //navigate to login page
          : LinkPage.linkReplaceName(context, route: "/login");
    });
  }

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text('Welcome to Splash'),
      ),
      body: Stack(
        children: [
          Positioned(
            top: mq.height * .15,
            right: mq.width * .25,
            width: mq.width * .5,
            child: Image.asset('images/chat.png'),
          ),
          Positioned(
            bottom: mq.height * .15,
            width: mq.width,
            child: Text(
              "MADE IN CAMBODIA WITH ❤️",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 16, color: Colors.black87, letterSpacing: .5),
            ),
          ),
        ],
      ),
    );
  }
}
