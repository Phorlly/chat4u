import 'package:flutter/material.dart';

class LinkPage {
  static link(context, {required Widget widget}) {
    return Navigator.push(context, MaterialPageRoute(builder: (_) => widget));
  }

  static linkReplace(context, {required Widget widget}) {
    return Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (_) => widget));
  }

  static linkName(context, {required String route}) {
    return Navigator.pushNamed(context, route);
  }

  static linkReplaceName(context, {required String route}) {
    return Navigator.pushReplacementNamed(context, route);
  }

  static linkBack(context) {
    return Navigator.pop(context);
  }
}
