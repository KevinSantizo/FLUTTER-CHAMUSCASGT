
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:newsport/src/components/theme.dart';
import 'package:newsport/src/pages/company.dart';
import 'package:newsport/src/services/store.dart';
import 'package:newsport/src/utils/utils.dart';
import 'package:progress_indicators/progress_indicators.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final dataBaseReference = Firestore.instance;
  SwiperController _scrollController;

  navigateToCompany(DocumentSnapshot ds) {
    print(ds.data);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CompanyPage(
        ds: ds,
    )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(243,246,252, 1.0),
      key: _scaffoldKey,
      body: CustomScrollView(
          slivers: <Widget>[
            _createAppbar(context),
            SliverList(
              delegate: SliverChildListDelegate(
              [
                _itemsHomePage(),
                SizedBox(height: 13.0,),
                getNewsCompanies(context),
                SizedBox(height: 13.0),
                getMostVisitedCompanies(context),
                SizedBox(height: 13.0),
                getTopCompanies(context),
                SizedBox(height: 13.0),
                getReservationsToday(context)
              ]
            )
          )
        ],
      ),
    );
  }

  Widget _createAppbar(context) {
  final _screenSize = MediaQuery.of(context).size;
    return Container(
      child:  SliverAppBar(
        brightness: Brightness.light,         
        actionsIconTheme: IconThemeData(
          size: 35.0,
          color: Colors.white,
        ),
        backgroundColor: Colors.white,
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 8.0, bottom: 15.0),
            child: IconButton(
              icon: Icon( Feather.search, size: 30.0, color: Colors.white ),
              onPressed: () {
                showSearch(
                context: context, 
                delegate: DataSearch(),
                // query: 'Hola'
                );
              },
            ),
          )
        ],
        automaticallyImplyLeading: false,
        elevation: 0.0,
        expandedHeight: _screenSize.height * 0.43,
        floating: true,
        pinned: false,
        flexibleSpace: FlexibleSpaceBar(
          centerTitle: true,
          background:StreamBuilder<QuerySnapshot>(
            stream: dataBaseReference.collection('company').where('name', whereIn: ['La Cantera', 'ProFútbol', 'Sport Town']).snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if(snapshot.hasData) {
                final  doc = snapshot.data.documents;
                return Swiper(
                  controller: _scrollController,
                  pagination: SwiperPagination(
                  margin: EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
                  alignment: Alignment.bottomRight,
                ),
                itemCount: doc.length,
                itemBuilder: (BuildContext context, int index ){
                  return InkWell(
                    onTap: () => navigateToCompany(doc[index]),
                    child: Container(
                    child: Stack(
                    children: <Widget>[
                      Image(
                        image: (NetworkImage(doc[index]['cover_photo'])),
                        fit: BoxFit.cover,
                        height: _screenSize.height * 0.55,
                      ),
                      Container(
                        width: double.infinity,
                        height: _screenSize.height * 0.55,
                        color: Colors.black.withOpacity(0.5)
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 15.0, vertical: 35.0),
                        padding: EdgeInsets.only(right: 25.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Text(doc[index]['name'], textScaleFactor: 4.0, style:  GoogleFonts.acme(textStyle: TextStyle(color: Colors.white.withOpacity(0.7) ))),
                            Text('Lugar perfecto para divertirse y pasarla bien', textScaleFactor: 1.3, style:  GoogleFonts.ubuntu(textStyle: TextStyle(color: Colors.white.withOpacity(0.7)))),
                            SizedBox(height: 20.0,),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          );
          } else  {
            return Center(
              child: JumpingDotsProgressIndicator(fontSize: 50.0,)
             );
              }
            }
          )
        ),
      )
    );
  }

  Widget _itemsHomePage(){ 
    return Material(
      elevation: 3.0,
      child: Container(
        color: Colors.white,
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
        height: 150.0,
        child: ListView(
          physics: BouncingScrollPhysics(),
          scrollDirection: Axis.horizontal,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                GestureDetector(
                  onTap: () => Navigator.pushNamed(context, 'tournaments'),
                  child: Container(
                    decoration: BoxDecoration(
                      color: myTheme.primaryColor.withOpacity(0.06),
                      borderRadius: BorderRadius.circular(10.0)
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 18.0),
                    margin: EdgeInsets.symmetric(horizontal: 13.0,),
                    child: Icon(FontAwesome.trophy, color: myTheme.primaryColor, size: 35.0,),
                  ),
                ),
                SizedBox(height: 10.0,),
                Text('Torneos', style: GoogleFonts.ubuntu(fontWeight: FontWeight.bold))
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                GestureDetector(
                  onTap: () => Navigator.pushNamed(context, 'tournaments'),
                  child: Container(
                    decoration: BoxDecoration(
                      color: myTheme.primaryColor.withOpacity(0.06),
                      borderRadius: BorderRadius.circular(10.0)
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 18.0),
                      margin: EdgeInsets.symmetric(horizontal: 13.0,),
                    child: Icon(FontAwesome.soccer_ball_o, color: myTheme.primaryColor, size: 35.0,),
                  ),
                ),
                SizedBox(height: 10.0,),
                Text('Express', style: GoogleFonts.ubuntu(fontWeight: FontWeight.bold))
              ],
            ),
              Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                GestureDetector(
                  onTap: () => Navigator.pushNamed(context, 'tournaments'),
                  child: Container(
                    decoration: BoxDecoration(
                      color: myTheme.primaryColor.withOpacity(0.06),
                      borderRadius: BorderRadius.circular(10.0)
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 18.0),
                      margin: EdgeInsets.symmetric(horizontal: 13.0,),
                    child: Icon(Feather.calendar, color: myTheme.primaryColor, size: 35.0,),
                  ),
                ),
                SizedBox(height: 10.0,),
                Text('Calendario', style: GoogleFonts.ubuntu(fontWeight: FontWeight.bold))
              ],
            ),
              Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                GestureDetector(
                  onTap: () => Navigator.pushNamed(context, 'tournaments'),
                  child: Container(
                    decoration: BoxDecoration(
                      color: myTheme.primaryColor.withOpacity(0.06),
                      borderRadius: BorderRadius.circular(10.0)
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 18.0),
                      margin: EdgeInsets.symmetric(horizontal: 13.0,),
                    child: Icon(MdiIcons.tshirtCrewOutline, color: myTheme.primaryColor, size: 35.0,),
                  ),
                ),
                SizedBox(height: 10.0,),
                Text('Equipos', style: GoogleFonts.ubuntu(fontWeight: FontWeight.bold))
              ],
            ),
          ],
        ),
      ),
    );
  }

}