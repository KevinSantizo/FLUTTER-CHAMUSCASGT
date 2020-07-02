import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:newsport/src/components/theme.dart';
import 'package:newsport/src/pages/home.dart';
import 'package:newsport/src/pages/profile.dart';
import 'package:newsport/src/pages/reservations.dart';
import 'package:newsport/src/pages/reserve.dart';

class DashboardPage extends StatefulWidget {
  final String uid;

  const DashboardPage({Key key, this.uid}) : super(key: key);
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage>   {

  final color_1 = Color.fromRGBO(128, 207, 169, 1.0);
  final color_2 = Color.fromRGBO(250, 169, 22, 1.0);
  final color_3 = Color.fromRGBO(88, 160, 206, 1.0);
  final color_4 = Color.fromRGBO(242, 66, 54, 1.0);
  final inactiveColor = Color.fromRGBO(0, 32, 49, 1.0);


  int _currentIndex = 0;

  final List<Widget> pages = [

    Home(),
    Reservations(),
    Reserve(),
    Profile(),

  ]; 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(239,239,239, 1.0),
      body: pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        iconSize: 30.0,
        type: BottomNavigationBarType.fixed,
        unselectedItemColor: Colors.grey,
        selectedItemColor: myTheme.primaryColor,
        backgroundColor: Colors.white,
        elevation: 10.0,
        currentIndex: _currentIndex,
        onTap: (index){
          setState(() {
            _currentIndex = index;
          });
        },
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Feather.home),
            title: Text('Inicio'),
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesome.soccer_ball_o),
            title: Text('Reservas'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Feather.heart),
            title: Text('Favoritas'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Feather.user),
            title: Text('Perfil'),
          ),
        ],
      ),
      // bottomNavigationBar: BottomNavyBar(
      //   curve: Curves.fastOutSlowIn,
      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //   iconSize: 25.0,
      //   selectedIndex: _currentIndex,
      //   onItemSelected: (index) {
      //     setState(() => _currentIndex = index);
      //   },
      //   items: <BottomNavyBarItem>[
      //     BottomNavyBarItem(
      //       textAlign: TextAlign.center,
      //       title: Text('Inicio'),
      //       icon: Icon(Feather.home),
      //       activeColor: color_1,
      //       inactiveColor: inactiveColor
      //     ),
      //     BottomNavyBarItem(
      //       textAlign: TextAlign.center,
      //       title: Text('Partidos'),
      //       icon: Icon(Feather.calendar),
      //       activeColor: color_2,
      //       inactiveColor: inactiveColor
      //     ),
      //     BottomNavyBarItem(
      //       textAlign: TextAlign.center,
      //       title: Text('Favoritas'),
      //       icon: Icon(Feather.heart) ,
      //       activeColor: color_3,
      //       inactiveColor: inactiveColor
      //     ),
      //     BottomNavyBarItem(
      //       textAlign: TextAlign.center,
      //       title: Text('Perfil'),
      //       icon: Icon(LineAwesomeIcons.user, size: 30.0,),
      //       activeColor: color_4,
      //       inactiveColor: inactiveColor
      //     ),
      //   ],
      // ),
    );
  }

}

