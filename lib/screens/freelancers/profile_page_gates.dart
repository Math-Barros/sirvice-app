import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sirvice_app/models/Freelancer.dart';
import 'package:sirvice_app/screens/freelancers/components/appbar_widget.dart';
import 'package:sirvice_app/screens/freelancers/components/button_widget.dart';
import 'package:sirvice_app/screens/freelancers/components/profile_widget.dart';
import 'package:sirvice_app/screens/freelancers/components/user_preferences.dart';

class ProfilePageGates extends StatefulWidget {
  static String routeName = "/gates";

  @override
  _ProfilePageGatesState createState() => _ProfilePageGatesState();
}

class _ProfilePageGatesState extends State<ProfilePageGates> {
  @override
  Widget build(BuildContext context) {
    final user = UserPreferences.gates;

    return Scaffold(
      appBar: buildAppBar(context),
      body: ListView(
        physics: BouncingScrollPhysics(),
        children: [
          ProfileWidget(
            imagePath: user.imagePath,
            onClicked: () async {},
          ),
          const SizedBox(height: 24),
          buildName(user),
          const SizedBox(height: 24),
          Center(child: buildUpgradeButton()),
          const SizedBox(height: 24),
          NumbersWidget(),
          const SizedBox(height: 48),
          buildAbout(user),
        ],
      ),
    );
  }

  Widget buildName(Freelancer freelancer) => Column(
        children: [
          Text(
            freelancer.name,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),
          const SizedBox(height: 4),
          Text(
            freelancer.email,
            style: TextStyle(color: Colors.grey),
          )
        ],
      );

  Widget buildUpgradeButton() => ButtonWidget(
        text: 'Projetos realizados',
        onClicked: () {},
      );

  Widget buildAbout(Freelancer freelancer) => Container(
        padding: EdgeInsets.symmetric(horizontal: 48),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Sobre',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              freelancer.about,
              style: TextStyle(fontSize: 16, height: 1.4),
            ),
          ],
        ),
      );
}

class NumbersWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          buildButton(context, '4.1', 'Ranking'),
          buildDivider(),
          buildButton(context, '335', 'Seguindo'),
          buildDivider(),
          buildButton(context, '520', 'Seguidores'),
        ],
      );
  Widget buildDivider() => Container(
        height: 24,
        child: VerticalDivider(),
      );

  Widget buildButton(BuildContext context, String value, String text) =>
      MaterialButton(
        padding: EdgeInsets.symmetric(vertical: 4),
        onPressed: () {},
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text(
              value,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
            ),
            SizedBox(height: 2),
            Text(
              text,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      );
}
