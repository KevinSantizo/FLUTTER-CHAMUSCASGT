
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:newsport/src/components/slide.dart';
import 'package:newsport/src/components/slide_item.dart';

import 'theme.dart';

class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> with TickerProviderStateMixin {


  @override
  Widget build(BuildContext context) {
    
    final _size = MediaQuery.of(context).size; 
    return Scaffold(
      body : Stack(
        children: <Widget>[
        Image(
          image: AssetImage('assets/pexels.jpeg'),
          height: double.infinity,
          width: double.infinity,
          fit: BoxFit.cover
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            height: _size.height * 0.8,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  Colors.black.withOpacity(1),
                  Colors.black.withOpacity(0.9),
                  Colors.black.withOpacity(0.8),
                  Colors.black.withOpacity(0.7),
                  Colors.black.withOpacity(0.6),
                  Colors.black.withOpacity(0.5),
                  Colors.black.withOpacity(0.4),
                  Colors.black.withOpacity(0.1),
                  Colors.black.withOpacity(0.05),
                  Colors.black.withOpacity(0.025),

                ]
              )
            ),
          )
        ),
         _column() 
        ]
      )
    );
  }
 
 Widget _column() {
   return Container(
       child: Column(
          children: <Widget>[
            Expanded(
              child: Stack(
                 children: <Widget>[
                   Swiper(
                     itemBuilder: (ctx, i) => SlideItem(i),
                     itemCount: slideList.length,
                     viewportFraction: 1.0,
                     itemWidth: MediaQuery.of(context).size.width,
                     pagination: SwiperPagination(
                     ),                       
                   ),
                 ],
               ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 40.0),
              child: Column(
              //  crossAxisAlignment: CrossAxisAlignment.stretch,
               children: <Widget>[
                 RaisedButton(
                   textColor: Colors.black,
                   child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Icon(Feather.chevron_right, color: Colors.white, size: 35.0)
                    // child: Text('Comenzar', textScaleFactor: 1.5, style: GoogleFonts.amaranth(textStyle: TextStyle(color: Colors.white)),),
                  ),
                  onPressed: () => Navigator.pushReplacementNamed(context, 'wrapper'),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0)
                  ),
                    color: myTheme.primaryColor,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
