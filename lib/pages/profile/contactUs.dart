import 'package:flutter/material.dart';

import 'package:app_frontend/components/profileAppBar.dart';

class ContactUs extends StatefulWidget {
  @override
  _ContactUsState createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool showCartIcon = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      key: _scaffoldKey,
      appBar: ProfileAppBar('Contato', context),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 40.0),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              child: Text(
                'Contato',
                style: TextStyle(
                    fontSize: 15.0,
                    letterSpacing: 1.0
                ),
              ),
            ),
            SizedBox(height: 10.0),
            Material(
              color: Colors.white,
              child: ListTile(
                title: Text(
                  'Nosso email',
                  style: TextStyle(
                    fontSize:20.0,
                    letterSpacing: 1.0,
                    fontWeight: FontWeight.bold
                  ),
                ),
                subtitle: Text(
                  'Support@sirvice.com',
                  style: TextStyle(
                    fontSize:16.0,
                    fontWeight: FontWeight.bold
                  ),
                ),
              ),
            ),
            Material(
              color: Colors.white,
              child: ListTile(
                leading: Text(
                  'Nosso telefone',
                  style: TextStyle(
                    fontSize:20.0,
                    letterSpacing: 1.0,
                    fontWeight: FontWeight.bold
                  ),
                ),
                trailing: Text(
                  '(11)6969-6969',
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.grey
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 20.0, left: 10.0),
              child: Text(
                'Nosso horário de funcionamento, Segunda à Sexta, 10h - 17h'
              ),
            ),
            SizedBox(height: 20.0),
            Material(
              color: Colors.white,
              child: ListTile(
                title: Center(
                  child: Text(
                    '',
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.blue
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
