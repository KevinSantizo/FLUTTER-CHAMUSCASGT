

import 'package:latlong/latlong.dart';

class Lang{

  String lang = '14.6407204, -90.5132675';

  Lang({
    this.lang
  });

 LatLng getLatLng(){
    final lalo = lang.substring(4).split(',');
    final lat = double.parse(lalo[0]);
    final lng = double.parse(lalo[1]);

    return LatLng(lat, lng);
  }

}