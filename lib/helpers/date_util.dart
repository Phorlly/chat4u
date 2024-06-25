import 'package:flutter/material.dart';

class DateUtil {
  static final now = DateTime.now();
  static DateTime timeFormatted(String time) {
    return DateTime.fromMillisecondsSinceEpoch(int.parse(time));
  }

  static String getFormatedTime(context, {required String time}) {
    final date = timeFormatted(time);

    return TimeOfDay.fromDateTime(date).format(context);
  }

  //for getting formatted time for sent and read
  static String getMessageTime(context, {required String time}) {
    final sent = timeFormatted(time);
    final formattedTime = TimeOfDay.fromDateTime(sent).format(context);

    if (now.day == sent.day &&
        now.month == sent.month &&
        now.year == sent.year) {
      return formattedTime;
    }

    return now.year == sent.year
        ? "$formattedTime - ${sent.day} ${getMonth(sent)}"
        : "$formattedTime - ${sent.day} ${getMonth(sent)} ${sent.year}";
  }

  static String getLastMessageTime(context,
      {required String time, bool showYear = false}) {
    final sent = timeFormatted(time);

    if (now.day == sent.day &&
        now.month == sent.month &&
        now.year == sent.year) {
      return TimeOfDay.fromDateTime(sent).format(context);
    }

    return showYear
        ? "${sent.day} ${getMonth(sent)} ${sent.year}"
        : "${sent.day} ${getMonth(sent)}";
  }

  static String getLastActive(context, {required String lastActive}) {
    final int item = int.tryParse(lastActive) ?? -1;

    if (item == -1) return "Last seen not available";

    var time = DateTime.fromMillisecondsSinceEpoch(item);

    var formatedTime = TimeOfDay.fromDateTime(time).format(context);
    if (time.day == now.day &&
        time.month == now.month &&
        time.year == now.year) {
      return "Last seen at $formatedTime";
    }

    if ((now.difference(time).inHours / 24).round() == 1) {
      return "Last seen yesterday at $formatedTime";
    }

    var month = getMonth(time);
    return "Last seen on ${time.day} $month on $formatedTime";
  }

  static String getMonth(DateTime date) {
    switch (date.month) {
      case 1:
        return "Jan";
      case 2:
        return "Feb";
      case 3:
        return "Mar";
      case 4:
        return "Apr";
      case 5:
        return "May";
      case 6:
        return "Jun";
      case 7:
        return "Jul";
      case 8:
        return "Aug";
      case 9:
        return "Sep";
      case 10:
        return "Oct";
      case 11:
        return "Nov";
      case 12:
        return "Dec";
    }

    return "N/A";
  }
}
