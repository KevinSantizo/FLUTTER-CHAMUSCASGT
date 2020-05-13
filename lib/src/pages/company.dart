
import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:latlong/latlong.dart';
import 'package:newsport/src/components/lang.dart';
import 'package:newsport/src/pages/detail_field.dart';
import 'package:progress_indicators/progress_indicators.dart';

import '../components/theme.dart';

class CompanyPage extends StatefulWidget {
  final DocumentSnapshot ds;
   CompanyPage({this.ds});
  @override
  _CompanyPageState createState() => _CompanyPageState();
} 



class _CompanyPageState extends State<CompanyPage> {

  final databaseReference = Firestore.instance;
  bool isLoaded = true;
  dynamic _documentsLength; 
  final map = new MapController();
  navigateToDetail(DocumentSnapshot ds, DocumentSnapshot kd) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FieldDetail(
        ds: ds,
        kd: kd,
    )));
  }

  Lang scan;
  
  @override
  Widget build(BuildContext context) {
    databaseReference.collection('company').document(widget.ds.documentID).collection('fields').getDocuments().then((myDocument){
     _documentsLength = myDocument.documents.length;   
   });

    return Scaffold(
      backgroundColor: Colors.white,
      body: PageView(
        scrollDirection: Axis.vertical,
        children: <Widget>[
          isLoaded ? screenOne(context) : screenTwo(context)
        ],
      ),
    );
  }

 Widget screenOne(BuildContext context) {

   final String _name    = widget.ds.data['name'];
   final String _address = widget.ds.data['address'];
   final String _email   = widget.ds.data['email'];
   final String _city    = widget.ds.data['city'];

   final String _phone   = widget.ds.data['phone'];

   final _screenSize = MediaQuery.of(context).size;
   return FadeInDown(
     duration: Duration(milliseconds: 400),
      child: Container(
       child: Stack(
         fit: StackFit.expand,
         children: <Widget>[
           Image.network(widget.ds.data['url_image'], fit: BoxFit.cover,),
           SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
               children: <Widget>[
                 Column(
                   children: <Widget>[
                     Container(
                       alignment: Alignment.topLeft,
                       child: IconButton(
                        icon: Icon(Feather.chevron_left), 
                        onPressed: () => Navigator.popAndPushNamed(context, 'dashboard-page'),
                        iconSize: 35.0,
                        color: Colors.white
                      ),
                     ),
                     Container(
                      margin: EdgeInsets.symmetric(horizontal: 15.0),
                      alignment: Alignment.center, 
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: Hero(
                          tag: widget.ds.documentID,
                          child: Image.network(widget.ds.data['logo_photo'], 
                          height: 120.0,
                          ),
                        ),
                      )
                    ),
                   ],
                 ),
                 Column(
                  //  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                   children: <Widget>[
                     Container(
                       decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(30.0)
                       ),
                       padding: EdgeInsets.all(25.0),
                       margin: EdgeInsets.symmetric(horizontal: 15.0),
                       height: _screenSize.height * 0.3,
                       width: double.infinity,
                       child: Column(
                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                         crossAxisAlignment: CrossAxisAlignment.start,
                         children: <Widget>[
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text('$_name', textScaleFactor: 2.0, style: GoogleFonts.montserrat(color: Colors.black, fontWeight: FontWeight.bold )),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Icon(Feather.map_pin, size: 20.0,),
                              VerticalDivider(),
                              Text('$_address, $_city', textScaleFactor: 1.3, style: GoogleFonts.montserrat(),),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Icon(Feather.at_sign, size: 20.0,),
                              VerticalDivider(),
                              Text('$_email', textScaleFactor: 1.3, style: GoogleFonts.montserrat(),),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Icon(Feather.phone, size: 20.0,),
                              VerticalDivider(),
                              Text('$_phone', textScaleFactor: 1.3, style: GoogleFonts.montserrat(),),
                            ],
                          ),
                         ],
                       ),
                     ),
                     SizedBox(height: 20.0,),
                      // onPressed: () => setState(() => isLoaded = !isLoaded), 
                      //     Text('Ver canchas', textScaleFactor: 1.5, style: GoogleFonts.montserrat(color: Colors.white)),   
                      //     Icon(MaterialCommunityIcons.chevron_down, size: 35.0, color: Colors.white, ),
                      GestureDetector(
                        onTap: () => setState(() => isLoaded = !isLoaded),
                        child: Container(
                          height: 70.0,
                          padding: EdgeInsets.all(10.0),
                          margin: EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(20.0)
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text('Reservar', textScaleFactor: 1.5, style: GoogleFonts.montserrat()),   
                              VerticalDivider(color: Colors.transparent,),
                              Icon(Feather.calendar, size: 25.0),
                            ],
                          ),
                        ),
                      )
                    ],
                 ),
               ],
             ),
           )
         ],
       ),
     ),
   );
 }

 Widget screenTwo(BuildContext context) {
  DocumentSnapshot com;
  Firestore.instance.collection('company').document(widget.ds.documentID).get().then((f) => com = f );
   return BounceInUp(
    duration: Duration(milliseconds: 500),
    child: Stack(
      children: <Widget>[
        Container(
          color: Color.fromRGBO(243,246,252, 1.0),
          // margin: EdgeInsets.symmetric(horizontal: 20.0),
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                 IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                    setState(() => isLoaded = !isLoaded);
                  },
                  icon: Icon(Feather.x),
                ),
                // SizedBox(height: 10.0,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('Canchas: $_documentsLength', textScaleFactor: 1.5, style: GoogleFonts.montserrat(),),
                      RatingBar(
                        // ignoreGestures: true,
                        itemSize: 20.0,
                        initialRating: 3,
                        minRating: 1,
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        itemCount: 5,
                        itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                        itemBuilder: (context, _) => Icon(
                          Icons.star,
                          color: Colors.deepPurple
                        ),
                        onRatingUpdate: (rating) {
                          print(rating);
                        },
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height * 0.85,
              alignment: Alignment.bottomCenter,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(35.0))
              ),
              // height: MediaQuery.of(context).size.height * 1.0,
              width: double.infinity,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                margin: EdgeInsets.only(bottom: 80.0),
                child: StreamBuilder<QuerySnapshot>(
                  stream: databaseReference.collection('company').document(widget.ds.documentID).collection('fields').snapshots(),
                  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
                    if(snapshot.data == null) return Center(child: JumpingDotsProgressIndicator(fontSize: 50.0,));
                      final doc = snapshot.data.documents;
                      return Container(
                        child: ListView.builder(
                          itemCount: doc.length,
                          itemBuilder: (BuildContext context, int i){
                            return InkWell(
                              focusColor: Colors.transparent,
                              splashColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onTap: ()  {
                                  navigateToDetail(doc[i], com);
                              } ,
                              child: Column(
                                children: <Widget>[
                                Text(doc[i]['name'], textScaleFactor: 1.5, style: GoogleFonts.ubuntu(fontWeight: FontWeight.bold)),
                                  Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.0),
                                      color: Colors.white,
                                    ),
                                    margin: EdgeInsets.only(bottom: 25.0, top: 5.0),
                                    // elevation : 0.0,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10.0),
                                      child: Stack(
                                        children: <Widget>[
                                          Hero(
                                            tag: doc[i].documentID,
                                            child: FadeInImage(
                                              fit: BoxFit.cover,
                                              width: double.infinity,
                                              height: 230.0,
                                              image: NetworkImage(doc[i]['image_field_url']),
                                              placeholder: AssetImage('assets/loader.gif'),
                                              fadeInDuration: Duration( milliseconds: 200 ),
                                            ),
                                          ),
                                          Container(
                                            width: double.infinity,
                                            height: 230.0,
                                            alignment: Alignment.topLeft,
                                            child: Container(
                                            margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
                                              child: Row(
                                                crossAxisAlignment: CrossAxisAlignment.end,
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: <Widget>[
                                                  Image.asset('assets/futy.png', color: Colors.white, height: 40.0,),
                                                  Text(doc[i]['type'].toString().substring(6), textScaleFactor: 1.7, style: GoogleFonts.ubuntu(color: Colors.white),)
                                                ],
                                              ),
                                            ),
                                            // height: MediaQuery.of(context).size.height,
                                            decoration: BoxDecoration(
                                              color: Colors.black.withOpacity(0.6),
                                              borderRadius: BorderRadius.circular(10.0),
                                            ),
                                          ),
                                          // Container(
                                          //   margin: EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
                                          //   alignment: Alignment.topRight,
                                          //   child: Icon(FontAwesome.heart, color: Colors.white, size: 25.0),
                                          // ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }
                        ),
                    );
                  },
                ),
              )   
            ),
          ],
        ),
          BounceInDown(
            child: DraggableScrollableSheet(
            initialChildSize: 0.1,
            minChildSize: 0.1,
            maxChildSize: 0.68,
            builder: (BuildContext context, _scrollController){
              return Material(
                borderRadius: BorderRadius.vertical(top: Radius.circular(30.0)),
                elevation: 5.0,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(30.0)),
                    color: Colors.white,
                  ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 30.0),
                      child: SingleChildScrollView (
                        controller: _scrollController,
                        child: Column(
                          children: <Widget>[
                            Container(
                              height: 5.0,
                              width: 50.0,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30.0),
                                color: Colors.grey
                              ),
                            ),
                            SizedBox(height: 20.0,),       
                            Container(
                              alignment: Alignment.topLeft,
                              child: Row(
                                children: <Widget>[
                                  Text('Mapa', textScaleFactor: 2.0, style: GoogleFonts.montserrat(), ),
                                  VerticalDivider(width: 5.0),
                                  Image.asset('assets/map.png', height: 35.0,),
                                ],
                              ),
                            ),
                            SizedBox(height: 20.0,),       
                            _createFlutterMap(),
                            SizedBox(height: 20.0,),       
                            Divider(height: 20.0,),
                            _moreInfo(),
                          ],
                        ),
                      ),
                    )
                  ),
                );
              },
            ),
          ),
        ],
      )
    );
  }

  Widget _createFlutterMap() {
    return Stack(
      children: <Widget>[
        Container(
          height: 400.0,
          child: FlutterMap(
            mapController: map,
            options: MapOptions(
              center: LatLng(14.6407204, -90.5132675),
              zoom: 15.0,
            ),
            layers: [
              _createMap(),
              _createMarker()
            ],
          ),
        ),
      ],
    );
  }

  _createMap() {

    return TileLayerOptions(
      urlTemplate: 'https://api.mapbox.com/v4/'
      '{id}/{z}/{x}/{y}@2x.png?access_token={accessToken}',
      additionalOptions: {
        'accessToken' : 'pk.eyJ1Ijoia2V2aW5kZWxlb24xMCIsImEiOiJja2ExbW92amEwMmN0M21taG90dHpscG05In0.vJDpRWW1SZmLR2K2OAOuNA',
        'id'          : 'mapbox.dark'      
      }
    );

  }

  _createMarker() {
    return MarkerLayerOptions(
      markers: <Marker>[
        Marker(
          width: 100.0,
          height: 100.0,
          point: LatLng(14.6407204, -90.5132675),
          builder: ( context ) => Container(
            child: Icon( 
              Icons.location_on, 
              size: 50.0,
              color: Theme.of(context).primaryColor,
              ),
          )
        )
      ]
    );
  }

 Widget _moreInfo() {
   return Container(
    child: Row(
      // crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Text('¡Estamos cerca de ti!', textScaleFactor: 1.7, style: GoogleFonts.ubuntu() ),
        VerticalDivider(width: 6.0),
        Icon(Feather.map_pin, color: myTheme.primaryColor, size: 20.0)
      ],
    ),
   );
 }
}
