import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:provider/provider.dart';

import '../components/theme.dart';
import '../models/user.dart';


class TotalReservations extends StatefulWidget {
  TotalReservations({Key key}) : super(key: key);

  @override
  _TotalReservationsState createState() => _TotalReservationsState();
}

class _TotalReservationsState extends State<TotalReservations> {

  final _database = Firestore.instance;
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context).uid;
    return Scaffold(
      backgroundColor: Color.fromRGBO(243,246,252, 1.0),
      appBar: AppBar(
        brightness: Brightness.light,
        automaticallyImplyLeading: false,
        backgroundColor: Color.fromRGBO(243,246,252, 1.0),
        leading: IconButton(
          icon: Icon(Feather.chevron_left, color: Colors.black, size: 30.0,), 
          onPressed: () => Navigator.pop(context)
        ),
      ),
       body: Container(
         child: StreamBuilder<QuerySnapshot>(
           stream: _database.collection('users').document(user).collection('reservation').snapshots(),
           builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
            if(snapshot.data == null) return Center(child: JumpingDotsProgressIndicator(fontSize: 50.0,));
            if (snapshot.data.documents.isEmpty) {
              return Container(
                alignment: Alignment.center,
                margin: EdgeInsets.symmetric(horizontal: 15.0),
                child: ListView(
                  shrinkWrap: true,
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SvgPicture.asset('assets/junior.svg', height: 225.0,),
                    SizedBox(height: 10.0,),
                    Text('No tienes reservaciones todavía, explora nuestras canchas y empieza a jugar.', textScaleFactor: 1.1, style: GoogleFonts.ubuntu(),),
                    SizedBox(height: 30.0,),
                    FlatButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)
                      ),
                      padding: EdgeInsets.symmetric(vertical: 15.0),
                      textColor: Colors.white,
                      color: myTheme.primaryColor,
                      onPressed: () => Navigator.pushNamed(context, 'search-companies'),
                      child: Text('Explorar canchas', textScaleFactor: 1.2, style: GoogleFonts.montserrat(), ),
                    )
                  ],
                ),
              );
            } else {
              return Container(
               child: ListView(
                 children: <Widget>[
                   SizedBox(height: 30.0,),
                   Padding(
                     padding: const EdgeInsets.symmetric(horizontal: 15.0),
                     child: Text('Mis reservas', textScaleFactor: 1.7, style: GoogleFonts.montserrat(),),
                   ),
                   for (var item in snapshot.data.documents) 
                   Container(
                     padding: EdgeInsets.all(10.0),
                     child: Card(
                       elevation: 3.0,
                       shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                       ),
                       child: Row(
                         crossAxisAlignment: CrossAxisAlignment.center,
                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                         children: <Widget>[
                           Row(
                             children: <Widget>[
                               Stack(
                                 children: <Widget>[
                                   ClipRRect(
                                     borderRadius: BorderRadius.circular(10.0),
                                     child: Image(
                                       image: NetworkImage(item['image_field_url']),
                                       height: 120.0,
                                       fit: BoxFit.cover,
                                       width: 170.0,
                                     ),
                                   ),
                                    Container(
                                      alignment: Alignment.center,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: <Widget>[
                                          Text(item['company'], style: GoogleFonts.montserrat(color: Colors.white), ),
                                          Text(item['address'], textScaleFactor: 0.8, style: GoogleFonts.montserrat(color: Colors.white), ),
                                        ],
                                      ),
                                      height: 120.0,
                                      width: 170.0,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10.0),
                                        color: Colors.black.withOpacity(0.6)
                                      ),
                                    )
                                 ],
                               ),
                               VerticalDivider(color: Colors.transparent, width: 5.0),
                               Column(
                                 crossAxisAlignment: CrossAxisAlignment.start,
                                 children: <Widget>[
                                   Row(
                                     children: <Widget>[
                                       Icon(Feather.calendar, size: 20.0),
                                       VerticalDivider(width: 5.0,),
                                       Text('${item['day']}-${item['month']}-${item['year']}')
                                     ],
                                   ),
                                   SizedBox(height: 20.0,),
                                   Row(
                                     children: <Widget>[
                                       Icon(Feather.clock, size: 20.0),
                                       VerticalDivider(width: 5.0),
                                       Text('${item['schedule']}')
                                     ],
                                   ),
                                   SizedBox(height: 20.0,),
                                  Row(
                                  // crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                      children: <Widget>[
                                        Image.asset('assets/futy.png', height: 25.0,),
                                        Text('${item['type']}'.toString().substring(6), textScaleFactor: 1.2, style: GoogleFonts.ubuntu(),)
                                      ],
                                    ),
                                 ],
                               )
                             ],
                           ),
                           Padding(
                             padding: const EdgeInsets.only(right: 10.0, top: 10.0),
                             child: Column(
                               children: <Widget>[
                                 Image(
                                   image: NetworkImage(item['logo_photo']),
                                   height: 40.0,
                                 ),
                                 SizedBox(height: 10.0,),
                                 Text(item['owner'], textScaleFactor: 1.1, style: GoogleFonts.ubuntu(fontWeight: FontWeight.bold),)
                               ],
                             ),
                           )
                         ],
                       ),
                     ),
                   )
                 ],
               ),
             );
            } 
           },
         ),
       ),
    );
  }
}