import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:kammun_app/modules/map/redux/map_action.dart';
import '../../../core/core_importer.dart';
import '../../supported_city/redux/supported_city_action.dart';
import '../models/poly_info_check.dart';
import '../services/map_services.dart';
import '../services/tool_kit_services.dart';
import '../view/kammun_map.dart';
import '../view/location_permission.dart';

Future<void> mapMiddleware(Store<AppState> store, action, NextDispatcher next) async {
  if (action is InitializePolygon) {
    store.dispatch(StartLoading());
    Set<Polygon> polygons = MapServices.importSupportedCityPolygon(supportedCities: action.supportedCities);
    store.dispatch(SetPolygon(polygons: polygons));
    store.dispatch(GetUserLocation(goToMap: !action.initial, initial: action.initial));
  } else if (action is GetUserLocation) {
    store.state.mapState.location
        .getLocation()
        .then((location) async {
          CameraPosition myPositionCam =
              CameraPosition(target: LatLng(location.latitude, location.longitude), zoom: 14.4746);
          store.dispatch(SetUserLocation(userLocation: LatLng(location.latitude, location.longitude)));
          store.dispatch(SetCameraPosition(newCameraPosition: myPositionCam));
          if (action.goToMap) {
            store.dispatch(Push(routeName: KammunMapView.routeName));
          } else {
            if (action.initial) {
              PolyInfoCheck polyInfoCheck = ToolKitServices.checkPointWithPoly(
                  location.latitude, location.longitude, location.latitude, location.longitude);
              if (polyInfoCheck.isContain) {
                store
                    .dispatch(UpdateUserSupportedCity(supportedCityId: polyInfoCheck.cityId.toString(), initial: true));
              } else {
                store.dispatch(StopLoading());
                Navigator.of(navigatorKey.currentContext)
                    .pushNamedAndRemoveUntil(store.state.startupState.startingRout, (Route<dynamic> route) => false);
              }
            } else {
              action.controller.future.then((controller) {
                final GoogleMapController controller1 = controller;
                var myPositionCam = CameraPosition(
                    target:
                        LatLng(store.state.mapState.userLocation.latitude, store.state.mapState.userLocation.longitude),
                    zoom: 16.00);
                controller1.animateCamera(CameraUpdate.newCameraPosition(myPositionCam));
              });
            }
          }
        })
        .catchError((e) => askForLocationPermission(context: navigatorKey.currentContext))
        .timeout(Duration(seconds: action.initial ? 60 : 10), onTimeout: () {
          if (store.state.loadingState.isLoading) {
            store.dispatch(StopLoading());
            flushbar(
                message: 'يرجى التأكد من تفعيل خاصية تحديد المواقع على الهاتف والمحاولة مجدداً',
                color: Colors.red,
                icon: Icons.location_disabled,
                duration: 3);
          }
        });
  } else if (action is VoteForSupportedCity) {
    await MapServices.voteForSupportedCity(lat: action.lat, lng: action.lng);
    flushbar(message: 'شكراً لك تم التصويت للمنطقة', color: Colors.green, icon: Icons.check_circle);
    store.dispatch(StopLoading());
  }
  next(action);
}
