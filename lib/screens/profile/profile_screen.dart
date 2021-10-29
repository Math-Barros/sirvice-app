import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:sirvice_app/components/coustom_bottom_nav_bar.dart';
import 'package:sirvice_app/constants.dart';
import 'package:sirvice_app/enums.dart';
import 'package:sirvice_app/main.dart';
import 'package:sirvice_app/models/user.dart';
import 'package:sirvice_app/screens/profile/components/profile_menu.dart';
import 'package:sirvice_app/screens/sign_in/sign_in_screen.dart';

class ProfileScreen extends StatefulWidget {
  static String routeName = "/profile";
  final User user;

  ProfileScreen({Key? key, required this.user}) : super(key: key);

  @override
  State createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late User user;

  late final _ratingController;
  late double _rating;

  double _userRating = 3.0;
  int _ratingBarMode = 1;
  double _initialRating = 2.0;
  bool _isRTLMode = false;
  bool _isVertical = false;

  IconData? _selectedIcon;

  @override
  void initState() {
    super.initState();
    _ratingController = TextEditingController(text: '3.0');
    _rating = _initialRating;
    user = widget.user;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            displayCircleImage(user.profilePictureURL, 80, false),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(user.name),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(user.email),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: const <Widget>[
                Chip(
                  padding: EdgeInsets.all(0),
                  backgroundColor: Colors.blue,
                  label: Text('Flutter Master',
                      style: TextStyle(color: Colors.white)),
                ),
                SizedBox(width: 10.0),
                Chip(
                  padding: EdgeInsets.all(0),
                  backgroundColor: Colors.orange,
                  label: Text('Java Tester',
                      style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
            RatingBarIndicator(
              rating: _userRating,
              itemBuilder: (context, index) => Icon(
                _selectedIcon ?? Icons.star,
                color: Colors.amber,
              ),
              itemCount: 5,
              itemSize: 30.0,
              unratedColor: Colors.amber.withAlpha(50),
              direction: _isVertical ? Axis.vertical : Axis.horizontal,
            ),
            ProfileMenu(
              text: "Minha Conta",
              icon: "assets/icons/User Icon.svg",
              press: () => {},
            ),
            ProfileMenu(
              text: "Meus Projetos",
              icon: "assets/icons/java.svg",
              press: () {},
            ),
            ProfileMenu(
              text: "Meus Pedidos",
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
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("User ID: " + user.userID),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(selectedMenu: MenuState.profile),
    );
  }
}
