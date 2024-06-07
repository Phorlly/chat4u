// import 'package:device_preview/device_preview.dart';
// import 'package:flutter/foundation.dart';
import 'package:chat4u/helpers/api.dart';
import 'package:chat4u/pages/home.dart';
import 'package:chat4u/pages/login.dart';
import 'package:chat4u/pages/profile.dart';
import 'package:chat4u/pages/splash.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

//global object for accessing device screen size
late Size mq;
var formKey = GlobalKey<FormState>();

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  //enter full screen
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  //for setting orientation to portrait only
  SystemChrome.setPreferredOrientations(
          [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown])
      .whenComplete(() {
    Api.initFirebase();
    runApp(const MyApp());
    // runApp(
    //   DevicePreview(
    //     enabled: !kReleaseMode,
    //     builder: (context) => MyApp(), // Wrap your app
    //   ),
    // );
  });
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
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
          // shadowColor: Colors.blue,
          centerTitle: true,
          elevation: 1,
          iconTheme: IconThemeData(color: Colors.black),
          backgroundColor: Colors.white,
          titleTextStyle: TextStyle(
              color: Colors.black, fontWeight: FontWeight.normal, fontSize: 19),
        ),
      ),
      home: SplashPage(),
      initialRoute: "/",
      routes: {
        "/home": (context) => HomePage(),
        "/splash": (context) => SplashPage(),
        "/login": (context) => LoginPage(),
        "/profile": (context) => ProfilePage(user: Api.me),
        // "/chat": (context) => ChatPage(user: Api.me),
      },
    );
  }
}
