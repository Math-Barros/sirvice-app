import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:sirvice_app/components/custom_surfix_icon.dart';
import 'package:sirvice_app/components/default_button.dart';
import 'package:sirvice_app/components/no_account_text_login.dart';
import 'package:sirvice_app/constants.dart';
import 'package:sirvice_app/helper/authenticate.dart';
import 'package:sirvice_app/main.dart';
import 'package:sirvice_app/models/user.dart';
import 'package:sirvice_app/screens/profile/profile_screen.dart';
import 'package:sirvice_app/size_config.dart';

class SignInScreen extends StatefulWidget {
  static String routeName = "/sign_in";

  @override
  State createState() {
    return _SignInScreen();
  }
}

class _SignInScreen extends State<SignInScreen> {
  GlobalKey<FormState> _key = new GlobalKey();
  AutovalidateMode _validate = AutovalidateMode.disabled;
  String? email, password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0.0,
      ),
      body: Form(
        key: _key,
        autovalidateMode: _validate,
        child: ListView(
          children: <Widget>[
            Padding(
              padding:
                  const EdgeInsets.only(top: 32.0, right: 16.0, left: 16.0),
              child: Text(
                'Bem vindo de volta!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: getProportionateScreenWidth(28),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: SizeConfig.screenHeight * 0.03),
            Text(
              "Sign in with your email and password  \nor continue with social media",
              textAlign: TextAlign.center,
            ),
            ConstrainedBox(
              constraints: BoxConstraints(minWidth: double.infinity),
              child: Padding(
                padding:
                    const EdgeInsets.only(top: 32.0, right: 24.0, left: 24.0),
                child: TextFormField(
                  textAlignVertical: TextAlignVertical.center,
                  textInputAction: TextInputAction.next,
                  validator: validateEmail,
                  onSaved: (val) => email = val,
                  onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
                  style: TextStyle(fontSize: 18.0),
                  keyboardType: TextInputType.emailAddress,
                  cursorColor: kPrimaryColor,
                  decoration: InputDecoration(
                    labelText: "Email",
                    hintText: "Enter your email",
                    // If  you are using latest version of flutter then lable text and hint text shown like this
                    // if you r using flutter less then 1.20.* then maybe this is not working properly
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    suffixIcon:
                        CustomSurffixIcon(svgIcon: "assets/icons/Mail.svg"),
                  ),
                ),
              ),
            ),
            ConstrainedBox(
              constraints: BoxConstraints(minWidth: double.infinity),
              child: Padding(
                padding:
                    const EdgeInsets.only(top: 32.0, right: 24.0, left: 24.0),
                child: TextFormField(
                  textAlignVertical: TextAlignVertical.center,
                  validator: validatePassword,
                  onSaved: (val) => password = val,
                  onFieldSubmitted: (password) async {
                    await login();
                  },
                  obscureText: true,
                  textInputAction: TextInputAction.done,
                  style: TextStyle(fontSize: 18.0),
                  cursorColor: kPrimaryColor,
                  decoration: InputDecoration(
                    labelText: "Senha",
                    hintText: "Insira sua Senha",
                    // If  you are using latest version of flutter then lable text and hint text shown like this
                    // if you r using flutter less then 1.20.* then maybe this is not working properly
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    suffixIcon:
                        CustomSurffixIcon(svgIcon: "assets/icons/Lock.svg"),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 40.0, left: 40.0, top: 40),
              child: ConstrainedBox(
                constraints: const BoxConstraints(minWidth: double.infinity),
                child: DefaultButton(
                    text: 'Log In',
                    press: () {
                      login();
                    }),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(32.0),
              child: Center(
                child: Text(
                  'OU',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(right: 40.0, left: 40.0, bottom: 20),
              child: ConstrainedBox(
                constraints: const BoxConstraints(minWidth: double.infinity),
                child: ElevatedButton.icon(
                  label: Text(
                    'Facebook Login',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  icon: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Image.asset(
                      'assets/images/facebook_logo.png',
                      color: Colors.white,
                      height: 30,
                      width: 30,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: Color(FACEBOOK_BUTTON_COLOR),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      side: BorderSide(
                        color: Color(FACEBOOK_BUTTON_COLOR),
                      ),
                    ),
                  ),
                  onPressed: () async => loginWithFacebook(),
                ),
              ),
            ),
            NoAccountTextLogin(),
          ],
        ),
      ),
    );
  }

  login() async {
    if (_key.currentState?.validate() ?? false) {
      _key.currentState!.save();
      await _loginWithEmailAndPassword();
    } else {
      setState(() {
        _validate = AutovalidateMode.onUserInteraction;
      });
    }
  }

  _loginWithEmailAndPassword() async {
    await showProgress(context, 'Logging in, please wait...', false);
    dynamic result = await FireStoreUtils.loginWithEmailAndPassword(
        email!.trim(), password!.trim());
    await hideProgress();
    if (result != null && result is User) {
      MyAppState.currentUser = result;
      pushAndRemoveUntil(context, ProfileScreen(user: result), false);
    } else if (result != null && result is String) {
      showAlertDialog(context, 'Falha na Autenticação', result);
    } else {
      showAlertDialog(context, 'Falha na Autenticação',
          'Falha no Login, Por Favor tente novamente.');
    }
  }

  loginWithFacebook() async {
    try {
      await showProgress(context, 'Logging in, Please wait...', false);
      dynamic result = await FireStoreUtils.loginWithFacebook();
      await hideProgress();
      if (result != null && result is User) {
        MyAppState.currentUser = result;
        pushAndRemoveUntil(context, ProfileScreen(user: result), false);
      } else if (result != null && result is String) {
        showAlertDialog(context, 'Error', result);
      } else {
        showAlertDialog(context, 'Error', 'Couldn\'t login with facebook.');
      }
    } catch (e, s) {
      await hideProgress();
      print('_LoginScreen.loginWithFacebook $e $s');
      showAlertDialog(context, 'Error', 'Couldn\'t login with facebook.');
    }
  }
}
