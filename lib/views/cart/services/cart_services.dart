import 'dart:async';
import 'dart:convert';
import 'package:kammun_app/core/api/api_URLs.dart';
import 'package:kammun_app/core/api/api_provider.dart';
import 'package:kammun_app/core/errors/error_types.dart';
import 'package:kammun_app/models/productsCategoriesModel.dart';
import 'package:kammun_app/utils/tools.dart';
import 'package:kammun_app/views/loading/LoadingServices.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartServices {
  static List<ProductData> cartProducts = List<ProductData>();

  static String userNote;
  static String userCopoun;

  static Future getUserCart() async {
    Map<String, String> productsIdCount = new Map<String, String>();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userCart = prefs.getString('userCart');

    if (userCart != null && userCart.length == 1 && userCart == "@") {
      prefs.setString('userCart', "");
    }

    if (userCart != null &&
        userCart.length > 2 &&
        userCart.toString() != "null") {
      cartProducts.clear();

      List<String> productsIds = userCart.split("@")[0].split(";");
      List<String> productsCounts = userCart.split("@")[1].split(";");

      for (int i = 0; i < productsIds.length - 1; i++) {
        productsIdCount[productsIds[i]] = productsCounts[i];
      }

      var response = await ApiProvider.sendRequest(
          url: SYNC_CART,
          method: httpMethods.post,
          // body: jsonEncode({"product_ids": "4571"}));

          body: jsonEncode({
            "product_ids": userCart.split("@")[0].replaceRange(
                userCart.split("@")[0].length - 1,
                userCart.split("@")[0].length,
                ""),
            "warehouse_id": "2",
          }));

      if (response.statusCode == SUCCESS_CODE &&
          response.data['success'] == true) {
        final product = syncCartFromJson(jsonEncode(response.data["data"]));
        for (int i = 0; i < product.length; i++) {
          if (product[i] != null) {
            product[i].productCount = int.parse(productsCounts[i]);
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
    if (LoadingScreenServices.categoryList.length == 0) {
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
      if (!added) {
        CartServices.cartProducts.add(product);
      }
    }
  }
}
