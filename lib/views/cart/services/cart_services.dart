import 'dart:async';
import 'dart:convert';

import 'package:kammun_app/core/api/api_URLs.dart';
import 'package:kammun_app/core/api/api_provider.dart';
import 'package:kammun_app/core/errors/error_types.dart';
import 'package:kammun_app/models/productsCategoriesModel.dart';
import 'package:kammun_app/models/searchResponseModel.dart';
import 'package:kammun_app/models/start_model.dart';
import 'package:kammun_app/models/userCart.dart';
import 'package:kammun_app/views/loading/LoadingServices.dart';
import 'package:kammun_app/views/orders/services/order_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartServices {
  static List<SearchProductsList> cartProducts = List<SearchProductsList>();

  static Future getUserCart() async {
    print("------------ GET USER CART FROM SHARED PREFRENCES --------------");

    SharedPreferences prefs = await SharedPreferences.getInstance();

    String userCart = prefs.getString('userCart');

    if (userCart != null) {
      cartProducts.clear();

      for (int i = 0; i < userCart.split("@")[0].split(";").length - 1; i++) {
        var response = await ApiProvider.sendRequest(
          url: GET_PRODUCT + userCart.split("@")[0].split(";")[i],
          method: httpMethods.get,
        );

        if (response.statusCode == SUCCESS_CODE &&
            response.data['success'] == true) {
          // print("************* CART ******************");
          // print(userCart);
          // print("The Products ID : " +
          //     userCart.split("@")[0].split(";")[i].toString());
          // print("$BaseUrl/api/product/${userCart.split("@")[0].split(";")[i]}");
          print(response.data);
          final product = categoryProductFromJson(jsonEncode(response.data));

          if (int.parse(product.data.data[0].warehouses[0].pivot.isActive) ==
              1) {
            SearchProductsList productToAdd = new SearchProductsList();
            productToAdd.id = product.data.data[0].id;
            productToAdd.name = product.data.data[0].name;
            productToAdd.quantity = int.parse(product.data.data[0].quantity);
            productToAdd.price = int.parse(
                product.data.data[0].warehouses[0].pivot.price.split(".")[0]);
            productToAdd.unit = product.data.data[0].unit;
            productToAdd.productCount =
                int.parse(userCart.split("@")[1].split(";")[i]);
            productToAdd.images = product.data.data[0].images.length > 0
                ? product.data.data[0].images.cast<ProductImage>()
                : new ProductImage();
            CartServices.addProductToCart(productToAdd);
          }
        } else {
          print(response.data);
          print("------------ ERROR WHILE GETING USER CART --------------");
        }
      }
    }
    // if (streamController != null) streamController.add(200);
  }

  static addProductToCart(SearchProductsList product) {
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
