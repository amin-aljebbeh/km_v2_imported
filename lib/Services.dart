import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:kammun_app/views/loading/Loading.dart';
import 'package:kammun_app/views/loading/LoadingServices.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/core_importer.dart';
import 'models/models_importer.dart';

class Services {
  static bool updateOption = false;
  static String prefixUrl = "http://kammun.com/lsapp/public/api/";
  static String googlePlayUrl = "";
  static String appStoreUrl = "";

  static Future<bool> addToFavorites(String productsId) async {
    var response = await ApiProvider.sendRequest(
      url: ADD_TO_FAVORITE + productsId,
      method: httpMethods.put,
    );

    if (response.statusCode == SUCCESS_CODE) {
      return true;
    } else {
      return false;
    }
  }

  static Future<bool> removeFromFavorites(String productsId) async {
    var response = await ApiProvider.sendRequest(
      url: REMOVE_FROM_FAVORITE + productsId,
      method: httpMethods.put,
    );

    if (response.statusCode == SUCCESS_CODE) {
      return true;
    } else {
      return false;
    }
  }

  static Future<bool> addNewAddress(String city, String street, String building, String floor, String description,
      String supportedCityId, double lat, double lon, String entrance) async {
    Map addressData = {
      'street': street,
      'building': building,
      'floor': floor,
      'description': description,
      "supported_city_id": supportedCityId,
      "latitude": lat,
      "longitude": lon,
      "entrance": entrance,
    };
    try {
      var response = await ApiProvider.sendRequest(
          url: USER_ADDRESS, method: httpMethods.post, body: jsonEncode(addressData));

      if (response.statusCode == SUCCESS_CODE) {
        final addNewAddress = addNewAddressFromJson(jsonEncode(response.data));
        LoadingScreenServices.userAddress[0].id = addNewAddress.addressId.id;

        return true;
      } else {
        return false;
      }
    } catch (e) {
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
      String supportedCityId,
      double lat,
      double lon,
      String entrance}) async {
    Map addressData = {
      'city': city,
      'street': street,
      'building': building,
      'floor': floor,
      'description': description,
      "supported_city_id": supportedCityId,
      "latitude": lat,
      "longitude": lon,
      "entrance": entrance
    };
    try {
      var response = await ApiProvider.sendRequest(
          url: USER_ADDRESS + "/$addressId", method: httpMethods.put, body: jsonEncode(addressData));

      if (response.statusCode == SUCCESS_CODE) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  static Future<bool> removeUserAddress(String addressId) async {
    try {
      var response = await ApiProvider.sendRequest(
        url: USER_ADDRESS + "/$addressId",
        method: httpMethods.delete,
      );

      if (response.statusCode == SUCCESS_CODE) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  static Future<List<OrdersOriginalData>> getMyOrders({int pageNumber = 1}) async {
    try {
      var response = await ApiProvider.sendRequest(
        url: GET_USER_ORDER,
        method: httpMethods.get,
        queryParameters: {"page": pageNumber},
      );

      if (response.statusCode == SUCCESS_CODE) {
        LoadingScreenServices.myOrdersList = ordersFromJson(jsonEncode(response.data)).data.data;

        return LoadingScreenServices.myOrdersList;
      } else {
        return LoadingScreenServices.myOrdersList;
      }
    } catch (e) {
      return null;
    }
  }

  static Future<bool> loginUser({String phoneNumber, String signCode, String supportedCityId}) async {
    if (phoneNumber == "5000000001") {
      BASE_URL = APPLE_BASE_URL;
    } else {
      BASE_URL = PRODUCTION_BASE_URL;
    }

    Map loginBody = {
      'phone': phoneNumber,
      'supported_city_id': supportedCityId,
      'phone_code': signCode.toString() == "null" ? "" : signCode,
      'firebase_token': "",
      'platform_type': Platform.isAndroid ? "android" : "ios"
    };

    try {
      var response = await ApiProvider.sendRequest(
          url: LOGIN_URL, method: httpMethods.post, body: jsonEncode(loginBody), responseType: ResponseType.json);
      var theResponse = response.data;

      if (response.statusCode == SUCCESS_CODE && (theResponse["success"].toString() == "true")) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  static Future<bool> verifyCode(String code) async {
    var response = await ApiProvider.sendRequest(url: OTP_VERIFICATION + code, method: httpMethods.get);

    var data = (response.data);

    if (response.statusCode == SUCCESS_CODE && data["success"] == true) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("userToken", data["api_token"]);
      LoadingScreen.userToken = "Bearer " + data["api_token"];
      if (data["api_token"].toString().contains("APPLE_VERIFICATION")) {
        BASE_URL = APPLE_BASE_URL;
      } else {
        BASE_URL = PRODUCTION_BASE_URL;
      }
      return true;
    } else {
      return false;
    }
  }

  static Future<void> userVisitProduct(String productId) async {
    await ApiProvider.sendRequest(url: GET_PRODUCT + productId, method: httpMethods.post);
  }
}
