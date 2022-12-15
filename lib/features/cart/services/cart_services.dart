import 'package:kammun_app/core/core_importer.dart';

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
    if (LoadingScreenServices.categoryList.isEmpty) {
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
}
