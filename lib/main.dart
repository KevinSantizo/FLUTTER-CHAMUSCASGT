import 'package:flutter/material.dart';
import 'package:newsport/src/authenticate/wrapper.dart';
import 'package:newsport/src/components/initial_page.dart';
import 'package:newsport/src/models/user.dart';
import 'package:newsport/src/pages/all_companies.dart';
import 'package:newsport/src/pages/total_reservations.dart';
import 'package:newsport/src/pages/tournaments.dart';
import 'package:newsport/src/services/auth.dart';
import 'package:provider/provider.dart';
 
void main() => runApp(MyApp());
 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User>.value(
      value: AuthService().user,
      child: MaterialApp(
        theme: ThemeData(
          primaryColor: Color(0XFFF50057),
        ),
        debugShowCheckedModeBanner: false,
        home: LandingPage(),
        routes: {
          'tournaments'       : (BuildContext context) => Tournaments(),
          'search-companies'  : (BuildContext context) => AllCompaniesPage(),
          'total-res'         : (BuildContext context) => TotalReservations(),
          'wrapper'           : (BuildContext context) => Wrapper(),
          'landing'           : (BuildContext context) => LandingPage(),
        },
      ),
    );
  }
}