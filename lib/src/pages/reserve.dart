import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../services/store.dart';

class Reserve extends StatefulWidget {
  @override
  _ReserveState createState() => _ReserveState();
}

class _ReserveState extends State<Reserve> {



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(243,246,252, 1.0),
      appBar: AppBar(
        title: Text('Favoritas', textScaleFactor: 1.5, style: GoogleFonts.ubuntu(color: Colors.black), ),
        automaticallyImplyLeading: false,
        centerTitle: false,
        elevation: 0.0,
        brightness: Brightness.light,
        backgroundColor: Color.fromRGBO(243,246,252, 1.0),
      ),
      body: Container(
        child: getFavorites(context)
      )
    );
  }
}