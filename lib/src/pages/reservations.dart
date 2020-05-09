import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:newsport/src/services/store.dart';

class Reservations extends StatefulWidget {
  @override
  _ReservationsState createState() => _ReservationsState();
}

class _ReservationsState extends State<Reservations> {
  
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
        child: Scaffold(
          backgroundColor: Color.fromRGBO(243,246,252, 1.0),
          key : _scaffoldKey,
          appBar: AppBar(
            centerTitle: false,
            title: Text('Mis partidos', textScaleFactor: 1.3, style: GoogleFonts.montserrat(color: Colors.black),),
            elevation: 1.0,
            brightness: Brightness.light,
            backgroundColor: Color.fromRGBO(243,246,252, 1.0),
            bottom: TabBar(
              unselectedLabelColor: Colors.grey,
              labelColor: Colors.black,
              indicatorColor: Colors.black,
              tabs: <Widget>[
                Container(
                  padding: EdgeInsets.all(8.0),
                  child: Text('Jugados', style: GoogleFonts.ubuntu()),
                ),
                Container(
                  padding: EdgeInsets.all(8.0),
                  child: Text('Pendientes', style: GoogleFonts.ubuntu()),
                ),
                Container(
                  padding: EdgeInsets.all(8.0),
                  child: Text('Cancelados', style: GoogleFonts.ubuntu()),
                ),
              ],
            ),
          ),
          body: TabBarView(
            children: <Widget>[
              getPastReservations(context),
              getPendingReservations(context),
              getCancelledReservations(context)
            ],
          ),
        ),
      );  
  }
}