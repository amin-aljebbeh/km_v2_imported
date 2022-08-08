import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:meta/meta.dart';

import '../models/address_location_model.dart';

@immutable
class MapState {
  final Set<Polygon> polygons;
  final AddressLocationModel addressLocationModel;
  final bool canSelectLocation;
  final CameraPosition currentCameraPosition;
  final LatLng userLocation;
  final Location location;

  const MapState({
    this.location,
    this.userLocation,
    this.currentCameraPosition,
    this.canSelectLocation,
    this.addressLocationModel,
    this.polygons,
  });

  factory MapState.initial() {
    return MapState(
      polygons: const {},
      addressLocationModel: AddressLocationModel(),
      canSelectLocation: false,
      currentCameraPosition: const CameraPosition(target: LatLng(0.0, 0.0)),
      userLocation: const LatLng(0.0, 0.0),
      location: Location(),
    );
  }

  MapState copyWith({
    Set<Polygon> polygons,
    AddressLocationModel addressLocationModel,
    bool canSelectLocation,
    CameraPosition currentCameraPosition,
    LatLng userLocation,
    Location location,
  }) {
    return MapState(
      polygons: polygons ?? this.polygons,
      addressLocationModel: addressLocationModel ?? this.addressLocationModel,
      canSelectLocation: canSelectLocation ?? this.canSelectLocation,
      currentCameraPosition: currentCameraPosition ?? this.currentCameraPosition,
      userLocation: userLocation ?? this.userLocation,
      location: location ?? this.location,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MapState &&
          runtimeType == other.runtimeType &&
          polygons == other.polygons &&
          addressLocationModel == other.addressLocationModel &&
          canSelectLocation == other.canSelectLocation &&
          currentCameraPosition == other.currentCameraPosition &&
          userLocation == other.userLocation &&
          location == other.location;

  @override
  int get hashCode => super.hashCode;
}
