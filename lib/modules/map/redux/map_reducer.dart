import '../../../core/core_importer.dart';
import 'map_action.dart';
import 'map_state.dart';

Reducer<MapState> mapReducer = combineReducers<MapState>([
  TypedReducer<MapState, SetPolygon>(setPolygon),
  TypedReducer<MapState, SetAddressLocation>(setAddressLocation),
  TypedReducer<MapState, CanSelectLocation>(canSelectLocation),
  TypedReducer<MapState, CanNotSelectLocation>(canNotSelectLocation),
  TypedReducer<MapState, SetCameraPosition>(setCameraPosition),
  TypedReducer<MapState, SetUserLocation>(setUserLocation),
]);

MapState setPolygon(MapState state, SetPolygon action) {
  return state.copyWith(polygons: action.polygons);
}

MapState setAddressLocation(MapState state, SetAddressLocation action) {
  return state.copyWith(addressLocationModel: action.addressLocationModel);
}

MapState canSelectLocation(MapState state, CanSelectLocation action) {
  return state.copyWith(canSelectLocation: true);
}

MapState canNotSelectLocation(MapState state, CanNotSelectLocation action) {
  return state.copyWith(canSelectLocation: false);
}

MapState setCameraPosition(MapState state, SetCameraPosition action) {
  return state.copyWith(currentCameraPosition: action.newCameraPosition);
}

MapState setUserLocation(MapState state, SetUserLocation action) {
  return state.copyWith(userLocation: action.userLocation);
}
