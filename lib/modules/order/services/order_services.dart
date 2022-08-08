import 'package:dio/dio.dart';

import '../../../core/core_importer.dart';
import '../models/get_order_model.dart';
import '../models/submit_order_model.dart';

class OrderServices {
  static Future<OrderResponse> submitNewOrder({SubmitOrderModel submitOrderModel}) async {
    Response response;
    try {
      response =
          await ApiProvider.sendRequest(url: order, method: HttpMethods.post, body: jsonEncode(submitOrderModel));

      if (response.data['reason'].toString().contains('discontinued')) {
        return OrderResponse(success: false, reason: 'discontinued');
      } else {
        var parsedJson = orderResponseFromJson(jsonEncode(response.data));

        return parsedJson;
      }
    } catch (e) {
      return null;
    }
  }

  static Future<GetOrderResponse> getOrder({String orderId}) async {
    Response response;
    try {
      response = await ApiProvider.sendRequest(url: order + orderId, method: HttpMethods.get);

      if (response != null) {
        if (response.statusCode == successCode) {
          return getOrderResponseFromJson(jsonEncode(response.data));
        }
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  static List<InvoiceProductModel> convertCartProductToInvoiceProduct({List<ProductData> cartProducts}) {
    List<InvoiceProductModel> products = [];
    for (var product in cartProducts) {
      products.add(InvoiceProductModel(
          productId: product.id, quantity: product.productCount, price: int.parse(product.price.split('.')[0])));
    }
    return products;
  }

  static List<ProductData> convertOrderProductToProductData({List<OrderProducts> orderProducts}) {
    List<ProductData> products = [];
    for (var product in orderProducts) {
      products.add(ProductData(
          id: product.id,
          productCount: int.parse(product.pivot.quantity),
          unit: product.unit,
          price: product.pivot.purchasePrice,
          images: product.images,
          name: product.name,
          quantity: product.quantity));
    }
    return products;
  }
}
