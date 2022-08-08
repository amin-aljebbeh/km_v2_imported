import '../../../core/core_importer.dart';

class DeliveryMethodServices {
  static Future<List<DeliveryMethodData>> getUserDeliveryMethod({int addressId}) async {
    List<DeliveryMethodData> deliveryMethodsList = [];
    var response =
        await ApiProvider.sendRequest(url: deliveryMethods + addressId.toString(), method: HttpMethods.get);

    if (response != null) {
      if (response.statusCode == successCode) {
        final methods = deliveryMethodFromJson(jsonEncode(response.data));
        deliveryMethodsList.addAll(methods.data.toList());
        return deliveryMethodsList;
      } else {
        return [];
      }
    }
    return [];
  }
}
