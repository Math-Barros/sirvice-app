import 'package:flutter/material.dart';
import 'package:sirvice_app/constants.dart';
import 'package:sirvice_app/main.dart';
import 'package:sirvice_app/screens/sign_in/sign_in_screen.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

import 'profile_menu.dart';
import 'profile_pic.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          ProfilePic(),
          SizedBox(height: 20),
          ProfileMenu(
            text: "My Account",
            icon: "assets/icons/User Icon.svg",
            press: () => {},
          ),
          ProfileMenu(
            text: "Notifications",
            icon: "assets/icons/Bell.svg",
            press: () {},
          ),
          ProfileMenu(
            text: "Settings",
            icon: "assets/icons/Settings.svg",
            press: () {},
          ),
          ProfileMenu(
            text: "Help Center",
            icon: "assets/icons/Question mark.svg",
            press: () {},
          ),
          ProfileMenu(
            text: "Log Out",
            icon: "assets/icons/Log out.svg",
            press: () async {
              await auth.FirebaseAuth.instance.signOut();
              MyAppState.currentUser = null;
              pushAndRemoveUntil(context, SignInScreen(), false);
            },
          ),
        ],
      ),
    );
  }
}
