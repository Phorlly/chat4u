import 'package:flutter/material.dart';

class LinkPage {
  static link(context, {widget}) {
    return Navigator.push(context, MaterialPageRoute(builder: (_) => widget));
  }

  static linkReplace(context, {widget}) {
    return Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (_) => widget));
  }

  static linkName(context, {route = ""}) {
    return Navigator.pushNamed(context, route);
  }

  static linkReplaceName(context, {route = ""}) {
    return Navigator.pushReplacementNamed(context, route);
  }

  static linkBack(context) {
    return Navigator.pop(context);
  }
}
