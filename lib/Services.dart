import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import 'core/core_importer.dart';
import 'models/models_importer.dart';
import 'utils/utils_importer.dart';
import 'views/loading/Loading.dart';
import 'views/loading/LoadingServices.dart';
import 'views/restart/kammunapp_restart.dart';

class Services {
  static List<Role> roles = [];
  static ShopperModel shopper;
  static bool updateOption = false;

  static String prefixUrl = "http://kammun.com/lsapp/public/api/";
  static String googlePlayUrl = "";
  static String appStoreUrl = "";

  static int deliveryPrice = 50;

  static Future<bool> addToFavorites(String productsId) async {
    try {
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
    } catch (e) {
      return null;
    }
  }

  static Future<bool> removeFromFavorites(String productsId) async {
    try {
      var response = await ApiProvider.sendRequest(
        url: REMOVE_FROM_FAVORITE + productsId,
        method: httpMethods.put,
      );

      if (response.statusCode == SUCCESS_CODE) {
        return true;
      } else {
        Tools.logToConsole("------------ ERROR REMOVE FROM FAVORITES --------------");
        return false;
      }
    } catch (e) {
      return null;
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
        Tools.logToConsole("------------ ERROR REMOVE ADDRESS --------------");
        return false;
      }
    } catch (e) {
      Tools.logToConsole(e.toString());
      return false;
    }
  }

  static Future<List<OrdersOriginalData>> getAllOrders({int pageNumber = 1}) async {
    try {
      var response = await ApiProvider.sendRequest(
        url: API + ORDER,
        method: httpMethods.get,
        queryParameters: {"page": pageNumber},
      );

      if (response.statusCode == SUCCESS_CODE) {
        LoadingScreenServices.allOrdersList = ordersFromJson(jsonEncode(response.data)).data.data;

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
        Tools.logToConsole("------------ ERROR LOGIN USER --------------");

        return false;
      }
    } catch (e) {
      Tools.logToConsole(e.toString());
      return false;
    }
  }

  static Future<bool> verifyCode(String code) async {
    try {
      var response = await ApiProvider.sendRequest(url: OTP_VERIFICATION + code, method: httpMethods.get);

      var data = (response.data);

      if (response.statusCode == SUCCESS_CODE && data["success"] == true) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString("userToken", data["api_token"]);
        LoadingScreen.userToken = "Bearer " + data["api_token"];
        if (data["api_token"] == "APPLE_VERIFICATION") {
          BASE_URL = APPLE_BASE_URL;
        } else {
          BASE_URL = PRODUCTION_BASE_URL;
        }
        return true;
      } else {
        Tools.logToConsole("------------ ERROR OTP VERIFICATION --------------");
        return false;
      }
    } catch (e) {
      return null;
    }
  }

  static Future<void> logOutAdmin(BuildContext context) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.clear();
    KammunRestart.restartApp(context);
  }

  static Future<List<ShopperModel>> getShoppers() async {
    try {
      var response = await ApiProvider.sendRequest(
        url: GET_SHOPPER,
        method: httpMethods.get,
      );

      if (response.statusCode == SUCCESS_CODE) {
        LoadingScreenServices.allShoppers = shoppersFromJson(jsonEncode(response.data)).data;
        return LoadingScreenServices.allShoppers;
      } else {
        return LoadingScreenServices.allShoppers;
      }
    } catch (e) {
      Tools.logToConsole("------------ ERROR GET SHOPPERS --------------");
      Tools.logToConsole(e.toString());
      return null;
    }
  }

  static Future<Level> getLevel(String levelId) async {
    try {
      var response = await ApiProvider.sendRequest(
        url: GET_LEVEL + levelId,
        method: httpMethods.get,
      );

      if (response.statusCode == SUCCESS_CODE) {
        Level level = LevelModelResponse.fromJson(response.data).data;
        return level;
      } else {
        return null;
      }
    } catch (e) {
      Tools.logToConsole(e.toString());
      Tools.logToConsole('e.toString()');
      return null;
    }
  }

  static Future<List<Level>> getLevels() async {
    try {
      var response = await ApiProvider.sendRequest(
        url: GET_LEVEL,
        method: httpMethods.get,
      );

      if (response.statusCode == SUCCESS_CODE) {
        List<Level> levels = LevelsResponse.fromJson(response.data).levels;
        return levels;
      } else {
        return null;
      }
    } catch (e) {
      Tools.logToConsole(e.toString());
      return null;
    }
  }

  static Future<bool> changeShopperStatus({@required String shopperId, @required String newStatus}) async {
    Map changeStatus = {'status': newStatus};
    try {
      var response = await ApiProvider.sendRequest(
          url: CHANGE_SHOPPER_STATUS + shopperId, method: httpMethods.put, body: jsonEncode(changeStatus));

      if (response.statusCode == SUCCESS_CODE) {
        return true;
      } else {
        Tools.logToConsole("------------ ERROR UPDATE ADDRESS --------------");
        return false;
      }
    } catch (e) {
      Tools.logToConsole(e.toString());
      return false;
    }
  }

  static Future<List<Warehouse>> getWarehouses() async {
    try {
      var response = await ApiProvider.sendRequest(
        url: GET_WAREHOUSE,
        method: httpMethods.get,
      );

      if (response.statusCode == SUCCESS_CODE && response.data['success'].toString() == 'true') {
        LoadingScreenServices.warehouses =
            List<Warehouse>.from(response.data["data"].map((x) => Warehouse.fromJson(x)));

        return LoadingScreenServices.warehouses;
      } else {
        return LoadingScreenServices.warehouses;
      }
    } catch (e) {
      Tools.logToConsole(e.toString());

      return null;
    }
  }

  static List<DropdownMenuItem<int>> inventorySubWarehouseNames() {
    List<String> names = LoadingScreenServices.subWarehouses.map((subWarehouse) => subWarehouse.name).toList();
    names.add('الجميع');
    return dropdownStringList(names);
  }

  static List<DropdownMenuItem<int>> transactionTypesNames() {
    List<String> names = LoadingScreenServices.transactionTypes
        .where((type) => type.automatic == 0)
        .map((type) => type.arabicName)
        .toList();
    return dropdownStringList(names);
  }

  static List<DropdownMenuItem<String>> productSubWarehouseNames(BuildContext context) {
    List<DropdownMenuItem<String>> names = LoadingScreenServices.subWarehouses
        .map(
          (subWarehouse) => DropdownMenuItem<String>(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.68,
              child: Text(
                subWarehouse.name,
                style: warehouseStyle,
              ),
            ),
            value: subWarehouse.id.toString(),
          ),
        )
        .toList();
    return names;
  }

  static List<DropdownMenuItem<int>> dropdownIntList(List<String> inputList) {
    List<DropdownMenuItem<int>> list = inputList
        .asMap()
        .map(
          (value, string) => MapEntry(
            value,
            DropdownMenuItem<int>(
              child: Text(
                string,
                style: dropdownItemStyle,
              ),
              value: value + 1,
            ),
          ),
        )
        .values
        .toList();
    return list;
  }

  static List<DropdownMenuItem<int>> dropdownStringList(List<String> inputList) {
    List<DropdownMenuItem<int>> list = inputList
        .asMap()
        .map(
          (value, string) => MapEntry(
            value,
            DropdownMenuItem<int>(
              child: Center(
                child: Text(
                  string,
                  style: dropdownItemStyle,
                ),
              ),
              value: value,
            ),
          ),
        )
        .values
        .toList();
    return list;
  }

  static List<DropdownMenuItem<String>> shoppersNameList() {
    List<DropdownMenuItem<String>> list = LoadingScreenServices.allShoppers
        .where((shopper) => shopper.status == 1)
        .map(
          (shopper) => DropdownMenuItem<String>(
            child: Center(
              child: Text(
                shopper.name + ' ✅',
                style: dropdownItemStyle,
              ),
            ),
            value: shopper.name,
          ),
        )
        .toList();
    list.addAll(
      LoadingScreenServices.allShoppers
          .where((shopper) => shopper.status == 0)
          .map(
            (shopper) => DropdownMenuItem<String>(
              child: Center(
                child: Text(
                  shopper.name + ' ❌',
                  style: dropdownItemStyle,
                ),
              ),
              value: shopper.name,
            ),
          )
          .toList(),
    );
    return list;
  }

  static bool isAdmin() {
    return Services.roles.where((element) => element.slug.contains(StringUtils.adminRole)).length > 0;
  }

  static bool isOperationManager() {
    return Services.roles.where((element) => element.slug.contains(StringUtils.operationManager)).length > 0;
  }

  static bool isProductsController() {
    return Services.roles.where((element) => element.slug.contains(StringUtils.productsController)).length > 0;
  }

  static bool isSuperAdmin() {
    return Services.roles.where((element) => element.slug.contains(StringUtils.superAdminRole)).length > 0;
  }

  static bool isAccounting() {
    return Services.roles.where((element) => element.slug.contains(StringUtils.accountingRole)).length > 0;
  }

  static bool isDelivery() {
    return Services.roles.where((element) => element.slug.contains(StringUtils.deliveryRole)).length > 0;
  }

  static bool isShopper() {
    return Services.roles.where((element) => element.slug.contains(StringUtils.shopperRole)).length > 0;
  }

  static bool isSupplierManager() {
    return Services.roles.where((element) => element.slug.contains(StringUtils.supplierRol)).length > 0;
  }

  static errorFlushBar(BuildContext context) {
    return Flushbar(
      backgroundColor: Colors.red[900],
      messageText: Text(
        "فشل في العملية يرجى المحاولة من جديد",
        style: flushBarStyle,
      ),
      boxShadows: [
        BoxShadow(
          color: Colors.red,
          offset: Offset(0.0, 2.0),
          blurRadius: 3.0,
        )
      ],
      icon: Icon(
        Icons.close,
        size: 28.0,
        color: Colors.white,
      ),
      duration: Duration(seconds: 2),
    )..show(context);
  }

  static successFlushBar(BuildContext context) {
    return Flushbar(
      backgroundColor: Colors.green,
      messageText: Text(
        "تمت العملية بنجاح",
        style: flushBarStyle,
      ),
      boxShadows: [
        BoxShadow(
          color: ColorUtils.primaryColor,
          offset: Offset(0.0, 2.0),
          blurRadius: 3.0,
        )
      ],
      icon: Icon(
        Icons.assignment_turned_in,
        size: 28.0,
        color: Colors.white,
      ),
      duration: Duration(seconds: 1),
      leftBarIndicatorColor: ColorUtils.kmColors,
    )..show(context);
  }

  static resultFlushBar({@required BuildContext context, @required bool result}) {
    if (result) {
      Services.successFlushBar(context);
    } else {
      Services.errorFlushBar(context);
    }
  }

  static List<ProductData> productListSort(List<ProductData> productsList) {
    productsList.sort((a, b) {
      if (a.categories.length > 0 && b.categories.length > 0) {
        if (a.categories[0].id > b.categories[0].id) {
          return 1;
        } else
          return -1;
      } else
        return -1;
    });
    return productsList;
  }

  static String selectedShopperId(String name) {
    return LoadingScreenServices.allShoppers
        .firstWhere((shopper) => shopper.name == name.replaceAll(' ✅', '').replaceAll(' ❌', ''))
        .id
        .toString();
  }

  static int kRound(double number) {
    double doubleSum = number / 100;
    String stringSum = doubleSum.toString().split('.')[0];
    int result = int.parse(stringSum);
    result *= 100;
    return result;
  }

  static makePhoneCall(String number) async {
    String url = 'tel:$number';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  static openUrl(String selected, {String mobileNumber}) async {
    String url = "";
    switch (selected) {
      case "whatsapp":
        url = 'whatsapp://send?phone=' + LoadingScreenServices.companyInformation.whatsappNumber;
        break;
      case "messenger":
        url = LoadingScreenServices.companyInformation.messengerUrl;
        break;
      case "facebook":
        url = "fb://page/" + LoadingScreenServices.companyInformation.facebookUrl.toString();
        break;
      case "instagram":
        url = LoadingScreenServices.companyInformation.instagramUrl.toString();
        break;
      case "website":
        url = LoadingScreenServices.companyInformation.websiteUrl.toString();
        break;
      case "email":
        String platform = "Android";
        if (Platform.isIOS) {
          platform = "iPhone";
        }
        url =
            "mailto:${LoadingScreenServices.companyInformation.email}?subject=Support Request From $platform Application&body=";
        break;
      case "number":
        url = "tel:${LoadingScreenServices.supportPhoneNumber}";
        break;
      case "customer_whatsapp":
        url = 'whatsapp://send?phone=' + mobileNumber;
        break;
    }
    /*if (selected == "whatsapp") {
      url = 'whatsapp://send?phone=' + LoadingScreenServices.companyInformation.whatsappNumber;
    } else if (selected == "messenger") {
      url = LoadingScreenServices.companyInformation.messengerUrl;
    } else if (selected == "facebook") {
      url = "fb://page/" + LoadingScreenServices.companyInformation.facebookUrl.toString();
    } else if (selected == "instagram") {
      url = LoadingScreenServices.companyInformation.instagramUrl.toString();
    } else if (selected == "website") {
      url = LoadingScreenServices.companyInformation.websiteUrl.toString();
    } else if (selected == "email") {
      String platform = "Android";
      if (Platform.isIOS) {
        platform = "iPhone";
      }
      url =
          "mailto:${LoadingScreenServices.companyInformation.email}?subject=Support Request From $platform Application&body=";
    } else if (selected == "number") {
      url = "tel:${LoadingScreenServices.supportPhoneNumber}";
    }*/

    launch(url);
  }

  static shareApp() {
    String infoMessage = "تطبيق كمّون لتوصيل المنتجات الغذائية لباب بيتك و بأسعار منافسة\n";
    String androidGrating = "\n لتحميل التطبيق على الأندوريد \n";

    String androidUrl = androidGrating + LoadingScreenServices.iOSShareUrl;
    String iosGrating = "\n لتحميل التطبيق على الآيفون \n";
    String iPhoneUrl = iosGrating + LoadingScreenServices.androidShareUrl;

    Share.share(infoMessage + androidUrl + iPhoneUrl);
  }
}
