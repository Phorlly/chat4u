// import 'package:device_preview/device_preview.dart';
// import 'package:flutter/foundation.dart';
import 'package:chat4u/pages/home.dart';
import 'package:chat4u/pages/login.dart';
import 'package:flutter/material.dart';

//global object for accessing device screen size
late Size mq;

void main() {
  runApp(const MyApp());
  // runApp(
  //   DevicePreview(
  //     enabled: !kReleaseMode,
  //     builder: (context) => MyApp(), // Wrap your app
  //   ),
  // );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Chat-App',
      // locale: DevicePreview.locale(context),
      // builder: DevicePreview.appBuilder,
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          shadowColor: Colors.blue,
          centerTitle: true,
          elevation: 2,
          iconTheme: IconThemeData(color: Colors.black),
          backgroundColor: Colors.white,
          titleTextStyle: TextStyle(
              color: Colors.black, fontWeight: FontWeight.normal, fontSize: 19),
        ),
      ),
      home: LoginPage(),
      initialRoute: "/",
      routes: {
        "/home": (context) => HomePage(),
      },
    );
  }
}
