import 'package:flutter/material.dart';
import 'package:newsport/src/authenticate/authenticate.dart';
import 'package:newsport/src/components/bottom_navigation_bar.dart';
import 'package:newsport/src/models/user.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatefulWidget {
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    print(user);
    if (user == null) {
      return Authenticate();
    } else {
      return DashboardPage();
    }
  }
}