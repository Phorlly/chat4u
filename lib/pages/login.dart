import 'package:chat4u/main.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isAnimated = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(microseconds: 500), () {
      setState(() {
        isAnimated = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text('Welcome to Chat 4U'),
      ),
      body: Stack(
        children: [
          AnimatedPositioned(
            top: mq.height * .15,
            right: isAnimated ? mq.width * .25 : -mq.width * .5,
            width: mq.width * .5,
            duration: Duration(seconds: 1),
            child: Image.asset('images/chat.png'),
          ),
          Positioned(
            bottom: mq.height * .15,
            left: mq.width * .05,
            width: mq.width * .9,
            height: mq.height * .06,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 223, 255, 187),
                  shape: StadiumBorder(),
                  elevation: 2),
              onPressed: () {
                Navigator.pushReplacementNamed(context, "/home");
              },
              icon: Image.asset('images/google.png', height: mq.height * .03),
              label: RichText(
                text: TextSpan(
                    style: TextStyle(color: Colors.black, fontSize: 16),
                    children: [
                      TextSpan(text: "Sign In with "),
                      TextSpan(
                        text: "Google",
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ]),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
