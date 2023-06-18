import 'package:kammun_app/core/core_importer.dart';

class InventoryServices {
  static Future<bool> updatePriceRateThresholdService(String threshold) async {
    Map thresholdMap = {'threshold': threshold};
    try {
      var response = await ApiProvider.sendRequest(
          url: updatePriceRateThreshold, method: HttpMethods.put, body: jsonEncode(thresholdMap));

      return response.statusCode == successCode;
    } catch (e) {
      return false;
    }
  }
}
