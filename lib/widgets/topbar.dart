import 'package:chat4u/widgets/ui_design.dart';
import 'package:flutter/material.dart';

class Topbar extends StatefulWidget {
  final String photo, title, subtitle;
  final void Function()? click;

  const Topbar(
      {super.key,
      required this.photo,
      this.click,
      required this.title,
      required this.subtitle});

  @override
  State<Topbar> createState() => _TopbarState();
}

class _TopbarState extends State<Topbar> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Row(
        children: [
          IconButton(
            onPressed: widget.click,
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.black54,
            ),
          ),
          ImageURL(image: widget.photo, wh: .05, hb: .03),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.title,
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.w500),
                ),
                Text(
                  widget.subtitle,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
