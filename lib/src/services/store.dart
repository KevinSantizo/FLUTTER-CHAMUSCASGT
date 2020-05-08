import 'dart:math';

import 'package:animate_do/animate_do.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:newsport/src/components/theme.dart';
import 'package:newsport/src/models/user.dart';
import 'package:newsport/src/services/auth.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:provider/provider.dart';


final _databaseReference = Firestore.instance; 
final AuthService _auth = AuthService();

//////////////////// Get data Home ////////////////////
// Get companies
getNewsCompanies(BuildContext context) {

  // navigateToCompany(DocumentSnapshot ds) {
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //       builder: (context) => CompanyPage(
  //       ds: ds,
  //   )));
  // }

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
                              onTap: (){},
                              // onTap: () => navigateToCompany(company),
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

  // navigateToCompany(DocumentSnapshot ds) {
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //       builder: (context) => CompanyPage(
  //       ds: ds,
  //   )));
  // }
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
              Text('Más visitadas', style: GoogleFonts.montserrat(textStyle:  TextStyle( fontSize: 20.0,)) ),
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
                        onTap: (){},
                        // onTap: () => navigateToCompany(company),
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
                                        Text('$_name', textScaleFactor: 1.3, style: GoogleFonts.montserrat()),
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
                                              Text('$_address, $_city', textScaleFactor: 1.1, style: TextStyle(color: Colors.grey),),
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

  // navigateToCompany(DocumentSnapshot ds) {
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //       builder: (context) => CompanyPage(
  //       ds: ds,
  //   )));
  // }
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
              Text('Top', style: GoogleFonts.montserrat(textStyle: TextStyle(fontSize: 20.0)),),
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
                        onTap: (){},
                        // onTap: () => navigateToCompany(company),
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
                                        Text('$_name', textScaleFactor: 1.3, style: GoogleFonts.montserrat()),
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
                                              Text('$_address, $_city', textScaleFactor: 1.1, style: TextStyle(color: Colors.grey),),
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
      stream: Firestore.instance.collection('users').document(user).collection('reservation').where('day', isEqualTo: DateTime.now().day).snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
        if(snapshot.data == null) return Center(child: JumpingDotsProgressIndicator(fontSize: 50.0,));
        final a = snapshot.data.documents;
        if (a?.isEmpty ?? false) {
          return Material(
            elevation: 3.0,
            child: Container(
              color: Colors.white,
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text('No tienes reservaciones para hoy', style: GoogleFonts.montserrat(textStyle:  TextStyle( fontSize: 20.0,)) ),
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
            ),
          );
        } else {
          return Container(
            height: 300.0,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: snapshot.data.documents.length,
              itemBuilder: (BuildContext context, int i){
                return  Container(
                  padding: EdgeInsets.all(10.0),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Stack(
                              children: <Widget>[
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10.0),
                                  child: Image(
                                    image: NetworkImage(snapshot.data.documents[i]['image_field_url']),
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
                                      Text(snapshot.data.documents[i]['company'], style: GoogleFonts.montserrat(color: Colors.white), ),
                                      Text(snapshot.data.documents[i]['address'], textScaleFactor: 0.8, style: GoogleFonts.montserrat(color: Colors.white), ),
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
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Icon(Feather.calendar, size: 20.0),
                                    VerticalDivider(width: 5.0,),
                                    Text('${snapshot.data.documents[i]['day']}-${snapshot.data.documents[i]['month']}-${snapshot.data.documents[i]['year']}')
                                  ],
                                ),
                                SizedBox(height: 10.0,),
                                Row(
                                  children: <Widget>[
                                    Icon(Feather.clock, size: 20.0),
                                    VerticalDivider(width: 5.0),
                                    Text('${snapshot.data.documents[i]['schedule']}')
                                  ],
                                ),
                                SizedBox(height: 10.0,),
                                Row(
                                  children: <Widget>[
                                    Transform.rotate(
                                      angle: - pi * 0.5,
                                      child: Icon(MdiIcons.soccerField, size: 20.0,)
                                    ),
                                    VerticalDivider(width: 5.0),
                                    Text('${snapshot.data.documents[i]['type']}')
                                  ],
                                )
                              ],
                            )
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 5.0),
                          child: Image(
                            image: NetworkImage(snapshot.data.documents[i]['logo_photo']),
                            height: 40.0,
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        }
      },
    ),
  );
}

//Get all companies for search

getCompanies(BuildContext context) {

  // navigateToCompany(DocumentSnapshot ds) {
  // print(ds.data);
  // Navigator.push(
  //   context,
  //   MaterialPageRoute(
  //     builder: (context) => CompanyPage(
  //     ds: ds,
  // )));
  // }

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
                  Text('Encuentra tu cancha', textScaleFactor: 1.3, style: GoogleFonts.montserrat(color: Colors.black,)),
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
                    onTap: (){},
                    // onTap: () => navigateToCompany(snapshot.data.documents[index]),
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
                              child: Text(snapshot.data.documents[index]['name'], textScaleFactor: 1.2,  style: GoogleFonts.montserrat(color: Colors.white) ,), 
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
              Text(snapshot.data['name'], textScaleFactor: 1.5, style: GoogleFonts.montserrat(fontWeight: FontWeight.bold)),
              InkWell(
                onTap: () async {
                  await _auth.signOut();
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text('Cerrar sesión', style: GoogleFonts.montserrat(color: Colors.black) ,),
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