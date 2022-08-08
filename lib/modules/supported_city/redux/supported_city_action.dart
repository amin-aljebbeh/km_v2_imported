import '../../../core/common_models/supported_city.dart';

class UpdateUserSupportedCity {
  final String supportedCityId;
  final bool initial;

  UpdateUserSupportedCity({this.initial, this.supportedCityId});
}

class UserSupportedCityUpdated {
  final String supportedCityId;
  final bool initial;

  UserSupportedCityUpdated({this.initial, this.supportedCityId});
}

class GetSupportedCities {
  final bool initial;

  GetSupportedCities({this.initial = false});
}

class SupportedCitiesFetchedSuccessfully {
  final List<SupportedCityModel> supportedCities;
  final bool initial;
  final bool initPolygon;

  SupportedCitiesFetchedSuccessfully({this.initial, this.supportedCities, this.initPolygon = true});
}
