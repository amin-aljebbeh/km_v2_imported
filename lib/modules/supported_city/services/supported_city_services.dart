import '../../../core/core_importer.dart';

class SupportedCityServices {
  static Future<bool> updateUserSupportedCityService({String supportedCityId}) async {
    try {
      Map body = {'supported_city_id': int.parse(supportedCityId)};
      var response = await ApiProvider.sendRequest(
          url: updateUserSupportedCity, method: HttpMethods.post, body: jsonEncode(body));
      if (response != null) {
        if (response.statusCode == successCode && response.data['success']) {
          return true;
        } else {
          return false;
        }
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  static Future<List<SupportedCityModel>> getSupportedCities() async {
    try {
      var response = await ApiProvider.sendRequest(url: supportedCity, method: HttpMethods.get);
      if (response != null) {
        if (response.statusCode == successCode && response.data['success']) {
          return supportedCityResponseModelFromJson(jsonEncode(response.data)).data.toList();
        } else {
          return [];
        }
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}
