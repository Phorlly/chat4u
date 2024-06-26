import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat4u/main.dart';
import 'package:flutter/material.dart';

class Input extends StatelessWidget {
  final String? initVal, hint;
  final String label;
  final TextEditingController? name;
  final IconData? icon;
  final void Function(String?)? saved;
  final String? Function(String?)? checked, changed;

  const Input(
      {super.key,
      this.initVal,
      this.hint,
      required this.label,
      this.name,
      this.icon,
      this.saved,
      this.checked,
      this.changed});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      child: TextFormField(
        controller: name,
        onSaved: saved,
        validator: checked,
        maxLines: null,
        onChanged: changed,
        initialValue: initVal,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.blue),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
          hintText: hint,
          label: Text(label,
              style: TextStyle(color: Colors.blueAccent, fontSize: 16)),
        ),
      ),
    );
  }
}

class ImageURL extends StatelessWidget {
  final String image;
  final double? wh, size;
  final IconData? icon;
  final double hb;

  const ImageURL(
      {super.key,
      required this.image,
      required this.hb,
      this.wh,
      this.icon = Icons.person,
      this.size = 50});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(hb),
      child: CachedNetworkImage(
        width: wh,
        height: wh,
        fit: BoxFit.fill,
        imageUrl: image,
        placeholder: (context, url) => Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircularProgressIndicator(
            strokeWidth: 2,
          ),
        ),
        errorWidget: (context, url, error) => CircleAvatar(
          child: Icon(
            icon,
            size: size,
          ),
        ),
      ),
    );
  }
}

class ImageFile extends StatelessWidget {
  final String image;
  final double hb, wh;

  const ImageFile(
      {super.key, required this.image, required this.hb, required this.wh});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(mq.height * hb),
      child: Image.file(
        File(image),
        width: mq.height * wh,
        height: mq.height * wh,
        fit: BoxFit.cover,
      ),
    );
  }
}

class Button extends StatelessWidget {
  final String label;
  final IconData? icon;
  final void Function() click;
  final Color? color;
  final double? width;

  const Button(
      {super.key,
      required this.label,
      this.icon,
      required this.click,
      this.color,
      this.width});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 25),
      child: FloatingActionButton.extended(
        backgroundColor: color,
        foregroundColor: Colors.white,
        onPressed: click,
        icon: Icon(icon),
        label: Text(label),
      ),
    );
  }
}

class ImageButton extends StatelessWidget {
  final String imagePath;
  final void Function() click;
  final double width, height;

  const ImageButton(
      {super.key,
      required this.imagePath,
      required this.click,
      required this.width,
      required this.height});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white60,
        shape: CircleBorder(),
        fixedSize: Size(mq.width * width, mq.height * height),
      ),
      onPressed: click,
      child: Image.asset(imagePath),
    );
  }
}
