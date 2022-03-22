import 'dart:convert';

import 'package:kammun_app/core/core_importer.dart';
import 'package:kammun_app/models/delivery_method_model.dart';

class DeliveryMethodServices {
  static List<DeliveryMethodData> deliveryMethodsList = [];

  static Future getUserDeliveryMethod({String addressId}) async {
    var response = await ApiProvider.sendRequest(
      url: deliveryMethods + addressId,
      method: HttpMethods.get,
    );

    if (response.statusCode == successCode) {
      final product = deliveryMethodFromJson(jsonEncode(response.data));
      deliveryMethodsList.clear();

      for (int i = 0; i < product.data.length; i++) {
        if (product.data[i].pivot.isActive == "1") {
          deliveryMethodsList.add(product.data[i]);
        }
      }

      return true;
    } else {
      return false;
    }
  }
}
