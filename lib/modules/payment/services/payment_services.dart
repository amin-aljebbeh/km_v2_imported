import '../../../core/core_importer.dart';
import '../models/payment_method_model.dart';

class PaymentServices {
  static Future<List<PaymentMethodModel>> getPaymentMethods() async {
    try {
      var response = await ApiProvider.sendRequest(url: paymentMethod, method: HttpMethods.get);

      if (response.statusCode == successCode) {
        final methods = paymentMethodResponseFromJson(jsonEncode(response.data));

        return methods.data;
      } else {
        return [];
      }
    } catch (e) {
      return null;
    }
  }

  static String getEPayRequest() {
    List<PaymentInfo> paymentMethodInfo = StoreProvider.of<AppState>(navigatorKey.currentContext)
        .state
        .orderState
        .orderResponse
        .ePaymentInfo
        .paymentMethodInfo;
    String result = '';
    for (int i = 0; i < paymentMethodInfo.length; i++) {
      if (paymentMethodInfo[i].key != 'dateTimeBuyer') {
        result += (paymentMethodInfo[i].key + '=' + paymentMethodInfo[i].value);
      } else {
        result += (paymentMethodInfo[i].key +
            '=' +
            DateTime.now().toString().replaceAll('-', '').replaceAll(' ', '').replaceAll(':', '').split('.')[0]);
      }
      if (i < paymentMethodInfo.length) {
        result += '&';
      }
    }
    return result;
  }
}
