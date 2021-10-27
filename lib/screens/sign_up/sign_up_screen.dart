import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sirvice_app/components/custom_surfix_icon.dart';
import 'package:sirvice_app/components/default_button.dart';
import 'package:sirvice_app/components/no_account_text_register.dart';
import 'package:sirvice_app/constants.dart';
import 'package:sirvice_app/helper/authenticate.dart';
import 'package:sirvice_app/main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sirvice_app/models/user.dart';
import 'package:sirvice_app/screens/complete_profile/complete_profile_screen.dart';

File? _image;

class SignUpScreen extends StatefulWidget {
  static String routeName = "/sign_up";

  @override
  State createState() => _SignUpState();
}

class _SignUpState extends State<SignUpScreen> {
  final ImagePicker _imagePicker = ImagePicker();
  TextEditingController _passwordController = new TextEditingController();
  GlobalKey<FormState> _key = new GlobalKey();
  AutovalidateMode _validate = AutovalidateMode.disabled;
  String? name, email, password, confirmPassword;

  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid) {
      retrieveLostData();
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        child: new Container(
          margin: new EdgeInsets.only(left: 16.0, right: 16, bottom: 16),
          child: new Form(
            key: _key,
            autovalidateMode: _validate,
            child: formUI(),
          ),
        ),
      ),
    );
  }

  Future<void> retrieveLostData() async {
    // ignore: deprecated_member_use
    final LostData? response = await _imagePicker.getLostData();
    if (response == null) {
      return;
    }
    if (response.file != null) {
      setState(() {
        _image = File(response.file!.path);
      });
    }
  }

  _onCameraClick() {
    final action = CupertinoActionSheet(
      message: Text(
        "Add profile picture",
        style: TextStyle(fontSize: 15.0),
      ),
      actions: <Widget>[
        CupertinoActionSheetAction(
          child: Text("Choose from gallery"),
          isDefaultAction: false,
          onPressed: () async {
            Navigator.pop(context);
            PickedFile? image =
                // ignore: deprecated_member_use
                await _imagePicker.getImage(source: ImageSource.gallery);
            if (image != null)
              setState(() {
                _image = File(image.path);
              });
          },
        ),
        CupertinoActionSheetAction(
          child: Text("Take a picture"),
          isDestructiveAction: false,
          onPressed: () async {
            Navigator.pop(context);
            PickedFile? image =
                // ignore: deprecated_member_use
                await _imagePicker.getImage(source: ImageSource.camera);
            if (image != null)
              setState(() {
                _image = File(image.path);
              });
          },
        )
      ],
      cancelButton: CupertinoActionSheetAction(
        child: Text("Cancel"),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
    showCupertinoModalPopup(context: context, builder: (context) => action);
  }

  Widget formUI() {
    return new Column(
      children: <Widget>[
        new Align(
          alignment: Alignment.center,
          child: Text(
            'Realize seu Cadastro!',
            style: headingStyle,
          ),
        ),
        Padding(
          padding:
              const EdgeInsets.only(left: 8.0, top: 32, right: 8, bottom: 8),
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: <Widget>[
              CircleAvatar(
                radius: 65,
                backgroundColor: Colors.grey.shade400,
                child: ClipOval(
                  child: SizedBox(
                    width: 170,
                    height: 170,
                    child: _image == null
                        ? Image.asset(
                            'assets/images/photo.png',
                            fit: BoxFit.cover,
                          )
                        : Image.file(
                            _image!,
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
              ),
              Positioned(
                left: 80,
                right: 0,
                child: FloatingActionButton(
                    backgroundColor: kPrimaryColor,
                    child: Icon(Icons.camera_alt),
                    mini: true,
                    onPressed: _onCameraClick),
              )
            ],
          ),
        ),
        Text(
          "Insira seus dados para se registrar.",
          textAlign: TextAlign.center,
        ),
        ConstrainedBox(
            constraints: BoxConstraints(minWidth: double.infinity),
            child: Padding(
                padding:
                    const EdgeInsets.only(top: 16.0, right: 8.0, left: 8.0),
                child: TextFormField(
                  validator: validateName,
                  onSaved: (val) => name = val,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    labelText: "Nome de Usuário",
                    hintText: "Insira seu nome de Usuário",
                    // If  you are using latest version of flutter then lable text and hint text shown like this
                    // if you r using flutter less then 1.20.* then maybe this is not working properly
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    suffixIcon:
                        CustomSurffixIcon(svgIcon: "assets/icons/User.svg"),
                  ),
                ))),
        ConstrainedBox(
            constraints: BoxConstraints(minWidth: double.infinity),
            child: Padding(
                padding:
                    const EdgeInsets.only(top: 16.0, right: 8.0, left: 8.0),
                child: TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  validator: validateEmail,
                  onSaved: (val) => email = val,
                  decoration: InputDecoration(
                    labelText: "Email",
                    hintText: "Insira seu Email",
                    // If  you are using latest version of flutter then lable text and hint text shown like this
                    // if you r using flutter less then 1.20.* then maybe this is not working properly
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    suffixIcon:
                        CustomSurffixIcon(svgIcon: "assets/icons/Mail.svg"),
                  ),
                ))),
        ConstrainedBox(
            constraints: BoxConstraints(minWidth: double.infinity),
            child: Padding(
              padding: const EdgeInsets.only(top: 16.0, right: 8.0, left: 8.0),
              child: TextFormField(
                obscureText: true,
                textInputAction: TextInputAction.next,
                controller: _passwordController,
                validator: validatePassword,
                onSaved: (val) => password = val,
                style: TextStyle(height: 0.8, fontSize: 18.0),
                cursorColor: kPrimaryColor,
                decoration: InputDecoration(
                  labelText: "Senha",
                  hintText: "Informe sua Senha",
                  // If  you are using latest version of flutter then lable text and hint text shown like this
                  // if you r using flutter less then 1.20.* then maybe this is not working properly
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  suffixIcon:
                      CustomSurffixIcon(svgIcon: "assets/icons/Lock.svg"),
                ),
              ),
            )),
        ConstrainedBox(
          constraints: BoxConstraints(minWidth: double.infinity),
          child: Padding(
            padding: const EdgeInsets.only(top: 16.0, right: 8.0, left: 8.0),
            child: TextFormField(
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (_) => _signUp(),
              obscureText: true,
              validator: (val) =>
                  validateConfirmPassword(_passwordController.text, val),
              onSaved: (val) => confirmPassword = val,
              style: TextStyle(height: 0.8, fontSize: 18.0),
              cursorColor: kPrimaryColor,
              decoration: InputDecoration(
                labelText: "Confirmar Senha",
                hintText: "Informe sua Senha",
                // If  you are using latest version of flutter then lable text and hint text shown like this
                // if you r using flutter less then 1.20.* then maybe this is not working properly
                floatingLabelBehavior: FloatingLabelBehavior.always,
                suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Lock.svg"),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 40.0, left: 40.0, top: 20.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(minWidth: double.infinity),
            child: DefaultButton(
                text: 'Sign Up',
                press: () {
                  _signUp();
                }),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: NoAccountTextRegister(),
        ),
      ],
    );
  }

  _signUp() async {
    if (_key.currentState?.validate() ?? false) {
      _key.currentState!.save();
      await _signUpWithEmailAndPassword();
    } else {
      setState(() {
        _validate = AutovalidateMode.onUserInteraction;
      });
    }
  }

  _signUpWithEmailAndPassword() async {
    await showProgress(context, 'Creating new account, Please wait...', false);
    dynamic result = await FireStoreUtils.firebaseSignUpWithEmailAndPassword(
      email!.trim(),
      password!.trim(),
      _image,
      name!.trim(),
    );
    await hideProgress();
    if (result != null && result is User) {
      MyAppState.currentUser = result;
      pushAndRemoveUntil(context, CompleteProfileScreen(), false);
    } else if (result != null && result is String) {
      showAlertDialog(context, 'Failed', result);
    } else {
      showAlertDialog(context, 'Failed', 'Couldn\'t sign up');
    }
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _image = null;
    super.dispose();
  }
}
