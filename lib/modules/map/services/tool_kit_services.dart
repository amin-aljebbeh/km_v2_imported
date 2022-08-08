import 'package:maps_toolkit/maps_toolkit.dart';

import '../models/poly_info_check.dart';
import '../../../core/core_importer.dart';
import 'map_services.dart';

class ToolKitServices {
  static PolyInfoCheck checkPointWithPoly(double lat, double lng, double centerLat, double centerLng) {
    if (!MapServices.arePointsNear(lat, lng, centerLat, centerLng, 0.25)) {
      return PolyInfoCheck(isContain: false, cityId: -2);
    } else {
      var polygons = StoreProvider.of<AppState>(navigatorKey.currentContext).state.mapState.polygons;
      for (int i = 0; i < polygons.length; i++) {
        if (PolygonUtil.containsLocation(LatLng(lat, lng),
            polygons.elementAt(i).points.map((point) => LatLng(point.latitude, point.longitude)).toList(), false)) {
          return PolyInfoCheck(isContain: true, cityId: int.parse(polygons.elementAt(i).polygonId.value));
        }
      }
      return PolyInfoCheck(isContain: false, cityId: -1);
    }
  }
}
