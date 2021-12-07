import 'package:flutter/material.dart';

import 'widgets/authentication_form.dart';

class AuthenticationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final height = mediaQuery.size.height;
    return Scaffold(
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Stack(
          children: [
            Container(
              height: height,
              // hack to make gesture detector work
              color: Colors.transparent,
              alignment: Alignment.center,
              padding: const EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                child: AuthenticationForm(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
