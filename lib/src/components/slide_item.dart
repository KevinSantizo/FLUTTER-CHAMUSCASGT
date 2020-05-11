import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:newsport/src/components/slide.dart';

class SlideItem extends StatefulWidget {
  final int index;
  SlideItem(this.index);

  @override
  _SlideItemState createState() => _SlideItemState();
}

class _SlideItemState extends State<SlideItem> {

  @override
  Widget build(BuildContext context) {
    final _size = MediaQuery.of(context).size;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          width: _size.width * 1.0,
          height: _size.height * 0.3,
          child: SvgPicture.asset(slideList[widget.index].imageUrl),
        ),
        SizedBox(height: 20.0,),
        Text(slideList[widget.index].title, textScaleFactor: 2.0, style: GoogleFonts.montserrat(textStyle: TextStyle( fontWeight: FontWeight.bold, color: Colors.white))),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Text(slideList[widget.index].description, textScaleFactor: 1.3, textAlign: TextAlign.center, style: GoogleFonts.montserrat(color: Colors.white),),
        ),
      ],
    );
  }
}