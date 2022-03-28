import 'dart:convert';

import 'package:kammun_app/core/core_importer.dart';
import 'package:kammun_app/utils/utils_importer.dart';
import 'package:kammun_app/views/prices_changes/model/prices_changes_model.dart';

class PricesChangesServices {
  static Future<PricesChanges> loadData() async {
    var response = await ApiProvider.sendRequest(
      url: GET_PRICES_CHANGES,
      method: HttpMethods.get,
    );

    if (response.statusCode == SUCCESS_CODE && response.data["success"]) {
      return pricesChangesFromJson(jsonEncode(response.data));
    } else {
      Tools.logToConsole("------------ ERROR CANCEL ORDER --------------");
      return null;
    }
  }

  static Future<bool> deleteImage({int imageId}) async {
    try {
      var response = await ApiProvider.sendRequest(
        url: PRODUCT_IMAGE + imageId.toString(),
        method: HttpMethods.delete,
      );
      if (response.statusCode == SUCCESS_CODE && response.data["success"]) {
        return true;
      } else {
        Tools.logToConsole("------------ IMAGE IS DELETED ALREADY --------------");
        return false;
      }
    } catch (e) {
      print(e.toString());
      return false;
    }
  }
}
