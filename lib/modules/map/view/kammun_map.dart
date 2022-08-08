import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:kammun_app/modules/map/models/address_location_model.dart';
import 'package:kammun_app/modules/map/models/polygon_model.dart';
import 'package:kammun_app/modules/map/redux/map_action.dart';
import '../../../core/core_importer.dart';
import '../models/poly_info_check.dart';
import '../services/map_services.dart';
import '../services/tool_kit_services.dart';
import 'city_not_supported.dart';

class KammunMapView extends StatefulWidget {
  static const String routeName = '/CustomMapView';

  const KammunMapView({Key key}) : super(key: key);
  @override
  _KammunMapViewState createState() => _KammunMapViewState();
}

class _KammunMapViewState extends State<KammunMapView> {
  final Completer<GoogleMapController> mapController = Completer();
  @override
  void initState() {
    MapServices.moveToLocation(theController: mapController);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
        converter: (store) => store.state,
        distinct: true,
        builder: (context, state) {
          return TemporaryLoading(
            child: Scaffold(
              body: Stack(
                children: [
                  GoogleMap(
                    mapType: MapType.normal,
                    initialCameraPosition: state.mapState.currentCameraPosition,
                    onMapCreated: (GoogleMapController controller) => mapController.complete(controller),
                    mapToolbarEnabled: false,
                    zoomControlsEnabled: false,
                    myLocationButtonEnabled: false,
                    rotateGesturesEnabled: false,
                    zoomGesturesEnabled: true,
                    onCameraMove: (CameraPosition position) {
                      StoreProvider.of<AppState>(context).dispatch(SetCameraPosition(newCameraPosition: position));

                      if (ToolKitServices.checkPointWithPoly(position.target.latitude, position.target.longitude,
                              state.mapState.userLocation.latitude, state.mapState.userLocation.longitude)
                          .isContain) {
                        StoreProvider.of<AppState>(context).dispatch(CanSelectLocation());
                      } else {
                        StoreProvider.of<AppState>(context).dispatch(CanNotSelectLocation());
                      }
                    },
                    polygons: state.mapState.polygons,
                    circles: {
                      Circle(
                          circleId: CircleId('currentCircle'),
                          center: LatLng(state.mapState.userLocation.latitude, state.mapState.userLocation.longitude),
                          radius: 250,
                          fillColor: ColorUtils.primaryColor.withOpacity(0.20),
                          strokeColor: ColorUtils.kmColors,
                          strokeWidth: 2),
                    },
                  ),
                  Center(
                    child: Image.asset(
                      'assets/picker.png',
                      width: 25,
                      color: state.mapState.canSelectLocation ? Colors.yellow : Colors.red,
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 15.0, bottom: 15),
                        child: GestureDetector(
                            onTap: () {
                              StoreProvider.of<AppState>(context)
                                  .dispatch(GetUserLocation(goToMap: false, controller: mapController, initial: false));
                            },
                            child: Image.asset('assets/gps.png')),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          margin: const EdgeInsets.fromLTRB(20, 0, 20, 30),
                          child: KButton(
                            color: ColorUtils.primaryColor,
                            height: 50,
                            onTap: () {
                              PolyInfoCheck polyInfoCheck = ToolKitServices.checkPointWithPoly(
                                  state.mapState.currentCameraPosition.target.latitude,
                                  state.mapState.currentCameraPosition.target.longitude,
                                  state.mapState.userLocation.latitude,
                                  state.mapState.userLocation.longitude);
                              if (polyInfoCheck.cityId == -2) {
                                flushbar(
                                    message: 'عذراً، لإضافة عنوان جديد يجب أن تكون ضمن الدائرة',
                                    color: Colors.red,
                                    icon: Icons.error);
                              } else if (polyInfoCheck.cityId == -1) {
                                showCityNotSupportedDialog(
                                    lng: state.mapState.currentCameraPosition.target.longitude,
                                    lat: state.mapState.currentCameraPosition.target.latitude);
                              } else {
                                StoreProvider.of<AppState>(navigatorKey.currentContext).dispatch(SetAddressLocation(
                                    addressLocationModel: AddressLocationModel(
                                        coords: state.mapState.currentCameraPosition.target,
                                        polygonModel: PolygonModel(
                                            supportedCityId: polyInfoCheck.cityId.toString(),
                                            supportedCityName: state.supportedCityState.supportedCities
                                                .firstWhere((city) => city.id == polyInfoCheck.cityId)
                                                .name))));
                                StoreProvider.of<AppState>(navigatorKey.currentContext)
                                    .dispatch(PushAndReplace(routeName: AddAddressView.routeName));
                              }
                            },
                            text: 'التالي',
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }
}
