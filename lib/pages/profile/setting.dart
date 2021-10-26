import 'package:app_frontend/components/modals/internetConnection.dart';
import 'package:flutter/material.dart';

import 'package:app_frontend/components/profileAppBar.dart';
import 'package:app_frontend/services/profileService.dart';
import 'package:app_frontend/services/userService.dart';


class ProfileSetting extends StatefulWidget {
  @override
  _ProfileSettingState createState() => _ProfileSettingState();
}

class _ProfileSettingState extends State<ProfileSetting> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  ProfileService _profileService = new ProfileService();
  UserService _userService = new UserService();
  Map<String,bool> settings = new Map();

  saveUserSettings(String key, bool value) async{
    bool connectionStatus = await _userService.checkInternetConnectivity();

    if(connectionStatus){
      settings[key] = value;
      await _profileService.updateUserSettings(settings);
    }
    else{
      internetConnectionDialog(context);
    }
  }

  userSetting(){
    Map args = ModalRoute.of(context).settings.arguments;
    List<String> keys = args.keys.toList();
    for(String key in keys){
      if(key != 'userId') {
        setState(() {
          settings[key] = args[key];
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    userSetting();
    return Scaffold(
      key: _scaffoldKey,
      appBar: ProfileAppBar('Settings',context),
      body: Container(
        padding: EdgeInsets.only(top: 40.0,left: 10.0, right: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Segurança',
              style: TextStyle(
                fontSize: 18.0,
                letterSpacing: 1.0
              ),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Text(
                'Habilitar toque para logar',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold
                ),
              ),
              trailing: Switch(
                value: settings['touchId'],
                onChanged: (value) => saveUserSettings('touchId',value),
                activeColor: Colors.green,
              ),
            ),
            SizedBox(height: 20.0),
            Text(
              'Notificações',
              style: TextStyle(
                  fontSize: 18.0,
                  letterSpacing: 1.0
              ),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Text(
                'Atualizações de pedido',
                style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold
                ),
              ),
              trailing: Switch(
                value: settings['orderUpdates'],
                onChanged: (value) => saveUserSettings('orderUpdates',value),
                activeColor: Colors.green,
              ),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Text(
                'Novos pedidos',
                style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold
                ),
              ),
              trailing: Switch(
                value: settings['newArrivals'],
                onChanged: (value) => saveUserSettings('newArrivals', value),
                activeColor: Colors.green,
              ),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Text(
                'Promoções',
                style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold
                ),
              ),
              trailing: Switch(
                value: settings['promotions'],
                onChanged: (value) => saveUserSettings('promotions', value),
                activeColor: Colors.green,
              ),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Text(
                'Alertas de ofertas',
                style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold
                ),
              ),
              trailing: Switch(
                value: settings['saleAlerts'],
                onChanged: (value) => saveUserSettings('saleAlerts', value),
                activeColor: Colors.green,
              ),
            ),
            SizedBox(height: 20.0),
            Text(
              'Conta',
              style: TextStyle(
                  fontSize: 18.0,
                  letterSpacing: 1.0
              ),
            ),
            SizedBox(height: 10.0),
            Material(
              color: Colors.white,
              child: ListTile(
                title: Center(
                  child: Text(
                    'Suporte',
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.blue,
                    ),
                  ),
                ),
              ),
            ),
            Material(
              color: Colors.white,
              child: ListTile(
                onTap: (){
                  _userService.logOut(context);
                },
                title: Center(
                  child: Text(
                    'Log out',
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.blue,
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
