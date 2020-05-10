import 'dart:math';

import 'package:animate_do/animate_do.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:newsport/src/components/theme.dart';
import 'package:newsport/src/models/user.dart';
import 'package:newsport/src/pages/company.dart';
import 'package:newsport/src/services/auth.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:provider/provider.dart';


final _databaseReference = Firestore.instance; 
final AuthService _auth = AuthService();

//////////////////// Get data Home ////////////////////

// Get companies
getNewsCompanies(BuildContext context) {

  navigateToCompany(DocumentSnapshot ds) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CompanyPage(
        ds: ds,
    )));
  }

  return Material(
    elevation: 3.0,
    child: Container(
      color: Colors.white,
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 15.0, top: 25.0,),
            child: Row(
              children: <Widget>[
                Transform.rotate(
                  angle: - pi * 0.5,
                  child: Icon(MdiIcons.soccerField, size: 20.0,)
                ),
                VerticalDivider(width: 5.0,),
                Text('Nuevas', style: GoogleFonts.montserrat(textStyle:  TextStyle( fontSize: 20.0,)) ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 25.0),
            height: 350.0,
            // color: Colors.white,
            child: StreamBuilder<QuerySnapshot>(
              stream: _databaseReference.collection('company').where('name', whereIn: ['Futeca Cayalá', 'Futeca Mixco', 'Fuera de Juego', 'Sport Center']).snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
                if (snapshot.hasData) {
                  return Container(
                    width: double.infinity,
                    child: CarouselSlider(
                      height: 370.0,
                      viewportFraction: 0.67,
                      enableInfiniteScroll: false,
                      items: snapshot.data.documents.map((company){
                        final DocumentSnapshot doc = company;
                        final String _address = doc.data['address'];
                        final String _city    = doc.data['city'];
                        return Builder(
                          builder: (BuildContext context){
                            return InkWell(
                              onTap: () => navigateToCompany(company),
                              child: Stack(
                                children: <Widget>[
                                  Container(
                                    height: 370.0,
                                    margin: EdgeInsets.symmetric(horizontal: 10.0),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10.0),
                                      child: Image(
                                        image: NetworkImage(doc.data['cover_photo']),
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.5),
                                      borderRadius: BorderRadius.circular(10.0)
                                    ),
                                    margin: EdgeInsets.symmetric(horizontal: 10.0),
                                    height: 370.0,
                                    width: double.infinity,
                                  ),
                                  Container(
                                    margin: EdgeInsets.symmetric(horizontal: 25.0, vertical: 15.0),
                                    alignment: Alignment.topRight,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10.0),
                                      child: Hero(
                                        tag: doc.documentID,
                                        child: Image(
                                          image: NetworkImage(doc.data['logo_photo']),
                                          height: 60.0,
                                        ),
                                      ),
                                    )
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 25.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: <Widget>[
                                        Container(
                                          child: Text(doc.data['name'], textScaleFactor: 2.0, style:  GoogleFonts.ubuntu(color: Colors.white),)
                                        ),
                                        SizedBox(height: 10.0,),
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: <Widget>[
                                            Icon(Feather.map_pin, color: Colors.white, size: 15.0, ),
                                            VerticalDivider(width: 4.0,),
                                            Text('$_address, $_city', style: GoogleFonts.ubuntu(color: Colors.white) ),
                                          ],
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            );
                          },
                        );
                      }).toList(),
                    )
                  );
                } else {
                  return Center(
                    child: Center(child: JumpingDotsProgressIndicator())
                  );
                }
              },
            ),
          ),
        ],
      ),
    ),
  );
}

//Get most visited
getMostVisitedCompanies(BuildContext context){

  navigateToCompany(DocumentSnapshot ds) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CompanyPage(
        ds: ds,
    )));
  }
  return Material(
    elevation: 3.0,
    child: Container(
    color: Colors.white,
    child: Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(left: 15.0, top: 25.0,),
          child: Row(
            children: <Widget>[
              Transform.rotate(
                angle: - pi * 0.5,
                child: Icon(MdiIcons.soccerField, size: 20.0,)
              ),
              VerticalDivider(width: 5.0,),
              Text('Más visitadas', style: GoogleFonts.ubuntu(textStyle:  TextStyle( fontSize: 20.0,)) ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.only(bottom: 25.0, top: 20.0),
          width: double.infinity,
          child: StreamBuilder<QuerySnapshot>(
            stream: _databaseReference.collection('company').where('owner', whereIn: ['Futeca']).snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
              return CarouselSlider(
                viewportFraction: 0.9,
                height: 280.0,
                enableInfiniteScroll: false,
                items: snapshot.data.documents.map((company){
                  final DocumentSnapshot doc = company;
                  final String _address = doc.data['address'];
                  final String _name    = doc.data['name'];
                  final String _city    = doc.data['city']; 
                  return Builder(
                    builder: (BuildContext context){
                      return InkWell(
                        onTap: () => navigateToCompany(company),
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 5.0),
                          child: Column(
                            children: <Widget>[
                              FadeIn(
                                duration: Duration(milliseconds: 1500),
                                child: Stack(
                                  alignment: AlignmentDirectional.topEnd,
                                  children: <Widget>[
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8.0),
                                      child: Image(
                                        height: 220.0,
                                        width: double.infinity,
                                        image: NetworkImage(
                                          doc.data['cover_photo'], 
                                        ), 
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(0.4),
                                        borderRadius: BorderRadius.circular(8.0),
                                      ),
                                      width: double.infinity,
                                      height: 220.0,
                                    ),
                                  ],
                                ),
                              ), 
                              SizedBox(height: 10.0),                               
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: <Widget>[
                                      Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text('$_name', textScaleFactor: 1.3, style: GoogleFonts.ubuntu()),
                                        SizedBox(height: 5.0,),
                                        Container(
                                          decoration: BoxDecoration(
                                            // color: Colors.black.withOpacity(0.2),
                                            borderRadius: BorderRadius.circular(100.0)
                                        ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              Icon(Feather.map_pin, color: Colors.grey, size: 15.0,),
                                              VerticalDivider(width: 4.5),
                                              Text('$_address, $_city', textScaleFactor: 1.1, style: GoogleFonts.ubuntu(color: Colors.grey)),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                    Container(
                                      alignment: Alignment.bottomRight,
                                      child: Material(
                                        color: Colors.transparent,
                                        child: Icon(
                                          MdiIcons.arrowRightCircle,
                                          color: Colors.black.withOpacity(0.7),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          );
                        }
                      );
                    }).toList(), 
                  );
                } else {
                  return Center(child: JumpingDotsProgressIndicator());
                }
              }
            ),
          ),
        ],
      ),
    ),
  );
}

// Get best fields

getTopCompanies(BuildContext context){

  navigateToCompany(DocumentSnapshot ds) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CompanyPage(
        ds: ds,
    )));
  }
  return Material(
    elevation: 3.0,
    child: Container(
    color: Colors.white,
    child: Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(left: 15.0, top: 25.0,),
          child: Row(
            children: <Widget>[
              Image.asset('assets/ranking.png', height: 25.0),
              VerticalDivider(width: 5.0),
              Text('Top', style: GoogleFonts.ubuntu(textStyle: TextStyle(fontSize: 20.0)),),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.only(bottom: 25.0, top: 20.0),
          width: double.infinity,
          child: StreamBuilder<QuerySnapshot>(
            stream: _databaseReference.collection('company').where('owner', whereIn: ['FDJ', 'SC', 'Sport Town', 'Profut']).snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
              return CarouselSlider(
                viewportFraction: 0.9,
                height: 280.0,
                enableInfiniteScroll: false,
                items: snapshot.data.documents.map((company){
                  final DocumentSnapshot doc = company;
                  final String _address = doc.data['address'];
                  final String _name    = doc.data['name'];
                  final String _city    = doc.data['city']; 

                  return Builder(
                    builder: (BuildContext context){
                      return InkWell(
                        onTap: () => navigateToCompany(company),
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 5.0),
                          child: Column(
                            children: <Widget>[
                              FadeIn(
                                duration: Duration(milliseconds: 1500),
                                child: Stack(
                                  alignment: AlignmentDirectional.topEnd,
                                  children: <Widget>[
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8.0),
                                      child: Image(
                                        height: 220.0,
                                        width: double.infinity,
                                        image: NetworkImage(
                                          doc.data['cover_photo'], 
                                        ), 
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(0.4),
                                        borderRadius: BorderRadius.circular(8.0),
                                      ),
                                      width: double.infinity,
                                      height: 220.0,
                                    ),
                                  ],
                                ),
                              ), 
                              SizedBox(height: 10.0),                               
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: <Widget>[
                                      Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text('$_name', textScaleFactor: 1.3, style: GoogleFonts.ubuntu()),
                                        SizedBox(height: 5.0,),
                                        Container(
                                          decoration: BoxDecoration(
                                            // color: Colors.black.withOpacity(0.2),
                                            borderRadius: BorderRadius.circular(100.0)
                                        ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              Icon(Feather.map_pin, color: Colors.grey, size: 15.0,),
                                              VerticalDivider(width: 4.5),
                                              Text('$_address, $_city', textScaleFactor: 1.1, style: GoogleFonts.ubuntu(color: Colors.grey),),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                    Container(
                                      alignment: Alignment.bottomRight,
                                      child: Material(
                                        color: Colors.transparent,
                                        child: Icon(
                                          MdiIcons.arrowRightCircle,
                                          color: Colors.black.withOpacity(0.7),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          );
                        }
                      );
                    }).toList(), 
                  );
                } else {
                  return Center(child: JumpingDotsProgressIndicator());
                }
              }
            ),
          ),
        ],
      ),
    ),
  );
}

//Get reservations today
getReservationsToday(BuildContext context) {
  var user = Provider.of<User>(context).uid;
  return Container(
    child: StreamBuilder<QuerySnapshot>(
      stream: _databaseReference.collection('users').document(user).collection('reservation').where('day', isEqualTo: DateTime.now().day).snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
        if(snapshot.data == null) return Center(child: JumpingDotsProgressIndicator(fontSize: 50.0,));
        if (snapshot.data.documents.isEmpty) {
          return Material(
            elevation: 3.0,
            child: Container(
              color: Colors.white,
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
              // padding: EdgeInsets.only(bottom: 25.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                // mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Icon(FontAwesome.soccer_ball_o),
                      VerticalDivider(width: 5.0),
                      Text('Chamuscas de hoy', style: GoogleFonts.ubuntu(textStyle: TextStyle(fontSize: 20.0)),),
                    ],
                  ),
                  SizedBox(height: 10.0,),
                  Text('No tienes reservaciones para hoy.', textScaleFactor: 1.1, style: GoogleFonts.ubuntu(),),
                  SizedBox(height: 30.0,),
                  FlatButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)
                    ),
                    padding: EdgeInsets.symmetric(vertical: 25.0),
                    textColor: Colors.white,
                    color: myTheme.primaryColor,
                    onPressed: () => Navigator.pushNamed(context, 'search-companies'),
                    child: Text('Explorar canchas', textScaleFactor: 1.2, style: GoogleFonts.ubuntu(), ),
                  )
                ],
              ),
            ),
          );
        } else {
          return Material(
            elevation: 3.0,
            child: Container(
            padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 25.0),
            color: Colors.white,
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Image.asset('assets/ranking.png', height: 25.0),
                    VerticalDivider(width: 5.0),
                    Text('Chamuscas de hoy', style: GoogleFonts.ubuntu(textStyle: TextStyle(fontSize: 20.0)),),
                  ],
                ),
                  CarouselSlider(
                    scrollDirection: Axis.vertical,
                      viewportFraction: 0.9,
                      height: 150.0,
                      enableInfiniteScroll: false,
                      items: snapshot.data.documents.map((res){
                        final DocumentSnapshot doc = res;
                        return Builder(
                          builder: (BuildContext context){
                            return Container(
                              padding: EdgeInsets.symmetric(vertical: 2.0),
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
                                                image: NetworkImage(doc.data['image_field_url']),
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
                                                    Text(doc.data['company'], style: GoogleFonts.ubuntu(color: Colors.white), ),
                                                    Text(doc.data['address'], textScaleFactor: 0.8, style: GoogleFonts.ubuntu(color: Colors.white), ),
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
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Row(
                                              children: <Widget>[
                                                Icon(Feather.calendar, size: 20.0),
                                                VerticalDivider(width: 5.0,),
                                                Text('${doc.data['day']}-${doc.data['month']}-${doc.data['year']}', style: GoogleFonts.ubuntu())
                                              ],
                                            ),
                                            SizedBox(height: 20.0,),
                                            Row(
                                              children: <Widget>[
                                                Icon(Feather.clock, size: 20.0),
                                                VerticalDivider(width: 5.0),
                                                Text('${doc.data['schedule']}', style: GoogleFonts.ubuntu())
                                              ],
                                            ),
                                            SizedBox(height: 20.0,),
                                            Row(
                                            // crossAxisAlignment: CrossAxisAlignment.end,
                                              mainAxisAlignment: MainAxisAlignment.start,
                                                children: <Widget>[
                                                  Image.asset('assets/futy.png', height: 25.0,),
                                                  Text('${doc.data['type']}'.toString().substring(6), textScaleFactor: 1.2, style: GoogleFonts.ubuntu(),)
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
                                            image: NetworkImage(doc.data['logo_photo']),
                                            height: 40.0,
                                          ),
                                          SizedBox(height: 10.0,),
                                          Text(doc.data['owner'], textScaleFactor: 1.1, style: GoogleFonts.ubuntu(),)
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          }
                        );
                    }).toList(), 
                  ),
                ],
              ),
            ),
          );
        } 
      },
    ),
  );
}

//Get all companies for search
getCompanies(BuildContext context) {

  navigateToCompany(DocumentSnapshot ds) {
  print(ds.data);
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => CompanyPage(
      ds: ds,
  )));
  }

  return  StreamBuilder<QuerySnapshot>(
    stream: _databaseReference.collection('company').orderBy('owner').snapshots(),
    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
      if(snapshot.data == null) return Center(child: JumpingDotsProgressIndicator(fontSize: 50.0,));
      final orientation = MediaQuery.of(context).orientation;
      return Container(
        color: Colors.white,
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(13.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Transform.rotate(
                    angle: - pi * 0.5,
                    child: Icon(MdiIcons.soccerField, size: 20.0,)
                  ),
                  VerticalDivider(),
                  Text('Encuentra tu cancha', textScaleFactor: 1.3, style: GoogleFonts.ubuntu(color: Colors.black,)),
                ],
              ),
            ),
            Expanded(
              child: GridView.builder(
                // scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(vertical: 10.0),
                itemCount: snapshot.data.documents.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: (orientation == Orientation.portrait) ? 2 : 3),
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                    onTap: () => navigateToCompany(snapshot.data.documents[index]),
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 7.0),
                      child: GridTile(
                        // header: new Text(snapshot.data.documents[index]['name'], textScaleFactor: 1.2,  style: GoogleFonts.montserrat(color: Colors.white) ,),
                        child: Stack(
                          children: <Widget>[
                           ClipRRect(
                             borderRadius: BorderRadius.circular(10.0),
                             child: Image(
                                image: NetworkImage(snapshot.data.documents[index]['cover_photo']),
                                fit: BoxFit.fill,
                                width: double.infinity,
                                height: double.infinity,
                              ),
                           ),
                            Container(
                              alignment: Alignment.center,
                              width: double.infinity,
                              height: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                color: Colors.black.withOpacity(0.5),
                              ),
                              child: Text(snapshot.data.documents[index]['name'], textScaleFactor: 1.2,  style: GoogleFonts.ubuntu(color: Colors.white) ,), 
                            )
                          ],
                        ), //just for testing, will fill with image later
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      );
    },
  );
}

//////////////////// End of get data Home ////////////////////


//////////////////// Get data Profile ////////////////////

//Get personal info
getPersonalInfo(BuildContext context){
  var user = Provider.of<User>(context).uid;
  return Expanded(
  flex: 1,
  child: Padding(
    padding: const EdgeInsets.symmetric(vertical: 5.0),
    child: StreamBuilder<DocumentSnapshot>(
      stream: _databaseReference.collection('users').document(user).snapshots() ,
      builder: (BuildContext context, AsyncSnapshot snapshot){
        if(snapshot.data == null) return Center(child: JumpingDotsProgressIndicator(fontSize: 50.0,));
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Image(
                image: AssetImage('assets/avatar.jpg'),
                height: 150.0,
              ),
              SizedBox(height: 10.0,),
              Text(snapshot.data['name'], textScaleFactor: 1.5, style: GoogleFonts.ubuntu(fontWeight: FontWeight.bold)),
              InkWell(
                onTap: () async {
                  await _auth.signOut();
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text('Cerrar sesión', style: GoogleFonts.ubuntu(color: Colors.black) ,),
                      VerticalDivider(color: Colors.transparent, width: 5.0,),
                      Icon(Feather.log_out, color: Colors.black, size: 20.0, ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    ),
  ),
);
}

//////////////////// END Get info profile ////////////////////


//////////////////// Get reservations ////////////////////
// Get past reservations
getPastReservations(BuildContext context){
  var user = Provider.of<User>(context).uid;
  return Container(
    alignment: Alignment.bottomCenter,
    width: double.infinity,
      child: StreamBuilder<QuerySnapshot>(
      stream: _databaseReference.collection('users').document(user).collection('reservation').orderBy('day', descending: false).orderBy('schedule', descending: false).snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if(snapshot.data == null) return Center(child: JumpingDotsProgressIndicator(fontSize: 50.0,));
         if (snapshot.data.documents?.isEmpty ?? false){
          return Container(
            alignment: Alignment.center,
            margin: EdgeInsets.symmetric(horizontal: 15.0),
            child: ListView(
              shrinkWrap: true,
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
          final doc = snapshot.data.documents;
            return Container(
              margin: EdgeInsets.symmetric(horizontal: 5.0),
              child: ListView.builder(
                itemCount: doc.length,
                itemBuilder: (BuildContext context, int index){
                  if(doc == null) Center(child: JumpingDotsProgressIndicator(fontSize: 50.0,));
                  if((doc[index]['day'] < DateTime.now().day) || (doc[index]['day'] <= DateTime.now().day && doc[index]['schedule'] <= TimeOfDay.now().hour) )
                  return Container(
                      child: Card(
                        margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Stack(
                                children: <Widget>[
                                  ClipRRect(
                                    borderRadius: BorderRadius.vertical(top: Radius.circular(10.0)),                             
                                    child: Image(
                                      image: NetworkImage(doc[index]['image_field_url']),
                                      fit: BoxFit.cover,
                                      height: MediaQuery.of(context).size.height * 0.25,
                                      width: double.infinity,
                                    ),
                                  ),
                                  Container(
                                    height: MediaQuery.of(context).size.height * 0.25,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.vertical(top: Radius.circular(10.0)),                             
                                      color: Colors.black.withOpacity(0.6)
                                    ),
                                  ),
                                  Container(
                                    height: MediaQuery.of(context).size.height * 0.25,
                                    width: double.infinity,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Text('${doc[index]['company']}', textScaleFactor: 1.7, style: GoogleFonts.ubuntu(color: Colors.white)),
                                        Text(' ${doc[index]['type']}', textScaleFactor: 1.3, style: GoogleFonts.ubuntu(color: Colors.white)),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: <Widget>[
                                        Icon(Feather.clock, size: 20.0, color: Colors.white ),
                                        Text(' ${doc[index]['schedule']}:00 PM', textScaleFactor: 1.3, style: GoogleFonts.ubuntu(color: Colors.white)),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10.0,),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: <Widget>[
                                            Icon(Feather.check_circle, size: 20, color: Colors.green),
                                            VerticalDivider(width: 6.0,),
                                            Text('Partido jugado', textScaleFactor: 1.2, style: GoogleFonts.ubuntu()),
                                          ],
                                        ),
                                        SizedBox(height: 5.0),
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: <Widget>[
                                            Icon(Feather.map_pin, size: 20.0, color: Colors.grey),
                                            VerticalDivider(width: 3.0,),
                                            Text(' ${doc[index]['address']}, ${doc[index]['city']}', textScaleFactor: 1.1, style: GoogleFonts.ubuntu(color: Colors.grey)),
                                          ],
                                        ),
                                        SizedBox(height: 5.0),
                                        Row(
                                          children: <Widget>[
                                            Icon(Feather.calendar, size: 20, color: Colors.grey,),
                                            VerticalDivider(width: 3.0,),
                                            Text('${doc[index]['day']}-${doc[index]['month']}-${doc[index]['year']}', textScaleFactor: 1.2, style: GoogleFonts.ubuntu(color: Colors.grey,)),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Image(
                                      image: NetworkImage(doc[index]['logo_photo']),
                                      height: 40.0,
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(height: 20.0,),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text('Extras', textScaleFactor: 1.2, style: GoogleFonts.ubuntu(fontWeight: FontWeight.bold)),
                                    // VerticalDivider(width: 50.0,),
                                    Text('Precio', textScaleFactor: 1.2, style: GoogleFonts.ubuntu(fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ),
                              SizedBox(height: 10.0,),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    doc[index]['ball'] || doc[index]['tshirt']  ? Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 0.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          doc[index]['tshirt'] ? Row(
                                            children: <Widget>[
                                              Icon(MdiIcons.tshirtCrew, size: 20),
                                              VerticalDivider(width: 3.0,),
                                              Text('${doc[index]['tshirts_total']}', textScaleFactor: 1.2, style: GoogleFonts.ubuntu()),
                                            ],
                                          ) : Container(),
                                          SizedBox(height: 5.0,),
                                          doc[index]['ball'] ? Row(
                                            children: <Widget>[
                                              Icon(FontAwesome.soccer_ball_o, size: 20),
                                              VerticalDivider(width: 3.0,),
                                              Text('+Q20.00', textScaleFactor: 1.2, style: GoogleFonts.ubuntu()),
                                            ],
                                          ) : Container(),
                                        ],
                                      ),
                                    ) : Text('No tienes extras', textScaleFactor: 1.2, style: GoogleFonts.ubuntu()),
                                    VerticalDivider(width: 5.0, color: Colors.black ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text('Q${doc[index]['price']}.00', textScaleFactor: 1.2, style: GoogleFonts.ubuntu()),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          Divider(),
                          Divider(),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text('Total', textScaleFactor: 1.2, style: GoogleFonts.ubuntu(fontWeight: FontWeight.bold)),
                                // VerticalDivider(width: 50.0,),
                                Text('Q${doc[index]['total']}.00', textScaleFactor: 1.2, style: GoogleFonts.ubuntu(fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),        
                  ),
                ); else
                 return Container(
                  margin: EdgeInsets.symmetric(vertical: 40.0),
                  child: Column(
                    children: <Widget>[
                      Image.asset('assets/bal3.jpg', height: 120.0, color: Colors.grey,),
                      doc[index]['day'] == DateTime.now().day ? 
                      Text('Partido de hoy ${doc[index]['day']}-${doc[index]['month']}-${doc[index]['year']}', textScaleFactor: 1.2, style: GoogleFonts.ubuntu(color: Colors.grey,)) : doc[index]['day'] == DateTime.now().day + 1 ? 
                      Text('Partido de mañana ${doc[index]['day']}-${doc[index]['month']}-${doc[index]['year']}',  textScaleFactor: 1.2, style: GoogleFonts.ubuntu(color: Colors.grey,)) : Text('Partido de fecha ${doc[index]['day']}-${doc[index]['month']}-${doc[index]['year']}', textScaleFactor: 1.2, style: GoogleFonts.ubuntu(color: Colors.grey,)),
                      Text('Con horario de ${doc[index]['schedule']}:00 PM', textScaleFactor: 1.2, style: GoogleFonts.ubuntu(color: Colors.grey,)),
                      SizedBox(height: 13.0,),
                      Container(
                        padding: EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.orange),
                          borderRadius: BorderRadius.circular(10.0)
                        ),
                        child: Text('Pendiente', textScaleFactor: 1.2, style: GoogleFonts.ubuntu(color: Colors.orange))
                      ),
                    ],
                  )
                );
                },

              ),
          );
        }
      }
    ),
  );
}

// Get pendings reservation
getPendingReservations(BuildContext context) {
  var user = Provider.of<User>(context).uid;
  return Container(
    alignment: Alignment.bottomCenter,
    width: double.infinity,
      child: StreamBuilder<QuerySnapshot>(
      stream: _databaseReference.collection('users').document(user).collection('reservation').orderBy('day', descending: false).orderBy('schedule', descending: false).snapshots(),
      builder: (context, snapshot) {
        if(snapshot.data == null) return Center(child: JumpingDotsProgressIndicator(fontSize: 50.0,));
        final a = snapshot.data.documents;
        if (a?.isEmpty ?? false){
        return Container(
            alignment: Alignment.center,
            margin: EdgeInsets.symmetric(horizontal: 15.0),
            child: ListView(
              shrinkWrap: true,
              children: <Widget>[
                SvgPicture.asset('assets/junior.svg', height: 225.0,),
                SizedBox(height: 10.0,),
                Text('No tienes reservaciones pendientes, explora nuestras canchas y empieza a jugar.', textScaleFactor: 1.1, style: GoogleFonts.ubuntu(),),
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
        } else{
          final doc = snapshot.data.documents;
            return Container(
              margin: EdgeInsets.symmetric(horizontal: 5.0),
              child: ListView(
                children: <Widget>[
                  if(doc == null) Center(child: JumpingDotsProgressIndicator(fontSize: 50.0,)),
                  for (var item in doc)
                  if((item['day'] > DateTime.now().day) || (item['day'] >= DateTime.now().day && item['schedule'] > TimeOfDay.now().hour))
                    Container(
                      child: Card(
                      elevation: 3.0,
                        margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 0.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Stack(
                                children: <Widget>[
                                  ClipRRect(
                                    borderRadius: BorderRadius.vertical(bottom: Radius.circular(25.0)),                             
                                    child: Image(
                                      image: NetworkImage(item['image_field_url']),
                                      fit: BoxFit.cover,
                                      height: MediaQuery.of(context).size.height * 0.25,
                                      width: double.infinity,
                                    ),
                                  ),
                                  Container(
                                    height: MediaQuery.of(context).size.height * 0.25,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.vertical(bottom: Radius.circular(25.0)),                             
                                      color: Colors.black.withOpacity(0.6)
                                    ),
                                  ),
                                  Container(
                                    height: MediaQuery.of(context).size.height * 0.25,
                                    width: double.infinity,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Text('${item['company']}', textScaleFactor: 1.7, style: GoogleFonts.ubuntu(color: Colors.white)),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: <Widget>[
                                        Icon(Feather.clock, size: 20.0, color: Colors.white ),
                                        Text(' ${item['schedule']}:00 PM', textScaleFactor: 1.3, style: GoogleFonts.ubuntu(color: Colors.white)),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10.0,),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: <Widget>[
                                            Container(
                                              height: 17.0,
                                              width: 17.0,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.orange
                                              ),
                                            ),
                                            VerticalDivider(width: 6.0,),
                                            Text('Pendiente', textScaleFactor: 1.2, style: GoogleFonts.ubuntu(fontWeight: FontWeight.bold, color: Colors.orange))
                                          ],
                                        ),
                                        SizedBox(height: 5.0),
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: <Widget>[
                                            Icon(Feather.map_pin, size: 20.0, color: Colors.grey),
                                            VerticalDivider(width: 3.0,),
                                            Text(' ${item['address']}, ${item['city']}', textScaleFactor: 1.1, style: GoogleFonts.ubuntu(color: Colors.grey)),
                                          ],
                                        ),
                                        SizedBox(height: 5.0),
                                        Row(
                                          children: <Widget>[
                                            Icon(Feather.calendar, size: 20, color: Colors.grey,),
                                            VerticalDivider(width: 3.0,),
                                            item['day']  == DateTime.now().day ? 
                                            Text('Hoy', textScaleFactor: 1.2, style: GoogleFonts.ubuntu(color: Colors.grey,)) : item['day']  == DateTime.now().day + 1 ? 
                                            Text('Mañana', textScaleFactor: 1.2, style: GoogleFonts.ubuntu(color: Colors.grey,)) : Text('${item['day']}-${item['month']}-${item['year']}', textScaleFactor: 1.2, style: GoogleFonts.ubuntu(color: Colors.grey,)),
                                          ],
                                        ),
                                        SizedBox(height: 5.0),
                                        Row(
                                      // crossAxisAlignment: CrossAxisAlignment.end,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                          children: <Widget>[
                                            Image.asset('assets/futy.png', color: Colors.grey, height: 25.0,),
                                            Text('${item['type']}'.toString().substring(6), textScaleFactor: 1.2, style: GoogleFonts.ubuntu(color: Colors.grey),)
                                          ],
                                        ),
                                      ],
                                    ),
                                    Column(
                                      children: <Widget>[
                                        Image(
                                          image: NetworkImage(item['logo_photo']),
                                          height: 40.0,
                                        ),
                                        SizedBox(height: 10.0,),
                                        Text(item['owner'], textScaleFactor: 1.1, style: GoogleFonts.ubuntu(fontWeight: FontWeight.bold))
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(height: 20.0,),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text('Extras', textScaleFactor: 1.2, style: GoogleFonts.ubuntu(fontWeight: FontWeight.bold)),
                                    // VerticalDivider(width: 50.0,),
                                    Text('Precio', textScaleFactor: 1.2, style: GoogleFonts.ubuntu(fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ),
                              SizedBox(height: 10.0,),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    item['ball'] || item['tshirt']  ? Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 0.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          item['tshirt'] ? Row(
                                            children: <Widget>[
                                              Icon(MdiIcons.tshirtCrew, size: 20),
                                              VerticalDivider(width: 3.0,),
                                              Text('${item['tshirts_total']}', textScaleFactor: 1.2, style: GoogleFonts.ubuntu()),
                                            ],
                                          ) : Container(),
                                          SizedBox(height: 5.0,),
                                          item['ball'] ? Row(
                                            children: <Widget>[
                                              Icon(FontAwesome.soccer_ball_o, size: 20),
                                              VerticalDivider(width: 3.0,),
                                              Text('+Q20.00', textScaleFactor: 1.2, style: GoogleFonts.ubuntu()),
                                            ],
                                          ) : Container(),
                                        ],
                                      ),
                                    ) : Text('No tienes extras', textScaleFactor: 1.2, style: GoogleFonts.ubuntu()),
                                    VerticalDivider(width: 5.0, color: Colors.black ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text('Q${item['price']}.00', textScaleFactor: 1.2, style: GoogleFonts.ubuntu()),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Divider(),
                              Divider(),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text('Total', textScaleFactor: 1.2, style: GoogleFonts.ubuntu(fontWeight: FontWeight.bold)),
                                    // VerticalDivider(width: 50.0,),
                                    Text('Q${item['total']}.00', textScaleFactor: 1.2, style: GoogleFonts.ubuntu(fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ),
                              Divider(),
                              Divider(),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    FlatButton(
                                      child: Padding(
                                        padding: EdgeInsets.all(10.0),
                                        child: Text('Cancelar', textScaleFactor: 1.2,  style: GoogleFonts.montserrat() ),
                                      ),
                                      shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5.0)
                                    ),
                                      textColor: Colors.white,
                                      color: Colors.red,
                                      onPressed: (){
                                        showDialog(
                                          barrierDismissible: false,
                                          context: context,
                                          builder: (BuildContext context) {
                                            return Dialog( 
                                              child: Container(
                                                margin: EdgeInsets.symmetric(horizontal: 20.0),
                                                padding: EdgeInsets.only(top: 30.0),
                                                decoration: new BoxDecoration(
                                                  color: Colors.white,
                                                  shape: BoxShape.rectangle,
                                                  borderRadius: BorderRadius.circular(20.0),
                                                ),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: <Widget>[
                                                     Text(
                                                      '¿Desea cancelar la reserva?',
                                                      style: TextStyle(
                                                        fontSize: 20.0,
                                                        fontWeight: FontWeight.w700,
                                                      ),
                                                    ),
                                                    SizedBox(height: 30.0),
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.end,
                                                      children: <Widget>[
                                                        FlatButton(
                                                          shape: RoundedRectangleBorder(
                                                            borderRadius: BorderRadius.circular(10.0)
                                                          ),
                                                          textColor: Colors.grey,
                                                          // color: Colors.grey,
                                                          onPressed: () => Navigator.of(context).pop(),
                                                          child: Text('No', textScaleFactor: 1.2, style: GoogleFonts.montserrat(), ),
                                                        ),
                                                        FlatButton(
                                                          shape: RoundedRectangleBorder(
                                                            borderRadius: BorderRadius.circular(10.0)
                                                          ),
                                                          textColor: Colors.red,
                                                          // color: Colors.red,
                                                          onPressed: () async {
                                                            Navigator.pop(context);
                                                            // showDialog(
                                                            //   context: context,
                                                            //   builder: (context) => Center(
                                                            //     child: Loading(indicator: BallPulseIndicator(), size: 70.0,color: Colors.white)
                                                            //   )
                                                            // );
                                                            showDialog(
                                                              context: context,
                                                              builder: (context) => AlertDialog(
                                                                // title: Text('${bloc.username}'),
                                                                content: Row(
                                                                  children: <Widget>[
                                                                    Text('Reservación cancelada', textScaleFactor: 1.1, style: GoogleFonts.montserrat(), ),
                                                                  ],
                                                                ),
                                                                actions: <Widget>[
                                                                  FlatButton(
                                                                    child: Text(
                                                                      'Ok',
                                                                      style: TextStyle(
                                                                        color: myTheme.primaryColor,
                                                                      ),
                                                                    ),
                                                                    onPressed: () => Navigator.pop(context),                                                                                                       
                                                                  ),
                                                                ],
                                                              )
                                                            );
                                                            await cancelReservation(item.documentID);
                                                            await addCancelledReservation(
                                                              item['address'],
                                                              item['ball'],
                                                              item['city'],
                                                              item['company'],
                                                              item['month'],
                                                              item['day'],
                                                              item['year'],
                                                              item['measures'],
                                                              item['name'],
                                                              item['phone'],
                                                              item['owner'],
                                                              item['price'],
                                                              item['logo_photo'],
                                                              item['schedule'],
                                                              item['total'],
                                                              item['tshirt'],
                                                              item['tshirts_total'],
                                                              item['type'],
                                                              item['image_field_url'],

                                                            );
                                                          },
                                                          child: Text('Sí', textScaleFactor: 1.2, style: GoogleFonts.montserrat()),
                                                        )
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              ),
                                            );
                                          }
                                        );
                                      },
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),        
                      ),
                  ) 
                ],
              ),
            );
          }
        }
      ),
    );
  }

// Get cancelled reservations
getCancelledReservations(BuildContext context) {
  var user = Provider.of<User>(context).uid;
  print(user);
  return Container(
    alignment: Alignment.bottomCenter,
    width: double.infinity,
      child: StreamBuilder<QuerySnapshot>(
      stream: _databaseReference.collection('users').document(user).collection('cancelled').snapshots(),
      builder: (context, snapshot) {
        if(snapshot.data == null) return Center(child: JumpingDotsProgressIndicator(fontSize: 50.0,));
        final a = snapshot.data.documents;
        if (a?.isEmpty ?? false){
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
                Text('No tienes reservaciones canceladas.', textScaleFactor: 1.1, style: GoogleFonts.ubuntu(),),
                SizedBox(height: 30.0,),

              ],
            ),
          );
        } else {
          final doc = snapshot.data.documents;
            return Container(
              margin: EdgeInsets.symmetric(horizontal: 5.0),
              child: ListView.builder(
                itemCount: doc.length,
                itemBuilder: (BuildContext context, int i){
                  final String  _address      = doc[i]['address'];
                  final String  _city         = doc[i]['city'];
                  final String  _company      = doc[i]['company'];
                  final String  _type         = doc[i]['type'];
                  final String  _name         = doc[i]['name'];
                  final String  _image        = doc[i]['image_field_url'];
                  final int     _schedule     = doc[i]['schedule'];
                  final bool    _ball         = doc[i]['ball'];
                  final bool    _tshirt       = doc[i]['tshirt'];
                  final int     _totalTshirt  = doc[i]['tshirts_total'];
                  final int     _day          = doc[i]['day'];
                  final int     _month        = doc[i]['month'];
                  final int     _year         = doc[i]['year'];
                  final int     _price        = doc[i]['price'];
                  final int     _total        = doc[i]['total'];

                 return Container(
                   child: Card(
                     elevation: 3.0,
                     margin: EdgeInsets.only(top: 5.0, bottom: 10.0),
                     child: Padding(
                       padding: const EdgeInsets.only(bottom: 15.0),
                       child: Column(
                         crossAxisAlignment: CrossAxisAlignment.start,
                         children: <Widget>[
                           Stack(
                             children: <Widget>[
                               ClipRRect(
                                  borderRadius: BorderRadius.vertical(bottom: Radius.circular(25.0)),                             
                                  child: Image(
                                   image: NetworkImage('$_image'),
                                   fit: BoxFit.cover,
                                   height: MediaQuery.of(context).size.height * 0.25,
                                   width: double.infinity,
                                 ),
                               ),
                               Container(
                                 height: MediaQuery.of(context).size.height * 0.25,
                                 width: double.infinity,
                                 decoration: BoxDecoration(
                                   borderRadius: BorderRadius.vertical(bottom: Radius.circular(25.0)),                             
                                   color: Colors.grey.withOpacity(0.3)
                                 ),
                               ),
                              Container(
                                height: MediaQuery.of(context).size.height * 0.25,
                                width: double.infinity,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(' $_company', textScaleFactor: 1.7, style: GoogleFonts.ubuntu(color: Colors.grey)),
                                    Text(' $_name', textScaleFactor: 1.3, style: GoogleFonts.ubuntu(color: Colors.grey)),
                                  ],
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    Icon(Feather.clock, size: 20.0, color: Colors.grey ),
                                    Text(' ${_schedule}00:PM', textScaleFactor: 1.3, style: GoogleFonts.ubuntu(color: Colors.grey)),
                                  ],
                                ),
                              ),
                             ],
                           ),
                           SizedBox(height: 10.0,),
                           Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                             child: Row(
                               crossAxisAlignment: CrossAxisAlignment.start,
                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                               children: <Widget>[
                                 Column(
                                   crossAxisAlignment: CrossAxisAlignment.start,
                                   children: <Widget>[
                                     Row(
                                       crossAxisAlignment: CrossAxisAlignment.end,
                                       children: <Widget>[
                                         Icon(Feather.x_square, size: 20, color: Colors.red),
                                         VerticalDivider(width: 6.0,),
                                         Text('Cancelada', textScaleFactor: 1.1, style: GoogleFonts.ubuntu(color: Colors.red, fontWeight: FontWeight.bold)),
                                       ],
                                     ),
                                     SizedBox(height: 5.0),
                                     Row(
                                       crossAxisAlignment: CrossAxisAlignment.end,
                                       children: <Widget>[
                                        Icon(Feather.map_pin, size: 20.0, color: Colors.grey),
                                        VerticalDivider(width: 3.0,),
                                        Text(' $_address, $_city', textScaleFactor: 1.1, style: GoogleFonts.ubuntu(color: Colors.grey)),
                                      ],
                                    ),
                                    SizedBox(height: 5.0),
                                    Row(
                                      children: <Widget>[
                                        Icon(Feather.calendar, size: 20, color: Colors.grey,),
                                        VerticalDivider(width: 3.0,),
                                        _day == DateTime.now().day ? 
                                            Text('Cancelado para hoy', textScaleFactor: 1.2, style: GoogleFonts.ubuntu(color: Colors.grey,)) : _day  == DateTime.now().day + 1 ? 
                                            Text('Cancelado para mañana', textScaleFactor: 1.2, style: GoogleFonts.ubuntu(color: Colors.grey,)) : Text('$_day-$_month-$_year}', textScaleFactor: 1.2, style: GoogleFonts.ubuntu(color: Colors.grey,)),
                                      ],
                                    ),
                                    SizedBox(height: 5.0),
                                    Row(
                                      // crossAxisAlignment: CrossAxisAlignment.end,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: <Widget>[
                                        Image.asset('assets/futy.png', color: Colors.grey, height: 25.0,),
                                        Text('$_type'.toString().substring(6), textScaleFactor: 1.2, style: GoogleFonts.ubuntu(color: Colors.grey),)
                                      ],
                                    ),
                                  ],
                                ),
                                Image(
                                  image: NetworkImage(doc[i]['logo_photo']),
                                  height: 40.0,
                                )
                              ],
                            ),
                          ),
                          SizedBox(height: 20.0,),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text('Extras', textScaleFactor: 1.2, style: GoogleFonts.ubuntu(fontWeight: FontWeight.bold, color: Colors.grey)),
                                // VerticalDivider(width: 50.0,),
                                Text('Precio', textScaleFactor: 1.2, style: GoogleFonts.ubuntu(fontWeight: FontWeight.bold, color: Colors.grey)),
                              ],
                            ),
                          ),
                          SizedBox(height: 10.0,),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                _ball || _tshirt ? Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 0.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      _tshirt ? Row(
                                        children: <Widget>[
                                          Icon(MdiIcons.tshirtCrew, size: 20),
                                          VerticalDivider(width: 3.0,),
                                          Text('$_totalTshirt', textScaleFactor: 1.2, style: GoogleFonts.ubuntu(color: Colors.grey)),
                                        ],
                                      ) : Container(),
                                      SizedBox(height: 5.0,),
                                      _ball ? Row(
                                        children: <Widget>[
                                          Icon(FontAwesome.soccer_ball_o, size: 20),
                                          VerticalDivider(width: 3.0,),
                                          Text('+Q20.00', textScaleFactor: 1.2, style: GoogleFonts.ubuntu(color: Colors.grey)),
                                        ],
                                      ) : Container(),
                                    ],
                                  ),
                                ) : Text('No tienes extras', textScaleFactor: 1.2, style: GoogleFonts.ubuntu(color: Colors.grey)),
                                VerticalDivider(width: 5.0, color: Colors.black ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text('Q$_price.00', textScaleFactor: 1.2, style: GoogleFonts.ubuntu(color: Colors.grey)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Divider(),
                          Divider(),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text('Total', textScaleFactor: 1.2, style: GoogleFonts.ubuntu(fontWeight: FontWeight.bold, color: Colors.grey)),
                                // VerticalDivider(width: 50.0,),
                                Text('Q$_total.00', textScaleFactor: 1.2, style: GoogleFonts.ubuntu(fontWeight: FontWeight.bold, color: Colors.grey)),
                              ],
                            ),
                          ),
                        ],
                       ),
                     ),        
                   ),
                 );
                },
              ),
            );
          }
        }
      ),
    );
  }

//Cancel reservation
  cancelReservation(String idReservation) async {
  FirebaseUser currentUser = await FirebaseAuth.instance.currentUser();
  return _databaseReference.collection('users').document(currentUser.uid).collection('reservation').document(idReservation).delete();
}

Future<bool> addCancelledReservation(
  String  addressR,
  bool    isBallR,
  String  cityR,
  String  companyR,
  int     month,
  int     day,
  int     year,
  // String  descriptionR,
  String  measuresR,
  String  nameR,
  String  phoneR,
  String  ownerR,
  int     priceR,
  String  logoPhoto,
  int     scheduleR,
  int     totalR,
  bool    isTshirtR,
  int     totalTshirtR,
  String  typeR,
  String  urlImageR,
) async {
  FirebaseUser currentUser = await FirebaseAuth.instance.currentUser();

  return await Firestore.instance.collection('users').document(currentUser.uid).collection('cancelled').document().setData({
    'address'         : addressR,
    'ball'            : isBallR,
    'city'            : cityR,
    'company'         : companyR,
    'month'           : month,
    'day'             : day,
    'year'            : year,
    // 'description'     : descriptionR,
    'measures'        : measuresR,
    'name'            : nameR,
    'phone'           : phoneR,
    'owner'           : ownerR,
    'price'           : priceR,
    'logo_photo'      : logoPhoto,
    'schedule'        : scheduleR,
    'total'           : totalR,
    'tshirt'          : isTshirtR,
    'tshirts_total'   : totalTshirtR,
    'type'            : typeR,
    'image_field_url' : urlImageR
  }).then((result) => true ).catchError((err)=> false);
}

//Add reservations per user
Future<bool> adReservationPerUser(
  String  addressR,
  bool    isBallR,
  String  cityR,
  String  companyR,
  int     month,
  int     day,
  int     year,
  // String  descriptionR,
  String  measuresR,
  String  nameR,
  String  phoneR,
  String  ownerR,
  int     priceR,
  String  logoPhoto,
  int     scheduleR,
  int     totalR,
  bool    isTshirtR,
  int     totalTshirtR,
  String  typeR,
  String  urlImageR,
) async {
  FirebaseUser currentUser = await FirebaseAuth.instance.currentUser();

  return await Firestore.instance.collection('users').document(currentUser.uid).collection('reservation').document().setData({
    'address'         : addressR,
    'ball'            : isBallR,
    'city'            : cityR,
    'company'         : companyR,
    'month'           : month,
    'day'             : day,
    'year'            : year,
    // 'description'     : descriptionR,
    'measures'        : measuresR,
    'name'            : nameR,
    'phone'           : phoneR,
    'owner'           : ownerR,
    'price'           : priceR,
    'logo_photo'      : logoPhoto,
    'schedule'        : scheduleR,
    'total'           : totalR,
    'tshirt'          : isTshirtR,
    'tshirts_total'   : totalTshirtR,
    'type'            : typeR,
    'image_field_url' : urlImageR
  }).then((result) => true ).catchError((err)=> false);
}