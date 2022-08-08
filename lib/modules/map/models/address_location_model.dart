import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'polygon_model.dart';

class AddressLocationModel {
  PolygonModel polygonModel;
  LatLng coords;

  AddressLocationModel({this.polygonModel, this.coords});
}
