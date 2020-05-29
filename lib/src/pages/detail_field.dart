import 'dart:math';
import 'dart:ui';

import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:loading/indicator/ball_pulse_indicator.dart';
import 'package:loading/loading.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:newsport/src/components/reviews.dart';
import 'package:newsport/src/models/user.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:provider/provider.dart';

import '../components/theme.dart';
import '../services/store.dart';




class FieldDetail extends StatefulWidget {  
  final DocumentSnapshot ds;
  final DocumentSnapshot kd;
  final bool favoritedSelected;
   FieldDetail({this.ds, this.favoritedSelected, this.kd});
  @override
  _FieldDetailState createState() => _FieldDetailState();
}

class _FieldDetailState extends State<FieldDetail> with TickerProviderStateMixin{

  AnimationController   _colorAnimationController;
  Animation             _colorTween, _iconColorTween;
  // ScrollController      _scrollController;
  AnimationController _controller;
  Duration _duration = Duration(milliseconds: 500);
  Tween<Offset> _tween = Tween(begin: Offset(0, 1), end: Offset(0, 0));
  // Future<FirebaseUser> getUser
  
 @override
  void initState() {
    _colorAnimationController   = AnimationController(vsync: this, duration: Duration(seconds: 0));
    _colorTween                 = ColorTween(begin: Colors.white, end: Colors.white).animate(_colorAnimationController);
    _iconColorTween             = ColorTween(begin: Colors.white, end: Colors.black).animate(_colorAnimationController);   
    super.initState();
    // _scrollController = new ScrollController();
    _controller = AnimationController(vsync: this, duration: _duration);
  }

  bool _scrollListener(ScrollNotification scrollInfo) {
    if (scrollInfo.metrics.axis == Axis.vertical) {
      _colorAnimationController.animateTo(scrollInfo.metrics.pixels / 350);
      return true;
    }
      return true;
  }

  String  newDate           = '';
  String  idSchedule        = '';
  int     schedule;          
  bool    ballValue         = false;  
  bool    scheduleValue     = false;
  bool    tShirtValue       = false;
  bool    loaded            = false;
  int     priceRealBalloon  = 20;
  int     counterTshirt     = 5;
  int     total             = 0;
  int     month;
  int     day = DateTime.now().day;
  int     year;

 
  String _text            = 'Reservar';
  String _warningDate     = '';
  String _warningSchedule = '';
  
  final db = Firestore.instance.collection('users').document();

  List<int> data = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 ];
  int _hour      = TimeOfDay.now().hour;




  final List _imgDetail = [

  'https://cdn.pixabay.com/photo/2017/08/10/01/38/grass-2616911_960_720.jpg',
  'https://cdn.pixabay.com/photo/2016/11/29/07/06/bleachers-1867992__340.jpg',
  'https://cdn.pixabay.com/photo/2014/10/14/20/24/the-ball-488713_960_720.jpg', 
  'https://images.unsplash.com/photo-1546717003-caee5f93a9db?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=671&q=80',
  'https://images.unsplash.com/photo-1501127152955-b1efb91ef012?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=668&q=80'
  
];

  final List<Reviews> _reviewsList = [
    Reviews(  'John Leider',    'https://avatars0.githubusercontent.com/u/9064066?v=4&s=460',   '07 may 2020',    'This is a field very special', 4.5 ),
    Reviews(  'Marc Castillo',  'https://cdn.vuetifyjs.com/images/profiles/marcus.jpg',         '08 may 2020',    'This is a field very special', 5.0 ), 
    Reviews(  'John Leider',    'https://cdn.vuetifyjs.com/images/lists/1.jpg',                 '10 may 2020',    'This is a field very special', 4.0 ), 
    Reviews(  'John Leider',    'https://cdn.vuetifyjs.com/images/lists/2.jpg',                 '12 may 2020',    'This is a field very special', 3.9 ), 
    Reviews(  'John Leider',    'https://cdn.vuetifyjs.com/images/lists/3.jpg',                 '12 may 2020',    'This is a field very special', 5.0 ), 

  ];

  int checkBall(value){
    setState(() {
      ballValue = value;
      ballValue ? total = widget.ds.data['price'] + priceRealBalloon : total = widget.ds.data['price'];
    });
    return total;
  }

  checkTshirt(value) => setState(() {
    print(value);
    tShirtValue = value;
    if (!value) counterTshirt = 5;
  });
  
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomAppBar(
        elevation: 0.0,
        color: Colors.white,
        child: Container(
          width: double.infinity,
          height: 75.0,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: Image(
                    image: NetworkImage(widget.kd.data['logo_photo']),
                    height: 50.0,
                  ),
                ),
                FlatButton(
                    textColor: Color.fromRGBO(233,82,112, 1.0),
                    // color: Color.fromRGBO(233,82,112, 1.0),
                    onPressed: ()  { 
                      setState(() {
                        if (_controller.isDismissed) {
                          _controller.forward();
                          _text =  'Cancelar';
                          total = widget.ds.data['price'];
                          print(total);
                        } else if (_controller.isCompleted){
                           _controller.reverse();
                          _text = 'Reservar';
                        }
                      });
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        FadeIn(
                          duration: Duration(seconds : 2),
                          child: Text(_text, textScaleFactor: 1.2, style: GoogleFonts.montserrat())
                        ),
                        // VerticalDivider(),
                        SizedBox(width: 10.0,),
                        AnimatedIcon(
                          size: 25.0,
                          icon: AnimatedIcons.menu_close, progress: _controller
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
      body: SizedBox.expand(
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: <Widget>[
            NotificationListener<ScrollNotification>(
              onNotification: _scrollListener,
              child: Container(
                child: CustomScrollView(
                  slivers: <Widget>[
                    _imageAppbar(context),
                    SliverList(
                      delegate: SliverChildListDelegate(
                        [
                          _description(),
                          Divider(),
                          Padding(
                            padding: const EdgeInsets.only(left: 15.0, top: 15.0),
                            child: Text('Descripción', textScaleFactor: 1.5, style: GoogleFonts.ubuntu(textStyle: TextStyle(fontWeight: FontWeight.bold))),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Text(
                                "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.", 
                                textAlign: TextAlign.start,
                                style: GoogleFonts.montserrat(wordSpacing: 1.0),
                                textScaleFactor: 1.1,
                              ),
                            ),
                          ),
                          SizedBox(height: 20.0,),
                          _galery(context),
                          SizedBox(height: 20.0,),
                          Divider(),
                          _detailField(context),
                           Container(
                            margin: EdgeInsets.symmetric(horizontal: 30.0,),
                            decoration: BoxDecoration(
                              border: Border.all(),
                              borderRadius: BorderRadius.circular(10.0)
                            ),
                            padding: const EdgeInsets.all(20.0),
                            child: Text(
                              'NOTA: Para poder alquilar cualquiera de los implementos deberá presentar su DPI o Licencia de conducir.',
                              style: GoogleFonts.montserrat(textStyle: TextStyle()),
                              textAlign: TextAlign.justify,
                            ),
                          ),
                          Divider(height: 30.0,),
                          _reviews(),
                        ]
                      )
                    )
                  ],
                ),
              ),
            ),
            SlideTransition(
              position: _tween.animate(_controller),
              child: _draggable()
            ),
          ],
        ),
      ),
    );
  }

  Widget _imageAppbar(context){
    return Container(
      child: AnimatedBuilder(
        animation: _colorAnimationController,
        builder: (BuildContext context, child) => SliverAppBar(
          brightness: Brightness.light,
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 15.0),
              child: Icon(FontAwesome.heart, color: _iconColorTween.value, size: 25.0)
            ),
          ],
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(MdiIcons.close, color: _iconColorTween.value, size: 25.0)
          ),
          actionsIconTheme: IconThemeData(
            size: 35.0,
            color: _iconColorTween.value,
          ),
          automaticallyImplyLeading: false,
          elevation: 5.0,
          backgroundColor: _colorTween.value,
          expandedHeight: 280.0,
          floating: true,
          pinned: true,
          flexibleSpace: FlexibleSpaceBar(
            centerTitle: true,
            background: Stack(
              children: <Widget>[
                Hero(
                  tag: widget.ds.documentID,
                  child: ClipRRect(
                    borderRadius: BorderRadius.vertical(bottom: Radius.circular(23.0)),
                    child: Image(
                      image: NetworkImage(widget.ds.data['image_field_url']),
                      fit: BoxFit.cover,
                      height: 330.0,
                      width: double.infinity
                    ),
                  ),
                ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      borderRadius: BorderRadius.vertical(bottom: Radius.circular(23.0)),
                    ),
                    alignment: Alignment.bottomCenter,
                    height: 330.0,
                  )
                ],
              )
            ),
          ),
        ) 
      );
   }

 Widget _detailField(context) {
   return Padding(
     padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
     child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
       children: <Widget>[
         Padding(
           padding: const EdgeInsets.symmetric(horizontal: 15.0),
           child: Text('Implementos', textScaleFactor: 1.3, style: GoogleFonts.comfortaa(textStyle: TextStyle(fontWeight: FontWeight.bold))),
         ),
         _details(),
         SizedBox(height: 10.0),
         Divider(height: 10.0,),
         SizedBox(height: 10.0),
         Padding(
           padding: const EdgeInsets.symmetric(horizontal: 15.0),
           child: Text('Medidas y tipo de césped', textScaleFactor: 1.3, style: GoogleFonts.comfortaa(textStyle: TextStyle(fontWeight: FontWeight.bold))),
         ),
         _information()
       ],
     ),
   );
 }

  Widget _galery(context) {
   return Column(
     crossAxisAlignment: CrossAxisAlignment.start,
     children: <Widget>[
       Padding(
         padding: const EdgeInsets.symmetric(horizontal: 15.0),
         child: Text('Galería',  textScaleFactor: 1.5, style: GoogleFonts.montserrat(textStyle: TextStyle(color: Colors.grey),)),
       ),
       SizedBox(height: 10.0,),
       Container(
         height: 150.0,
        //  color: Color(0xFFF2AD65),
         child: Swiper(
           itemCount: _imgDetail.length,
           viewportFraction: 0.5,
            itemBuilder: (BuildContext context, int index) {
              return FadeIn(
                duration: Duration(milliseconds: 500),
                child: Stack(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20.0),
                        child: Image.network(
                          _imgDetail[index],
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: 250.0,
                        ),
                      ),
                    ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0),
                          color: Colors.black.withOpacity(0.3),
                        ),
                        width: double.infinity,
                      ),
                    )
                  ],
                ),
              );
            },
          ),
        ),
      ],
   );
 }

 Widget _details() {
   return Table(
     children: [
       TableRow(
         children: [
         Padding(
           padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
           child: _firstComplement(),
         ),
         Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
           child: _secondComplement(),
         ),
         ]
       ),
     ],
   );
 }

 Widget _information() {
   return Table(
     children: [
      TableRow(
         children: [
           Padding(
             padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
             child: _thirdComplement(context),
           ),
           Padding(
             padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
             child: _fourthComplement(),
           ),
         ]
       )
     ],
   );
 }

  Widget _firstComplement() {
   return Container(
     decoration: BoxDecoration(
       border: Border.all(color: Colors.grey),
      //  color: Color.fromRGBO(246,201,192, 1.0),
       borderRadius: BorderRadius.circular(10.0)
     ),
     height: 150.0,
     child: Column(
       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
       children: <Widget>[
         Image(
            image: AssetImage('assets/soccer.png'),
            height: 50.0,
          ),
        //  SizedBox(height: 30.0,),
        Text('Balls', textScaleFactor: 1.2, style: GoogleFonts.anton(),),
       ],
     ),
   );
 }

  Widget _secondComplement() {
    return Container(
      decoration: BoxDecoration(
       border: Border.all(color: Colors.grey),
      //  color: Color.fromRGBO(188, 169, 208, 1.0),
        borderRadius: BorderRadius.circular(10.0)
      ),
      height: 150.0,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Image(
            image: AssetImage('assets/tshirt.png'),
            height: 50.0,
          ),
          Text('T-shirts', textScaleFactor: 1.2, style: GoogleFonts.anton(),),
        ],
      ),
    );
  }

  Widget _thirdComplement(context) {
    return Container(
      decoration: BoxDecoration(
       border: Border.all(color: Colors.grey),

      //  color: Color.fromRGBO(250,220,143, 1.0),
        borderRadius: BorderRadius.circular(10.0)
      ),
      height: 150.0,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Image(
            image: AssetImage('assets/stadium.png'),
            height: 50.0,
          ),
          Text(widget.ds.data['measures'], textScaleFactor: 1.2, style: GoogleFonts.anton()),
        ],
      ),
    );
  }

  Widget _fourthComplement() {
    return Container(
      decoration: BoxDecoration(
       border: Border.all(color: Colors.grey),
      //  color: Color.fromRGBO(108, 160, 234, 1.0),
        borderRadius: BorderRadius.circular(10.0)
      ),
      height: 150.0,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Transform.rotate(
            angle: -pi * 0.5,
            child:
            Image(
              image: AssetImage('assets/football-field.png'),
              height: 50.0,
            ),
          ),
          Text('Sintetic', textScaleFactor: 1.2, style: GoogleFonts.anton()),
        ],
      ),
    );
  }

 Widget _description() {
   String _address  = widget.kd.data['address'];
   String _city     = widget.kd.data['city'];
   String _name     = widget.ds.data['name'];
   String _type     = widget.ds.data['type'];


   return Padding(
     padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
     child: Column(
       crossAxisAlignment: CrossAxisAlignment.start,
       children: <Widget>[
          FadeIn(
            duration: Duration(seconds: 2), 
            child: Text('$_name $_type', textScaleFactor: 1.5, style: GoogleFonts.montserrat(textStyle: TextStyle(color: Colors.black)),
          )
        ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              FadeIn(
                duration: Duration(seconds: 2), 
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(widget.kd.data['name'], textScaleFactor: 1.2, style: GoogleFonts.montserrat(textStyle: TextStyle(color: Colors.black))),
                    Row(
                      children: <Widget>[
                        Icon(Feather.map_pin, size: 15.0, color: myTheme.primaryColor),
                        VerticalDivider(width: 3.0,),
                        Text('$_address, $_city', textScaleFactor:  1.0, style: GoogleFonts.montserrat(textStyle: TextStyle(color: Colors.grey)),),
                      ],
                    )
                  ],
                ),
              ),
              FadeIn(
                duration: Duration(seconds: 2), 
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(color: Colors.grey)
                      ),
                      child: Text('Q${widget.ds.data['price']}.00', textScaleFactor: 1.0, style: GoogleFonts.ubuntu(textStyle: TextStyle(color: Colors.black)))
                    ),
                    SizedBox(height: 5.0,),
                    Row(
                      children: <Widget>[
                        Icon(MdiIcons.clock, size: 15.0, color: myTheme.primaryColor),
                        VerticalDivider(width: 3.0,),
                        Text('1 hora', textScaleFactor:  1.0, style: GoogleFonts.montserrat(textStyle: TextStyle(color: Colors.grey)),),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
       ],
     ),
   );
 }

  Widget _draggable() {
  var user = Provider.of<User>(context).uid;
  DocumentSnapshot com;
  Firestore.instance.collection('users').document(user).get().then((f) {
    com = f;
    print(com.data.length);
  } );
    return DraggableScrollableSheet(
      builder: (BuildContext context, ScrollController scrollController) {
        return Container(
          decoration: new BoxDecoration(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0)),
          color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(.5),
                blurRadius: 50.0, // soften the shadow
                spreadRadius: 50.0, //extend the shadow
                offset: Offset(
                  5.0, // Move to right 10  horizontally
                  0.0, // Move to bottom 10 Vertically
                ),
              )
            ],
          ),
          child: SingleChildScrollView(
            controller: scrollController,
            child:
              Column(
                children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: 10.0),
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(100.0)
                  ),
                  width: 60.0,
                  height: 4.0,
                ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 15.0, right: 20.0, top: 40.0, bottom: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              OutlineButton(
                                shape: StadiumBorder(),
                                borderSide: BorderSide(color: Colors.grey),
                                onPressed: () async {
                                  var date = await showDatePicker(
                                    context: context,
                                    firstDate: DateTime.now(), 
                                    initialDate: DateTime.now(), 
                                    lastDate: DateTime(2025),
                                    builder: (BuildContext context, Widget child) => Theme(
                                      data: ThemeData.dark(),
                                      child: child,
                                    )
                                  );
                                  newDate = '${date?.day}-${date?.month}-${date?.year}';
                                  month = date?.month;
                                  day = date?.day;
                                  year = date?.year;
                                  _warningDate = '';

                                  setState(() {});
                                },
                                child: Text('Fechas', textScaleFactor: 1.2, style: GoogleFonts.montserrat())
                              ),
                              SizedBox(height: _warningDate  == '' ? 10.0 : 0.0,),
                              Text('$_warningDate', style: GoogleFonts.montserrat(color: Colors.red), )
                            ],
                          ),
                           FadeIn(
                            duration: Duration(microseconds: 3000),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                newDate.isNotEmpty && day !=null && month != null && year !=null ? Text(newDate, textScaleFactor: 1.5) : Text(''),
                                VerticalDivider(width: 6.0,),
                                Icon(Feather.calendar),
                              ],
                            ),
                          ) 
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 15.0, top: 7.0, bottom: 7.0),
                      width: double.infinity,
                      color: Colors.grey.withOpacity(0.3),
                      child: Text('Elije un horario', textScaleFactor: 1.3, style: GoogleFonts.montserrat(textStyle: TextStyle(fontWeight: FontWeight.bold)))
                    ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: StreamBuilder<QuerySnapshot>(
                          stream: Firestore.instance.collection('company').document(widget.kd.documentID).collection('fields').document(widget.ds.documentID).collection('schedules').orderBy('schedule', descending: false).snapshots(),
                          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
                            if(snapshot.data == null) return Center(child: JumpingDotsProgressIndicator(fontSize: 50.0,));
                            final data = snapshot.data.documents;
                            if ( data?.isEmpty ?? false ){
                              return Container(
                                alignment: Alignment.center,
                                margin: EdgeInsets.symmetric(horizontal: 15.0),
                                child: ListView(
                                  shrinkWrap: true,
                                  // crossAxisAlignment: CrossAxisAlignment.start,
                                  // mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Center(
                                      child: Column(
                                        children: <Widget>[
                                          Text('Aún no hay horarios disponibles.', textScaleFactor: 1.1, style: GoogleFonts.ubuntu(),),
                                          Icon(Feather.clock, size: 40.0)
                                        ],
                                      )
                                    ),
                                  ],
                                ),
                              );
                            } else {
                              final doc = snapshot.data.documents;
                              return Center(
                                child: Wrap(
                                  alignment: WrapAlignment.spaceBetween,
                                  spacing: 5.0,
                                  children: <Widget>[
                                    for (var item in doc)
                                    if(_hour < item['schedule'] && item['status'] == true)
                                    ChoiceChip(
                                      shape: StadiumBorder(side: BorderSide(color: schedule == item['schedule'] ? Colors.white : Colors.grey)),
                                      label: Text('${item['schedule']}:00 hrs', style: GoogleFonts.ubuntu()),
                                      backgroundColor: Colors.transparent,
                                       onSelected: (value) {   
                                        setState(() {
                                          schedule = value ? item['schedule'] : item = null;
                                          schedule = item['schedule'];
                                          _warningSchedule = '';
                                        });
                                      },
                                      selected: schedule == item['schedule'],
                                      selectedColor: myTheme.primaryColor,
                                      labelStyle: GoogleFonts.montserrat(
                                        textStyle: TextStyle(
                                          color: schedule == item['schedule'] ? Colors.white : Colors.black,
                                        ),
                                      ),
                                    )
                                    else if (
                                      day > DateTime.now().day
                                    )
                                    ChoiceChip(
                                      shape: StadiumBorder(side: BorderSide(color: schedule == item['schedule'] ? Colors.white : Colors.grey)),
                                      label: Text('${item['schedule']}:00 hrs', style: GoogleFonts.ubuntu()),
                                      backgroundColor: Colors.transparent,
                                       onSelected: (value) {   
                                        setState(() {
                                          schedule = value ? item['schedule'] : item = null;
                                          schedule = item['schedule'];
                                          idSchedule = item.documentID;
                                          _warningSchedule = '';
                                        });
                                      },
                                      selected: schedule == item['schedule'],
                                      selectedColor: myTheme.primaryColor,
                                      labelStyle: GoogleFonts.montserrat(
                                        textStyle: TextStyle(
                                          color: schedule == item['schedule'] ? Colors.white : Colors.black,
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
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: Text(_warningSchedule, style: GoogleFonts.montserrat(color: Colors.red), ),
                      ),
                      SizedBox(height: _warningSchedule == '' ? 0.0 : 10.0,),
                      Container(
                        padding: EdgeInsets.only(left: 15.0, top: 7.0, bottom: 7.0),
                        width: double.infinity,
                        color: Colors.grey.withOpacity(0.3),
                        child: Text('Extras', textScaleFactor: 1.3, style: GoogleFonts.montserrat(textStyle: TextStyle(fontWeight: FontWeight.bold)))
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 30.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Checkbox(
                              activeColor: myTheme.primaryColor,
                              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              value: ballValue,
                              onChanged: checkBall,
                            ),
                            Image(
                              image: AssetImage('assets/soccer64.png'),
                              height: 50.0,
                            ),
                          VerticalDivider(),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text('Balón', style: GoogleFonts.montserrat(textStyle: TextStyle(fontWeight: FontWeight.bold))),
                              Text('No. 5', textScaleFactor: 1.0, style: GoogleFonts.montserrat(textStyle: TextStyle( color: Colors.grey.withOpacity(0.7)))),
                              SizedBox(height: 10.0,),
                              Text('GTQ $priceRealBalloon.00', style: GoogleFonts.montserrat(textStyle: TextStyle( color: myTheme.primaryColor))),
                            ],
                          )
                        ],
                      ),
                    ),
                    // Divider(),
                     Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Checkbox(
                                  activeColor: myTheme.primaryColor,
                                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  value: tShirtValue,
                                  onChanged: checkTshirt, 
                                ),
                              Image(
                                image: AssetImage('assets/tshirt64.png'),
                                height: 50.0,
                              ),
                              VerticalDivider(),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text('T-shirts', style: GoogleFonts.montserrat(textStyle: TextStyle(fontWeight: FontWeight.bold))),
                                  Opacity(opacity: 0.0, child: Text('Q ${priceRealBalloon}0', textScaleFactor: 1.2, style: GoogleFonts.montserrat(textStyle: TextStyle( decoration: TextDecoration.lineThrough, color: Colors.grey.withOpacity(0.7), fontWeight: FontWeight.bold)))),
                                  SizedBox(height: 5,),
                                  Text('Gratis', style: GoogleFonts.montserrat(textStyle: TextStyle(color: myTheme.primaryColor))),
                                ],
                              ),                                
                            ],
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              Column(
                                children: <Widget>[
                                  IconButton(
                                    onPressed: counterTshirt < 15  && tShirtValue ? () => setState((){ counterTshirt++; }) : null, 
                                    icon: Icon(MdiIcons.plus, size: 25.0, color: counterTshirt < 15 && tShirtValue ? myTheme.primaryColor : Colors.grey)
                                  ),
                                  Text('$counterTshirt', textScaleFactor: 1.3, style: GoogleFonts.montserrat(
                                    textStyle: TextStyle(color: counterTshirt < 15 && counterTshirt >5 && tShirtValue ? Colors.black : Colors.grey) 
                                  )),
                                  IconButton(
                                    alignment: Alignment.bottomCenter,
                                    onPressed: counterTshirt > 5 && tShirtValue ? () => setState((){ counterTshirt--; }) : null, 
                                    icon: Icon(MdiIcons.minus, size: 25.0, color: counterTshirt > 5 && tShirtValue ? myTheme.primaryColor : Colors.grey )
                                  ),
                                ],
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    Divider(color: Colors.black),
                    Divider(color: Colors.black),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Text('Total', textScaleFactor: 1.3, style:  GoogleFonts.montserrat(textStyle: TextStyle(color: Colors.grey) )),
                          VerticalDivider(),
                          Text('GTQ $total.00', textScaleFactor: 1.7, style:  GoogleFonts.montserrat()), 
                        ],
                      ),
                    ),
                    SizedBox(height: 30.0,),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          FlatButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0)
                            ),
                            color: myTheme.primaryColor,
                            onPressed: () async {
                              setState(() {
                                newDate  == '' ?  _warningDate        = 'Debes seleccionar una fecha' :  _warningDate     = '';
                                schedule == null ?  _warningSchedule  = 'Debes elegir un horario'     :  _warningSchedule = '';
                              });
                              if (newDate != '' && schedule != null) {
                              showDialog(
                                context: context,
                                builder: (context) => Center(
                                  child: Loading(indicator: BallPulseIndicator(), size: 70.0,color: Colors.white)
                                )
                              );
                              await adReservationPerUser(
                                widget.kd.data['address'],
                                com?.data['name'],
                                ballValue,
                                widget.kd.data['city'],
                                widget.kd.data['name'],
                                month,
                                day,
                                year,
                                (day > DateTime.now().day) || (day >= DateTime.now().day && schedule > TimeOfDay.now().hour) ? 'Pendiente' : 'Jugado',
                                widget.ds.data['measures'],
                                widget.ds.data['name'],
                                widget.kd.data['phone'],
                                widget.kd.data['owner'],
                                widget.ds.data['price'],
                                widget.kd.data['logo_photo'],
                                schedule,
                                total,
                                tShirtValue,
                                tShirtValue ? counterTshirt : 0,
                                widget.ds.data['type'],
                                widget.ds.data['image_field_url'],
                              );
                              await Firestore.instance.collection('company').document(widget.kd.documentID).collection('fields').document(widget.ds.documentID).collection('reservation').document().setData({
                                'address'         : widget.kd.data['address'],
                                'user'            : com?.data['name'],
                                'ball'            : ballValue,
                                'city'            : widget.kd.data['city'],
                                'company'         : widget.kd.data['name'],
                                'month'           : month,
                                'day'             : day,
                                'year'            : year,
                                'status'          : (day > DateTime.now().day) || (day >= DateTime.now().day && schedule > TimeOfDay.now().hour) ? 'Pendiente' : 'Jugado',
                                'measures'        : widget.ds.data['measures'],
                                'name'            : widget.ds.data['name'],
                                'phone'           : widget.kd.data['phone'],
                                'owner'           : widget.kd.data['owner'],
                                'price'           : widget.ds.data['price'],
                                'phone_user'      : com?.data['phone'],
                                'logo_photo'      : widget.kd.data['logo_photo'],
                                'schedule'        : schedule,
                                'total'           : total,
                                'tshirt'          : tShirtValue,
                                'tshirts_total'   : tShirtValue ? counterTshirt : 0,
                                'type'            : widget.ds.data['type'],
                                'image_field_url' : widget.ds.data['image_field_url']
                              });
                              await Firestore.instance.collection('company').document(widget.kd.documentID).collection('fields').document(widget.ds.documentID).collection('schedules').document(idSchedule).updateData(
                                {
                                  'status' : false
                                }
                              );
                              Navigator.pop(context);
                              showDialog(
                                context: context,
                                builder: (context) => Dialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0)
                                  ),
                                  // title: Text('${bloc.username}'),
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 20.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.stretch,
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: <Widget>[
                                            Text('¡Reservación exitosa!', textScaleFactor: 1.3, style: GoogleFonts.ubuntu(fontWeight: FontWeight.bold)),
                                            SizedBox(width: 10.0,),
                                            Icon(Feather.check_square, color: Colors.green,)
                                          ],
                                        ),
                                        SizedBox(height: 40.0,),
                                        FlatButton(
                                          padding: EdgeInsets.all(20.0),
                                          color: Colors.green.withOpacity(0.1),
                                          child: Text(
                                            'Ok',
                                            textScaleFactor: 1.3,
                                            style: GoogleFonts.ubuntu(color: myTheme.primaryColor),
                                          ),
                                          onPressed: (){
                                            setState(() {
                                              if (_controller.isDismissed) {
                                                _controller.forward(); 
                                                _text =  'Cancelar';
                                              } else if (_controller.isCompleted){
                                                _controller.reverse();
                                                _text =  'Reservar';
                                                newDate = '';
                                                schedule          = null;
                                                ballValue         = false;  
                                                scheduleValue     = false;
                                                tShirtValue       = false;
                                              }
                                            });
                                            Navigator.pop(context);
                                          }
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              );
                            }
                          },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text('Reservar', textScaleFactor: 1.5, style:  GoogleFonts.montserrat(textStyle: TextStyle(color: Colors.white) )),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10.0)
                                    ),
                                    padding: EdgeInsets.all(8.0),
                                    child: Icon(MdiIcons.chevronRight, color: myTheme.primaryColor),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

 Widget _reviews() {
   return Container(
     margin: EdgeInsets.symmetric(horizontal: 15.0,),
     padding: EdgeInsets.only(bottom: 50.0),
     child: Column(
       crossAxisAlignment: CrossAxisAlignment.start,
       children: <Widget>[
        Text('Reviews',  textScaleFactor: 1.5, style: GoogleFonts.montserrat(textStyle: TextStyle(color: Colors.grey),)),  
         for (var i = 0; i < _reviewsList.length; i++) 
         Padding(
           padding: const EdgeInsets.symmetric(vertical: 8.0),
           child: Card(
             shape: RoundedRectangleBorder(
               borderRadius: BorderRadius.only(topLeft: Radius.circular(20.0), bottomRight: Radius.circular(20.0))
             ),
             color: Colors.white,
             elevation: 10.0,
             child: Padding(
               padding: const EdgeInsets.all(8.0),
               child: Column(
                 children: <Widget>[
                    Row(
                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                     children: <Widget>[
                       Row(
                         children: <Widget>[
                          CircleAvatar(
                            backgroundColor: Colors.grey,
                            backgroundImage: NetworkImage(_reviewsList[i].image),
                          ),
                          VerticalDivider(),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(_reviewsList[i].name, style: GoogleFonts.montserrat(textStyle: TextStyle(fontWeight: FontWeight.bold) ),),
                              Text(_reviewsList[i].coment),
                            ],
                          ),
                         ],
                       ),
                        Row(
                          children: <Widget>[
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                Text('Very good ${_reviewsList[i].rating}'),
                                RatingBar(
                                  itemSize: 15.0,
                                  initialRating: _reviewsList[i].rating,
                                  minRating: 1,
                                  direction: Axis.horizontal,
                                  allowHalfRating: true,
                                  itemCount: 5,
                                  itemPadding: EdgeInsets.symmetric(horizontal: 0.0),
                                  itemBuilder: (context, _) => Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                  ),
                                  onRatingUpdate: (rating) {
                                    print(rating);
                                  },
                                )
                              ],
                            )
                          ],
                        ),
                     ],
                   ),
                    Text(
                      "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.", 
                      textAlign: TextAlign.justify,
                      style: GoogleFonts.montserrat(textStyle: TextStyle(color: Colors.grey)),
                    ),
                 ],
               ),
             )
           ),
         )
       ],
     ),
   );
 }
}