import 'package:flutter/material.dart';

class DateUtil {
  static String getFormatedTime(context, {time}) {
    final date = DateTime.fromMillisecondsSinceEpoch(int.parse(time));

    return TimeOfDay.fromDateTime(date).format(context);
  }
}
