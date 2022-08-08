import '../../../core/core_importer.dart';

class AddressService {
  static Future<GetAddressModel> addNewAddress({
    String city,
    String street,
    String building,
    String floor,
    String description,
    String supportedCityId,
    double lat,
    double lon,
    String entrance,
  }) async {
    Map addressData = {
      'street': street,
      'building': building,
      'floor': floor,
      'description': description,
      'supported_city_id': supportedCityId,
      'latitude': lat,
      'longitude': lon,
      'entrance': entrance
    };
    try {
      var response =
          await ApiProvider.sendRequest(url: address, method: HttpMethods.post, body: jsonEncode(addressData));

      if (response.statusCode == successCode) {
        return getAddressFromJson(jsonEncode(response.data));
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  static Future<bool> updateAddress({
    String addressId,
    String city,
    String street,
    String building,
    String floor,
    String description,
    String supportedCityId,
    double lat,
    double lon,
    String entrance,
  }) async {
    Map addressData = {
      'city': city,
      'street': street,
      'building': building,
      'floor': floor,
      'description': description,
      'supported_city_id': supportedCityId,
      'latitude': lat,
      'longitude': lon,
      'entrance': entrance
    };
    try {
      var response = await ApiProvider.sendRequest(
          url: address + addressId.toString(), method: HttpMethods.put, body: jsonEncode(addressData));

      if (response.statusCode == successCode) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  static Future<bool> removeUserAddress({String addressId}) async {
    try {
      var response = await ApiProvider.sendRequest(url: address + addressId.toString(), method: HttpMethods.delete);

      if (response != null) if (response.statusCode == successCode) return true;
      return false;
    } catch (e) {
      return false;
    }
  }
}
