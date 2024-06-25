import 'dart:developer';
import 'dart:io';

import 'package:chat4u/helpers/api.dart';
import 'package:chat4u/helpers/link.dart';
import 'package:chat4u/helpers/show_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Auth {
  static var context;

  //logout function
  static Future<void> logout(context, {required String routName}) async {
    try {
      ShowDialog.pogressbar(context);

      await Api.updateActiveStatus(false);
      await Api.auth.signOut().then((_) async {
        LinkPage.linkBack(context);
        Api.auth = FirebaseAuth.instance;

        await GoogleSignIn().signOut().whenComplete(() {
          LinkPage.linkReplaceName(context, route: routName);
        });
      });
    } catch (err) {
      ShowDialog.snakbar(context, message: 'Has a problem is: $err');
    }
  }

//sign in function
  static Future<UserCredential?> signInWithGoogle(context) async {
    try {
      await InternetAddress.lookup('google.com');

      // Trigger the authentication flow
      final googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final googleAuth = await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Once signed in, return the UserCredential
      return await Api.auth.signInWithCredential(credential);
    } catch (err) {
      log('\n signInWithGoogle: $err');
      ShowDialog.snakbar(context,
          message: 'Something when wrong (Check Internet!): $err');
      return null;
    }
  }

  static Future<void> login(context, {required String routeName}) async {
    try {
      ShowDialog.pogressbar(context);
      await signInWithGoogle(context).then((value) async {
        Navigator.pop(context);

        if (value != null) {
          if (await Api.isExist()) {
            Center(child: CircularProgressIndicator());
            LinkPage.linkReplaceName(context, route: routeName);
          } else {
            await Api.createNew().whenComplete(() {
              Center(child: CircularProgressIndicator());
              LinkPage.linkReplaceName(context, route: routeName);
            });
          }
        }
      });
    } catch (err) {
      ShowDialog.snakbar(context, message: 'Has a problem is: $err');
    }
  }
}
