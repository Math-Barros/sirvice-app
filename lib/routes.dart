import 'package:flutter/widgets.dart';
import 'package:sirvice_app/screens/cart/cart_screen.dart';
import 'package:sirvice_app/screens/details/details_screen.dart';
import 'package:sirvice_app/screens/freelancers/profile_page_bezzos.dart';
import 'package:sirvice_app/screens/freelancers/profile_page_gates.dart';
import 'package:sirvice_app/screens/freelancers/profile_page_musk.dart';
import 'package:sirvice_app/screens/freelancers/profile_page_zuck.dart';
import 'package:sirvice_app/screens/home/home_screen.dart';
import 'package:sirvice_app/screens/login_success/login_success_screen.dart';
import 'package:sirvice_app/screens/profile/profile_screen.dart';
import 'package:sirvice_app/screens/registration_sucess/registration_success_screen.dart';
import 'package:sirvice_app/screens/sign_in/sign_in_screen.dart';
import 'package:sirvice_app/screens/splash/splash_screen.dart';

import 'screens/sign_up/sign_up_screen.dart';

// We use name route
// All our routes will be available here
final Map<String, WidgetBuilder> routes = {
  SplashScreen.routeName: (context) => SplashScreen(),
  SignInScreen.routeName: (context) => SignInScreen(),
  LoginSuccessScreen.routeName: (context) => LoginSuccessScreen(),
  RegistrationSuccessScreen.routeName: (context) => RegistrationSuccessScreen(),
  SignUpScreen.routeName: (context) => SignUpScreen(),
  HomeScreen.routeName: (context) => HomeScreen(),
  ProfilePageGates.routeName: (context) => ProfilePageGates(),
  ProfilePageMusk.routeName: (context) => ProfilePageMusk(),
  ProfilePageBezzos.routeName: (context) => ProfilePageBezzos(),
  ProfilePageZuck.routeName: (context) => ProfilePageZuck(),
  DetailsScreen.routeName: (context) => DetailsScreen(),
  CartScreen.routeName: (context) => CartScreen(),
  ProfileScreen.routeName: (context) => ProfileScreen()
};
