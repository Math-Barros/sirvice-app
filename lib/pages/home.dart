// ignore_for_file: deprecated_member_use

import 'package:app_frontend/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:app_frontend/components/home/categoryCarousel.dart';
import 'package:app_frontend/components/header.dart';
import 'package:app_frontend/components/home/gridItemList.dart';
import 'package:app_frontend/components/home/snapEffectCarousel.dart';
import 'package:app_frontend/components/sidebar.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _scaffoldKey =
        new GlobalKey<ScaffoldState>();
    bool showCartIcon = true;
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    return WillPopScope(
      onWillPop: () async {
        return (await showDialog(
                context: context,
                builder: (context) => AlertDialog(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24.0)),
                      title: Text('você tem certeza?'),
                      content: Text('Você quer sair do app?'),
                      actions: <Widget>[
                        FlatButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: Text('No',
                              style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black)),
                        ),
                        FlatButton(
                          onPressed: () => Navigator.of(context).pop(true),
                          child: Text('Yes',
                              style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red)),
                        )
                      ],
                    ))) ??
            false;
      },
      child: Scaffold(
          key: _scaffoldKey,
          appBar: header('Sirvice', _scaffoldKey, showCartIcon, context),
          drawer: sidebar(context),
          body: Container(
            color: Colors.white,
            child: CustomScrollView(
              slivers: <Widget>[
                SliverList(
                  delegate: SliverChildListDelegate([
                    Container(height: 80.0, child: CategoryCarousal()),
                    Padding(
                      padding: EdgeInsets.fromLTRB(0.0, 40.0, 0.0, 20.0),
                      child: Center(
                        child: Text(
                          'Novos serviços',
                          style: TextStyle(
                              fontSize: 30.0,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2,
                              fontFamily: 'NovaSquare'),
                        ),
                      ),
                    ),
                    Container(height: 420.0, child: SnapEffectCarousel()),
                    Padding(
                      padding: EdgeInsets.only(top: 30.0, bottom: 15.0),
                      child: Center(
                        child: Text(
                          'Destaques',
                          style: TextStyle(
                              fontSize: 30.0,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2,
                              fontFamily: 'NovaSquare'),
                        ),
                      ),
                    ),
                  ]),
                ),
                GridItemList(),
              ],
            ),
          )),
    );
  }
}
