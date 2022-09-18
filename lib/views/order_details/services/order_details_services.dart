import 'package:http/http.dart' as http;
import 'package:kammun_app/core/core_importer.dart';

class OrderDetailsServices {
  static Future<bool> updateOrder(
      {String orderId, String updateKey, String updateValue, String productId, @required BuildContext context}) async {
    try {
      Map updateOrderBody = {updateKey: updateValue, 'product_id': productId};
      var response = await ApiProvider.sendRequest(
          url: updateOrderProducts + orderId, method: HttpMethods.put, body: jsonEncode(updateOrderBody));
      if (response != null) {
        if (response.statusCode == successCode) {
          snackBar(success: true, message: 'نجحت عملية تعديل الطلب', context: context);
        } else {
          snackBar(success: false, message: 'فشلت عملية تعديل الطلب يرجى المحاولة مجدداً', context: context);
        }
        return response.statusCode == successCode;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> addImageToOrderService({String orderId, File image}) async {
    try {
      var headers = {'Authorization': LoadingScreen.userToken.length > 10 ? LoadingScreen.userToken : ""};
      var request = http.MultipartRequest('POST', Uri.parse(baseUrl + '/api/' + orderImage));
      request.fields.addAll({'order_id': orderId});
      request.files.add(await http.MultipartFile.fromPath('image', image.path));
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();
      return response.statusCode == successCode;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> deleteImageFromOrderService({String imageId}) async {
    try {
      var response = await ApiProvider.sendRequest(url: orderImage + imageId, method: HttpMethods.delete);
      return response.statusCode == successCode;
    } catch (e) {
      return false;
    }
  }
}
