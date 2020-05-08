import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:google_fonts/google_fonts.dart';


class Tournaments extends StatefulWidget {
  Tournaments({Key key}) : super(key: key);

  @override
  _TournamentsState createState() => _TournamentsState();
}

class _TournamentsState extends State<Tournaments> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // appBar: AppBar(
      //   brightness: Brightness.light,
      //   automaticallyImplyLeading: false,
      //   backgroundColor: Color.fromRGBO(243,246,252, 1.0),
      //   leading: IconButton(
      //     icon: Icon(Feather.chevron_left, color: Colors.black, size: 30.0,), 
      //     onPressed: () => Navigator.pop(context)
      //   ),
      // ),
       body: Stack(
         children: <Widget>[
           Material(
             elevation: 3.0,
             child: Container(
               alignment: Alignment.bottomLeft,
               height: 100.0,
               width: double.infinity,
               color: Color.fromRGBO(243,246,252, 1.0),
               child: IconButton(
                icon: Icon(Feather.chevron_left, color: Colors.black, size: 30.0,), 
                onPressed: () => Navigator.pop(context)
              ),
             ),
           ),
           Padding(
             padding: const EdgeInsets.all(20.0),
             child: Column(
               mainAxisAlignment: MainAxisAlignment.center,
              //  crossAxisAlignment: CrossAxisAlignment.center,
               children: <Widget>[
                 Image(
                   image: AssetImage('assets/soon.png'),
                   fit: BoxFit.cover,
                 ),
                 Text('¡Espéralo pronto!', textScaleFactor: 1.4, style: GoogleFonts.montserrat(), )
               ],
             ),
           ),
         ],
       ),
    );
  }
}