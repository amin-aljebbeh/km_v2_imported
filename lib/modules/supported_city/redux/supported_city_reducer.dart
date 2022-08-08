import '../../../core/core_importer.dart';
import 'supported_city_action.dart';
import 'supported_city_state.dart';

Reducer<SupportedCityState> supportedCityReducer = combineReducers<SupportedCityState>([
  TypedReducer<SupportedCityState, UserSupportedCityUpdated>(userSupportedCityUpdated),
  TypedReducer<SupportedCityState, SupportedCitiesFetchedSuccessfully>(supportedCitiesFetchedSuccessfully),
]);

SupportedCityState userSupportedCityUpdated(SupportedCityState state, UserSupportedCityUpdated action) {
  return state.copyWith(selectedSupportedCityId: action.supportedCityId);
}

SupportedCityState supportedCitiesFetchedSuccessfully(
    SupportedCityState state, SupportedCitiesFetchedSuccessfully action) {
  return state.copyWith(supportedCities: action.supportedCities);
}
