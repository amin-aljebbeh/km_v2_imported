import 'dart:convert';

import 'package:kammun_app/core/core_importer.dart';
import 'package:kammun_app/utils/utils_importer.dart';
import 'package:kammun_app/views/prices_changes/model/prices_changes_model.dart';

class PricesChangesServices {
  static Future<PricesChanges> loadData() async {
    var response = await ApiProvider.sendRequest(
      url: getPriceChanged,
      method: HttpMethods.get,
    );

    if (response.statusCode == successCode && response.data["success"]) {
      return pricesChangesFromJson(jsonEncode(response.data));
    } else {
      Tools.logToConsole("------------ ERROR CANCEL ORDER --------------");
      return null;
    }
  }

  static Future<bool> deleteImage({int imageId}) async {
    try {
      var response = await ApiProvider.sendRequest(
        url: productImage + imageId.toString(),
        method: HttpMethods.delete,
      );
      if (response.statusCode == successCode && response.data["success"]) {
        return true;
      } else {
        Tools.logToConsole("------------ IMAGE IS DELETED ALREADY --------------");
        return false;
      }
    } catch (e) {
      return false;
    }
  }
}
