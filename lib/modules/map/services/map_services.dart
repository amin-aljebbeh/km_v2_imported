import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:kammun_app/core/core_importer.dart';

class MapServices {
  static Set<Polygon> importSupportedCityPolygon({List<SupportedCityModel> supportedCities}) {
    Set<Polygon> polygonSet = <Polygon>{};
    for (var city in supportedCities) {
      if (city.polygonPoints.isNotEmpty) {
        polygonSet.add(Polygon(
            polygonId: PolygonId(city.id.toString()),
            points: city.polygonPoints.map((coords) => LatLng(coords.lat, coords.lon)).toList(),
            strokeWidth: 0,
            fillColor: ColorUtils.kmColors.withOpacity(0.2),
            onTap: () {}));
      }
    }
    return polygonSet;
  }

  static Future<void> moveToLocation({Completer<GoogleMapController> theController}) async {
    final GoogleMapController controller = await theController.future;
    var myPositionCam = CameraPosition(
        target: LatLng(StoreProvider.of<AppState>(navigatorKey.currentContext).state.mapState.userLocation.latitude,
            StoreProvider.of<AppState>(navigatorKey.currentContext).state.mapState.userLocation.longitude),
        zoom: 16.00);
    await controller.animateCamera(CameraUpdate.newCameraPosition(myPositionCam));
    StoreProvider.of<AppState>(navigatorKey.currentContext).dispatch(StopLoading());
  }

  static arePointsNear(lat, lon, centerLat, centerLng, km) {
    var ky = 40000 / 360;
    var kx = cos(pi * centerLat / 180.0) * ky;
    var dx = (centerLng - lon).abs() * kx;
    var dy = (centerLat - lat).abs() * ky;
    return (sqrt(dx * dx + dy * dy) <= km);
  }

  static voteForSupportedCity({double lat, double lng}) async {
    try {
      Map body = {'latitude': lat, 'longitude': lng};
      await ApiProvider.sendRequest(url: voteSupportedCity, method: HttpMethods.post, body: jsonEncode(body));
    } catch (e) {
      /**/
    }
  }
}
