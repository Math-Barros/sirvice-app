import 'package:flutter/material.dart';
import 'package:sirvice_app/screens/sign_in/sign_in_screen.dart';

import '../constants.dart';
import '../size_config.dart';

class NoAccountTextRegister extends StatelessWidget {
  const NoAccountTextRegister({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Já Possui uma conta? Efetue o ",
          style: TextStyle(fontSize: getProportionateScreenWidth(16)),
        ),
        GestureDetector(
          onTap: () => Navigator.pop(context, SignInScreen.routeName),
          child: Text(
            "Login",
            style: TextStyle(
                fontSize: getProportionateScreenWidth(16),
                color: kPrimaryColor),
          ),
        ),
      ],
    );
  }
}
