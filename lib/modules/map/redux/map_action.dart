import 'dart:async';

import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../core/core_importer.dart';
import '../models/address_location_model.dart';

class GetInitialLocation {
  GetInitialLocation();
}

class InitializePolygon {
  final List<SupportedCityModel> supportedCities;
  final bool initial;

  InitializePolygon({this.initial, this.supportedCities});
}

class SetPolygon {
  final Set<Polygon> polygons;

  SetPolygon({this.polygons});
}

class SetAddressLocation {
  final AddressLocationModel addressLocationModel;

  SetAddressLocation({this.addressLocationModel});
}

class CanSelectLocation {}

class CanNotSelectLocation {}

class SetCameraPosition {
  final CameraPosition newCameraPosition;

  SetCameraPosition({this.newCameraPosition});
}

class SetUserLocation {
  final LatLng userLocation;

  SetUserLocation({this.userLocation});
}

class GetUserLocation {
  final bool goToMap;
  final bool initial;
  final Completer<GoogleMapController> controller;

  GetUserLocation({this.initial, this.controller, this.goToMap});
}

class VoteForSupportedCity {
  final double lat;
  final double lng;

  VoteForSupportedCity({this.lat, this.lng});
}
