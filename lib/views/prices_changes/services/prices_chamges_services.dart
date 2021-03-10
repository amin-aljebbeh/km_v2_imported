import 'dart:convert';

import 'package:kammun_app/core/api/admin_URLs.dart';
import 'package:kammun_app/core/api/api_provider.dart';
import 'package:kammun_app/core/errors/error_types.dart';
import 'package:kammun_app/utils/tools.dart';
import 'package:kammun_app/views/prices_changes/model/prices_changes_model.dart';

class PricesChangesSerives {
  static Future<PricesChanges> loadData() async {
    var response = await ApiProvider.sendRequest(
      url: GET_PRICES_CHANGES,
      method: httpMethods.get,
    );

    if (response.statusCode == SUCCESS_CODE && response.data["success"]) {
      Tools.logToConsole(response.data["count"]);
      return pricesChangesFromJson(jsonEncode(response.data));
    } else {
      Tools.logToConsole("------------ ERROR CANCEL ORDER --------------");
      return null;
    }
  }
}
