import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:newsport/src/services/store.dart';


class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => new _ProfileState();
}

class _ProfileState extends State<Profile> {

  @override
  Widget build(BuildContext context) {
  // final bloc = Provider.of(context);
    return Scaffold(
      backgroundColor: Color.fromRGBO(243,246,252, 1.0),
      appBar: AppBar(
        title: Text('Perfil', textScaleFactor: 1.5, style: GoogleFonts.ubuntu(color: Colors.black), ),
        automaticallyImplyLeading: false,
        centerTitle: false,
        elevation: 0.0,
        brightness: Brightness.light,
        backgroundColor: Color.fromRGBO(243,246,252, 1.0),
      ),
      body: Column(
        children: <Widget>[
          getPersonalInfo(context),
          Expanded(
            flex: 2,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 25.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(40),
                ),
              ),
              child: ListView(
                children: <Widget>[
                  InkWell(
                    onTap: () => Navigator.pushNamed(context, 'total-res'),
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                      padding: EdgeInsets.all(10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Container(
                                decoration: BoxDecoration(
                                  color: Color.fromRGBO(253,243,225, 1.0),
                                  borderRadius: BorderRadius.circular(10.0)
                                ),
                                padding: EdgeInsets.all(10.0),
                                child: Icon(Feather.calendar, size: 30.0, color: Color.fromRGBO(244,184,90, 1.0)),
                              ),
                              VerticalDivider(),
                              Text('Mis reservas', textScaleFactor: 1.2, style: GoogleFonts.ubuntu(), )
                            ],
                          ),
                          Icon(Feather.chevron_right, size: 30.0, color: Colors.grey)
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      )
    );
  }
}