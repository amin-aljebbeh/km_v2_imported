import 'package:kammun_app/core/core_importer.dart';

import '../../orders/orders_services.dart';
import '../model/submit_order_model.dart';

class CartServices {
  static List<ProductData> cartProducts = [];

  static String userNote;

  static Future getUserCart() async {
    Map<String, String> productsIdCount = <String, String>{};

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userCart = prefs.getString('userCart');
    if (userCart != null && userCart.length > 2 && userCart.toString() != "null") {
      cartProducts.clear();
      List<String> productsIds = userCart.split("@")[0].split(";");
      List<String> productsCounts = userCart.split("@")[1].split(";");

      for (int i = 0; i < productsIds.length - 1; i++) {
        productsIdCount[productsIds[i]] = productsCounts[i];
      }

      var response = await ApiProvider.sendRequest(
          url: syncCart,
          method: HttpMethods.post,
          body: jsonEncode({
            "product_ids": userCart
                .split("@")[0]
                .replaceRange(userCart.split("@")[0].length - 1, userCart.split("@")[0].length, "")
          }));

      if (response.statusCode == successCode && response.data['success'] == true) {
        final product = syncCartFromJson(jsonEncode(response.data["data"]));
        for (int i = 0; i < product.length; i++) {
          if (product[i] != null) {
            product[i].productCount = int.parse(productsCounts[i]);
            product[i].pivot = OrderProductPivot(increaseValue: product[i].increasePercentage);

            CartServices.addProductToCart(product[i]);
          }
        }

        return true;
      } else {
        return false;
      }
    } else {
      return true;
    }
  }

  static addProductToCart(ProductData product) {
    bool added = false;
    if (StaticVariables.categoryList.isEmpty) {
      CartServices.cartProducts.add(product);
      added = true;
    }
    if (!added) {
      for (int i = 0; i < CartServices.cartProducts.length; i++) {
        if (CartServices.cartProducts[i].id == product.id) {
          CartServices.cartProducts[i].productCount += product.productCount;
          added = true;
        }
      }
      if (!added) CartServices.cartProducts.add(product);
    }
  }

  static Future<OrderResponse> updateOrder({SubmitOrderModel submitOrderModel}) async {
    try {
      Map orderMap = submitOrderModel.toJson();
      String orderId;

      orderId = OrdersServices.orderUnderUpdateId;

      var response =
          await ApiProvider.sendRequest(url: orderApi + orderId, method: HttpMethods.put, body: jsonEncode(orderMap));

      if (response != null) {
        if (response.data['reason'].toString().contains('discontinued')) {
          return OrderResponse(success: false, reason: 'discontinued');
        }
        return orderResponseFromJson(jsonEncode(response.data));
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  static Future<bool> updateOrderProduct(
      {String orderId, String updateKey, String updateValue, String productId, @required BuildContext context}) async {
    try {
      Map updateOrderBody = {updateKey: updateValue, 'product_id': productId};
      var response = await ApiProvider.sendRequest(
          url: updateOrderProductsApi + orderId, method: HttpMethods.put, body: jsonEncode(updateOrderBody));
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
}
