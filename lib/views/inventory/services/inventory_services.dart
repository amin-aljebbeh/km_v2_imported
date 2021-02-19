import 'package:kammun_app/core/api/admin_URLs.dart';
import 'package:kammun_app/core/api/api_provider.dart';
import 'package:kammun_app/core/errors/error_types.dart';
import 'package:kammun_app/utils/tools.dart';

class InventoryServices {
  static Future<bool> getInventoryProducts() async {
    var response = await ApiProvider.sendRequest(
      url: GET_INVENTORY_PRODUCTS,
      method: httpMethods.get,
    );

    if (response.statusCode == SUCCESS_CODE && response.data["success"]) {
      return true;
    } else {
      Tools.logToConsole("------------ ERROR CANCEL ORDER --------------");
      return false;
    }
  }
}
