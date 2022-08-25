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
        Services.resultFlushBar(context: context, result: response.statusCode == successCode);
        if (response.statusCode == successCode) return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> addImageToOrderService({String orderId, File image}) async {
    try {
      var headers = {'Authorization': LoadingScreen.userToken.length > 10 ? LoadingScreen.userToken : ""};
      var request = http.MultipartRequest('POST', Uri.parse(baseUrl + '/api/' + addImageToOrder));
      request.fields.addAll({'order_id': orderId});
      request.files.add(await http.MultipartFile.fromPath('image', image.path));
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) return true;
      return false;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> deleteImageFromOrderService({String imageId}) async {
    try {
      var response = await ApiProvider.sendRequest(url: deleteImageFromOrder + '/$imageId', method: HttpMethods.delete);

      if (response.statusCode == successCode) return true;
      return false;
    } catch (e) {
      return false;
    }
  }
}
