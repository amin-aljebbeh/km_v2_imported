import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:kammun_app/views/deliver_to/deliver_to_view.dart';
import 'package:kammun_app/views/deliver_to/delivery_method.dart';
import 'package:kammun_app/views/loading/LoadingServices.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/api/api_URLs.dart';
import 'core/api/api_provider.dart';
import 'core/errors/error_types.dart';
import 'models/addAddressResponse.dart';
import 'models/start_model.dart';
import 'views/cart/services/cart_services.dart';

class Services {
  static bool updateOption = false;
  //static String imagePrefixUrl = "";
  static String prefixUrl = "http://kammun.com/lsapp/public/api/";
  static String googlePlayUrl = "";
  static String appStoreUrl = "";

  static int delivery_Price = 50;

  static Future<bool> addToFavorites(String productsId) async {
    // print("------------------ ADD TO FAVORITES  --------------------");

    var response = await ApiProvider.sendRequest(
      url: ADD_TO_FAVORITE + productsId,
      method: httpMethods.put,
    );

    if (response.statusCode == SUCCESS_CODE) {
      return true;
    } else {
      print("------------ ERROR ADD TO FAVORITES --------------");
      return false;
    }
  }

  static Future<bool> removeFromFavorites(String productsId) async {
    // print("------------------ REMOVE FROM FAVORITES  --------------------");

    var response = await ApiProvider.sendRequest(
      url: REMOVE_FROM_FAVORITE + productsId,
      method: httpMethods.put,
    );

    if (response.statusCode == SUCCESS_CODE) {
      return true;
    } else {
      print("------------ ERROR REMOVE FROM FAVORITES --------------");
      return false;
    }
  }

  static Future<bool> addNewAddress(String city, String street, String building,
      String floor, String description, String supportedCityId) async {
    //  print("------------------ ADD NEW ADDRESS  --------------------");

    Map addressData = {
      // 'city': city,
      'street': street,
      'building': building,
      'floor': floor,
      'description': description,
      "supported_city_id": supportedCityId
    };
    try {
      var response = await ApiProvider.sendRequest(
          url: USER_ADDRESS,
          method: httpMethods.post,
          body: jsonEncode(addressData));

      if (response.statusCode == SUCCESS_CODE) {
        final addNewAddress = addNewAddreFromJson(jsonEncode(response.data));
        LoadingScreenServices.userAddress[0].id = addNewAddress.addressId.id;

        return true;
      } else {
        print(response.data);
        print("------------ ERROR ADD NEW ADDRESS --------------");
        return false;
      }
    } catch (e) {
      print("----- adding address Error -----");
      print(e.toString());
      return false;
    }
  }

  static Future<bool> updateAddress(
      {String addressId,
      String city,
      String street,
      String building,
      String floor,
      String description,
      String supportedCityId}) async {
    //  print("------------------ ADD NEW ADDRESS  --------------------");
    print("------- ID: $addressId");
    Map addressData = {
      'city': city,
      'street': street,
      'building': building,
      'floor': floor,
      'description': description,
      "supported_city_id": supportedCityId
    };
    try {
      var response = await ApiProvider.sendRequest(
          url: USER_ADDRESS + "/$addressId",
          method: httpMethods.put,
          body: jsonEncode(addressData));

      if (response.statusCode == SUCCESS_CODE) {
        // final addNewAddress = addNewAddreFromJson(jsonEncode(response.data));
        // userAddress[0].id = addNewAddress.addressId.id;
        print(response.data);
        return true;
      } else {
        print(response.data);
        print("------------ ERROR UPDATE ADDRESS --------------");
        return false;
      }
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  static Future<bool> removeUserAddress(String addressId) async {
    // print("------------------ REMOVE ADDRESS  --------------------");
    try {
      var response = await ApiProvider.sendRequest(
        url: USER_ADDRESS + "/$addressId",
        method: httpMethods.delete,
      );

      if (response.statusCode == SUCCESS_CODE) {
        return true;
      } else {
        print("------------ ERROR REMOVE ADDRESS --------------");
        return false;
      }
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  static Future<List<OrdersOriginalData>> getMyOrders(
      {int pageNumber = 1}) async {
    print("------------------ Get My Orders  --------------------");
    try {
      var response = await ApiProvider.sendRequest(
        url: GET_USER_ORDER,
        method: httpMethods.get,
        queryParameters: {"page": pageNumber},
      );
      print("------- orders data -------");

      if (response.statusCode == SUCCESS_CODE) {
        LoadingScreenServices.myOrdersList =
            ordersFromJson(jsonEncode(response.data)).data.data;

        LoadingScreenServices.myOrdersList.sort((a, b) {
          if (a.id < b.id)
            return 1;
          else if (a.id > b.id)
            return -1;
          else
            return 0;
        });

        return LoadingScreenServices.myOrdersList;
      } else {
        print("------------ ERROR GET USER ORDER --------------");
        return LoadingScreenServices.myOrdersList;
      }
    } catch (e) {
      print("------------ ERROR GET USER ORDER --------------");
      print(e.toString());
      return null;
    }
  }

  // static Future<bool> cancelOrder(String orderId) async {
  //   print("@@@@@@@@@@@@@@@@@@@@@@@@");
  //   print("$BaseUrl/api/order/$orderId");
  //   print(LoadingScreen.user_token.length > 10
  //       ? LoadingScreen.user_token
  //       : "null");
  //   final response = await http.put(
  //     "$BaseUrl/api/order/$orderId",
  //     headers: {
  //       'Content-Type': 'application/x-www-form-urlencoded',
  //       'Authorization': LoadingScreen.user_token.length > 10
  //           ? LoadingScreen.user_token
  //           : "",
  //     },
  //     body: "order_status_id=5",
  //   );
  //   if (response.statusCode == 200) {
  //     print(response.body);
  //     return true;
  //   } else {
  //     print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
  //     print(response.body);
  //     return false;
  //   }
  // }

  static Future<bool> loginUser(
      {String phoneNumber, String signCode, String supportedCityId}) async {
    //print("------------------ LOGIN USER   --------------------");

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String firebaseToken = prefs.getString('firebase_token');
    print("--------------------");
    print(phoneNumber);
    print(supportedCityId);
    print(signCode.toString() == "null" ? "" : signCode);
    print(firebaseToken.toString().length < 20 ? "" : firebaseToken);

    Map loginBody = {
      'phone': phoneNumber,
      'supported_city_id': supportedCityId,
      'phone_code': signCode.toString() == "null" ? "" : signCode,
      'firebase_token':
          firebaseToken.toString().length < 20 ? "" : firebaseToken,
    };

    print(jsonEncode(loginBody));
    try {
      var response = await ApiProvider.sendRequest(
          url: LOGIN_URL,
          method: httpMethods.post,
          body: jsonEncode(loginBody),
          reponseType: ResponseType.json);
      var theResponse = response.data;

      print("-------- Login Response -----------");
      print(theResponse);
      if (response.statusCode == SUCCESS_CODE &&
          theResponse["success"].toString() == "false") {
        print(theResponse["success"].toString());

        return true;
      } else {
        print("------------ ERROR LOGIN USER --------------");

        return false;
      }
    } catch (e) {
      print(e.toString());
    }
  }

  // static Future<bool> verifyCode(String code) async {
  //   //  print("------------------ Verify Code  --------------------");

  //   final response = await http.post(
  //     "$BaseUrl/api/verification_code/verify_account/$code",
  //   );

  //   var data = json.decode(response.body);
  //   print("--------------------------------- API TOKEN ---------------------");
  //   print(response.statusCode);
  //   print(data["success"]);

  //   if (response.statusCode == 200 && data["success"].toString() == "true") {
  //     print(data["api_token"]);
  //     SharedPreferences prefs = await SharedPreferences.getInstance();
  //     prefs.setString("userToken", data["api_token"]);

  //     return true;
  //   } else {
  //     print(response.body);
  //     return false;
  //   }
  // }

  static Future<bool> verifyCode(String code) async {
    //print("------------------ LOGIN USER   --------------------");

    var response = await ApiProvider.sendRequest(
        url: OTP_VERIFICATION + code, method: httpMethods.get);

    var data = (response.data);

    if (response.statusCode == SUCCESS_CODE && data["success"] == true) {
      print(data["success"].toString());
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("userToken", data["api_token"]);

      return true;
    } else {
      print("------------ ERROR OTP VERIFICATION --------------");
      return false;
    }
  }

  // static Future<void> userVisitProduct(String productId) async {
  //   // print("------------- User  Visit Porudct $productId  ------------");
  //   final response = await http.get("$BaseUrl/api/product/$productId");

  //   print(response.body);
  // }

  static Future<void> userVisitProduct(String productId) async {
    //print("------------------ LOGIN USER   --------------------");

    await ApiProvider.sendRequest(
        url: GET_PRODUCT + productId, method: httpMethods.post);
  }
}
