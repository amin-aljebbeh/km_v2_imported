import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kammun_app/utils/tools.dart';
import 'package:kammun_app/views/loading/Loading.dart';
import 'package:kammun_app/views/loading/LoadingServices.dart';
import 'package:kammun_app/views/login/models/login_admin_model.dart';
import 'package:kammun_app/views/restart/kammunapp_restart.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/api/api_URLs.dart';
import 'core/api/api_provider.dart';
import 'core/errors/error_types.dart';
import 'models/addAddressResponse.dart';
import 'models/start_model.dart';
import 'utils/Styles.dart';

class Services {
  static List<Role> roles = [];
  static bool updateOption = false;
  //static String imagePrefixUrl = "";
  static String prefixUrl = "http://kammun.com/lsapp/public/api/";
  static String googlePlayUrl = "";
  static String appStoreUrl = "";

  static int deliveryPrice = 50;

  static Future<bool> addToFavorites(String productsId) async {
    // Tools.logToConsole("------------------ ADD TO FAVORITES  --------------------");

    var response = await ApiProvider.sendRequest(
      url: ADD_TO_FAVORITE + productsId,
      method: httpMethods.put,
    );

    if (response.statusCode == SUCCESS_CODE) {
      return true;
    } else {
      Tools.logToConsole("------------ ERROR ADD TO FAVORITES --------------");
      return false;
    }
  }

  static Future<bool> removeFromFavorites(String productsId) async {
    // Tools.logToConsole("------------------ REMOVE FROM FAVORITES  --------------------");

    var response = await ApiProvider.sendRequest(
      url: REMOVE_FROM_FAVORITE + productsId,
      method: httpMethods.put,
    );

    if (response.statusCode == SUCCESS_CODE) {
      return true;
    } else {
      Tools.logToConsole(
          "------------ ERROR REMOVE FROM FAVORITES --------------");
      return false;
    }
  }

  static Future<bool> addNewAddress(
      String city,
      String street,
      String building,
      String floor,
      String description,
      String supportedCityId,
      double lat,
      double lon,
      String entrance) async {
    //  Tools.logToConsole("------------------ ADD NEW ADDRESS  --------------------");

    Map addressData = {
      // 'city': city,
      'street': street,
      'building': building,
      'floor': floor,
      'description': description,
      "supported_city_id": supportedCityId,
      "latitude": lat,
      "longitude": lon, "entrance": entrance,
    };
    try {
      var response = await ApiProvider.sendRequest(
          url: USER_ADDRESS,
          method: httpMethods.post,
          body: jsonEncode(addressData));

      if (response.statusCode == SUCCESS_CODE) {
        final addNewAddress = addNewAddressFromJson(jsonEncode(response.data));
        LoadingScreenServices.userAddress[0].id = addNewAddress.addressId.id;

        return true;
      } else {
        Tools.logToConsole(response.data);
        Tools.logToConsole("------------ ERROR ADD NEW ADDRESS --------------");
        return false;
      }
    } catch (e) {
      Tools.logToConsole("----- adding address Error -----");
      Tools.logToConsole(e.toString());
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
    //  Tools.logToConsole("------------------ ADD NEW ADDRESS  --------------------");
    Tools.logToConsole("------- ID: $addressId");
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
          url: USER_ADDRESS + "/$addressId",
          method: httpMethods.put,
          body: jsonEncode(addressData));

      if (response.statusCode == SUCCESS_CODE) {
        // final addNewAddress = addNewAddreFromJson(jsonEncode(response.data));
        // userAddress[0].id = addNewAddress.addressId.id;
        Tools.logToConsole(response.data);
        return true;
      } else {
        Tools.logToConsole(response.data);
        Tools.logToConsole("------------ ERROR UPDATE ADDRESS --------------");
        return false;
      }
    } catch (e) {
      Tools.logToConsole(e.toString());
      return false;
    }
  }

  static Future<bool> removeUserAddress(String addressId) async {
    // Tools.logToConsole("------------------ REMOVE ADDRESS  --------------------");
    try {
      var response = await ApiProvider.sendRequest(
        url: USER_ADDRESS + "/$addressId",
        method: httpMethods.delete,
      );

      if (response.statusCode == SUCCESS_CODE) {
        return true;
      } else {
        Tools.logToConsole("------------ ERROR REMOVE ADDRESS --------------");
        return false;
      }
    } catch (e) {
      Tools.logToConsole(e.toString());
      return false;
    }
  }

  static Future<List<OrdersOriginalData>> getMyOrders(
      {int pageNumber = 1}) async {
    Tools.logToConsole(
        "------------------ Get My Orders  --------------------");

    Tools.logToConsole("------------------ $pageNumber --------------------");
    try {
      var response = await ApiProvider.sendRequest(
        url: ORDER,
        method: httpMethods.get,
        queryParameters: {"page": pageNumber},
      );
      Tools.logToConsole("------- orders data -------");

      if (response.statusCode == SUCCESS_CODE) {
        LoadingScreenServices.allOrdersList =
            ordersFromJson(jsonEncode(response.data)).data.data;

        return LoadingScreenServices.allOrdersList;
      } else {
        return LoadingScreenServices.allOrdersList;
      }
    } catch (e) {
      Tools.logToConsole("------------ ERROR GET USER ORDER --------------");
      Tools.logToConsole(e.toString());
      return null;
    }
  }

  static Future<bool> loginUser(
      {String phoneNumber, String signCode, String supportedCityId}) async {
    if (phoneNumber == "5000000001") {
      BaseUrl = APPLE_BASEURL;
    } else {
      BaseUrl = PRODUCTION_BASE_URL;
    }

    Map loginBody = {
      'phone': phoneNumber,
      'supported_city_id': supportedCityId,
      'phone_code': signCode.toString() == "null" ? "" : signCode,
      'firebase_token': "",
      'platform_type': Platform.isAndroid ? "android" : "ios"
    };

    Tools.logToConsole(jsonEncode(loginBody));
    try {
      var response = await ApiProvider.sendRequest(
          url: LOGIN_URL,
          method: httpMethods.post,
          body: jsonEncode(loginBody),
          responseType: ResponseType.json);
      var theResponse = response.data;

      Tools.logToConsole("-------- Login Response -----------");
      Tools.logToConsole(theResponse);
      if (response.statusCode == SUCCESS_CODE &&
          (theResponse["success"].toString() == "true")) {
        Tools.logToConsole(theResponse["success"].toString());

        return true;
      } else {
        Tools.logToConsole("------------ ERROR LOGIN USER --------------");

        return false;
      }
    } catch (e) {
      Tools.logToConsole(e.toString());
      return false;
    }
  }

  static Future<bool> verifyCode(String code) async {
    //Tools.logToConsole("------------------ LOGIN USER   --------------------");

    var response = await ApiProvider.sendRequest(
        url: OTP_VERIFICATION + code, method: httpMethods.get);

    var data = (response.data);

    if (response.statusCode == SUCCESS_CODE && data["success"] == true) {
      Tools.logToConsole("The Token from VerifyCode is");
      Tools.logToConsole(data["success"].toString());
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("userToken", data["api_token"]);
      LoadingScreen.userToken = "Bearer " + data["api_token"];
      if (data["api_token"] == "APPLE_VERIFICATION") {
        BaseUrl = APPLE_BASEURL;
      } else {
        BaseUrl = PRODUCTION_BASE_URL;
      }
      return true;
    } else {
      Tools.logToConsole("------------ ERROR OTP VERIFICATION --------------");
      return false;
    }
  }

  static Future<void> logOutAdmin(BuildContext context) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.clear();
    KammunRestart.restartApp(context);
  }

  static List<DropdownMenuItem<int>> dropdownIntList(List<String> inputList) {
    List<DropdownMenuItem<int>> list = List();
    for (int i = 0; i < inputList.length; i++) {
      list.add(
        DropdownMenuItem<int>(
          child: Text(
            inputList[i],
            style: dropdownItemStyle,
          ),
          value: i + 1,
        ),
      );
    }
    return list;
  }

  static List<DropdownMenuItem<int>> dropdownStringList(
      List<String> inputList) {
    List<DropdownMenuItem<int>> list = List();
    for (int i = 0; i < inputList.length; i++) {
      list.add(
        DropdownMenuItem<int>(
          child: Text(
            inputList[i],
            style: dropdownItemStyle,
          ),
          value: i,
        ),
      );
    }
    return list;
  }

  static List<DropdownMenuItem<int>> searchableDropdownStringList(
      List<String> inputList) {
    List<DropdownMenuItem<int>> list = List();
    for (int i = 0; i < inputList.length; i++) {
      list.add(
        DropdownMenuItem<int>(
          child: Text(
            inputList[i],
            style: dropdownItemStyle,
          ),
          value: i,
        ),
      );
    }
    return list;
  }
}
