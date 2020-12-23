import 'dart:convert';

import 'package:kammun_app/core/api/api_URLs.dart';
import 'package:kammun_app/core/api/api_provider.dart';
import 'package:kammun_app/core/errors/error_types.dart';
import 'package:kammun_app/models/delivery_method_model.dart';

class DeliveryMethodServices {
  static List<DeliveryMethodData> deliveryMethodsList =
      new List<DeliveryMethodData>();

  static Future getUserDeliveryMethod({String addressId}) async {
    var response = await ApiProvider.sendRequest(
      url: DELIVERY_METHODS + addressId,
      method: httpMethods.get,
    );

    print(response);
    if (response.statusCode == SUCCESS_CODE) {
      final product = deliveryMethodFromJson(jsonEncode(response.data));
      deliveryMethodsList.clear();

      for (int i = 0; i < product.data.length; i++) {
        if (product.data[i].pivot.isActive == "1") {
          deliveryMethodsList.add(product.data[i]);
        }
      }

      return true;
    } else {
      print(response.data);
      //   if (streamController != null) streamController.add(200);
      print("------------ ERROR WHILE GETING USER CART --------------");

      return false;
    }
  }
}
