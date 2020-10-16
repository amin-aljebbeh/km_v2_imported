import 'dart:async';
import 'dart:convert';
import 'package:kammun_app/core/api/api_URLs.dart';
import 'package:kammun_app/core/api/api_provider.dart';
import 'package:kammun_app/core/errors/error_types.dart';
import 'package:kammun_app/models/productsCategoriesModel.dart';
import 'package:kammun_app/models/start_model.dart';
import 'package:kammun_app/views/loading/LoadingServices.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartServices {
  static List<ProductsData> cartProducts = List<ProductsData>();

  static Future getUserCart() async {
    print("------------ GET USER CART FROM SHARED PREFRENCES --------------");

    Map<String, String> productsIdCount = new Map<String, String>();

    SharedPreferences prefs = await SharedPreferences.getInstance();

    String userCart = prefs.getString('userCart');
    // print("------- user cart form sharedPref -------");
    // print(userCart);
    // print("------- userCart.split(AT)[0] -------");

    // print(userCart.split("@")[0]);
    // print("------- userCart.split(AT ; )[0] -------");

    // print(userCart.split("@")[0].split(";"));

    // print("-------- quantity and products id ------");
    // print(productsIdCount);

    if (userCart != null) {
      cartProducts.clear();
      List<String> productsIds = userCart.split("@")[0].split(";");
      List<String> productsCounts = userCart.split("@")[1].split(";");

      // print("productsIds Length = ${productsIds.length}");
      // print("productsCounts Length = ${productsCounts.length}");

      for (int i = 0; i < productsIds.length - 1; i++) {
        productsIdCount[productsIds[i]] = productsCounts[i];
      }
      // for (int i = 0; i < userCart.split("@")[0].split(";").length - 1; i++) {
      //   var response = await ApiProvider.sendRequest(
      //     url: GET_PRODUCT + userCart.split("@")[0].split(";")[i],
      //     method: httpMethods.get,
      //   );
      var response = await ApiProvider.sendRequest(
          url: SYNC_CART,
          method: httpMethods.post,
          body: jsonEncode({"product_ids": "4571"}));

      // body: jsonEncode({"product_ids": userCart.split("@")[0]}));

      print(response);
      if (response.statusCode == SUCCESS_CODE &&
          response.data['success'] == true) {
        // print("************* CART ******************");
        // print(userCart);
        // print("The Products ID : " +
        //     userCart.split("@")[0].split(";")[i].toString());
        // print("$BaseUrl/api/product/${userCart.split("@")[0].split(";")[i]}");
        print(response.data);
        final product = syncCartFromJson(jsonEncode(response.data["data"]));
//ProductsData
        for (int i = 0; i < product.length; i++) {
          product[i].productCount = 1;
          CartServices.addProductToCart(product[i]);
        }

        // if (int.parse(product.data.data[0].warehouses[0].pivot.isActive) == 1) {
        //   ProductsData productToAdd = new ProductsData();
        //   productToAdd.id = product.data.data[0].id;
        //   productToAdd.name = product.data.data[0].name;
        //   productToAdd.quantity = product.data.data[0].quantity;
        //   productToAdd.warehouses[0].pivot.price =
        //       product.data.data[0].warehouses[0].pivot.price;
        //   productToAdd.unit = product.data.data[0].unit;
        //   productToAdd.productCount =
        //       int.parse(userCart.split("@")[1].split(";")[i]);
        //   productToAdd.images = product.data.data[0].images.length > 0
        //       ? product.data.data[0].images.cast<ProductImage>()
        //       : new ProductImage();
        // }
      } else {
        print(response.data);
        print("------------ ERROR WHILE GETING USER CART --------------");
      }
    }

    // if (streamController != null) streamController.add(200);
  }

  static addProductToCart(ProductsData product) {
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
