import 'package:flutter/material.dart';


class Slide {

  final String imageUrl;
  final String title;
  final String description;

  Slide({

    @required this.imageUrl,
    @required this.description,
    @required this.title

  });
}

final slideList = [

  Slide(
  imageUrl: 'assets/ucalendar.svg',
  title: 'Reservar en línea',
  description: 'Haz tus reservaciones desde tu móvil, desde cualquier lugar a cualquier hora.',
  ),
  
  Slide(
    imageUrl: 'assets/ugoal.svg',
    title: 'Partidos express',
    description: 'Consigue retos en tiempo real si no tienes contra quien jugar.'
  ),

  Slide(
    imageUrl: 'assets/uwinners.svg',
    title: 'Torneos',
    description: 'Inscribe a tu equipo y compite en los diferentes torneos organizados.',
  ),
  
];