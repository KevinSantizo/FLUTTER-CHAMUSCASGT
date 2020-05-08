import 'package:flutter/material.dart';
import 'package:newsport/src/authenticate/sign_in.dart';
import 'package:newsport/src/authenticate/sign_up.dart';

class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {

  bool showSignIn = true;
  void toogleViews(){
    setState(() {
      showSignIn = !showSignIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showSignIn) {
      return SignIn(toogleViews: toogleViews);
    } else {
      return SignUpPage(toogleViews: toogleViews);
    }
  }
}