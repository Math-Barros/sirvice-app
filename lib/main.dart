import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:sirvice_app/constants.dart';
import 'package:sirvice_app/models/user.dart';
import 'package:sirvice_app/routes.dart';
import 'package:sirvice_app/screens/splash/splash_screen.dart';
import 'package:sirvice_app/theme.dart';

void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> with WidgetsBindingObserver {
  static late User? currentUser;

  // Set default `_initialized` and `_error` state to false
  bool _initialized = false;
  bool _error = false;

  // Define an async function to initialize FlutterFire
  void initializeFlutterFire() async {
    try {
      // Wait for Firebase to initialize and set `_initialized` state to true
      await Firebase.initializeApp();
      setState(() {
        _initialized = true;
      });
    } catch (e) {
      // Set `_error` state to true if Firebase initialization fails
      setState(() {
        _error = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Show error message if initialization failed
    if (_error) {
      return MaterialApp(
          home: Scaffold(
        body: Container(
          color: Colors.white,
          child: Center(
              child: Column(
            children: [
              Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 25,
              ),
              SizedBox(height: 16),
              Text(
                'Failed to initialise firebase!',
                style: TextStyle(color: Colors.red, fontSize: 25),
              ),
            ],
          )),
        ),
      ));
    }

    // Show a loader until FlutterFire is initialized
    if (!_initialized) {
      return Container(
        color: Colors.white,
        child: Center(
          child: CircularProgressIndicator.adaptive(),
        ),
      );
    }

    return MaterialApp(
      theme: theme(),
      debugShowCheckedModeBanner: false,
      color: kPrimaryColor,
      initialRoute: SplashScreen.routeName,
      routes: routes,
    );
  }

  @override
  void initState() {
    super.initState();
    initializeFlutterFire();
  }
}
