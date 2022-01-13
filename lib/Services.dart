import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kammun_app/models/models_importer.dart';
import 'package:kammun_app/views/loading/Loading.dart';
import 'package:kammun_app/views/loading/LoadingServices.dart';
import 'package:kammun_app/views/restart/kammunapp_restart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'core/api/api_importer.dart';
import 'core/errors/error_types.dart';
import 'utils/utils_importer.dart';

class Services {
  static List<Role> roles = [];
  static ShopperModel shopper;
  static bool updateOption = false;

  //static String imagePrefixUrl = "";
  static String prefixUrl = "http://kammun.com/lsapp/public/api/";
  static String googlePlayUrl = "";
  static String appStoreUrl = "";

  static int deliveryPrice = 50;

  static Future<bool> addToFavorites(String productsId) async {
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

  static Future<List<OrdersOriginalData>> getAllOrders(
      {int pageNumber = 1}) async {
    try {
      var response = await ApiProvider.sendRequest(
        url: API + ORDER,
        method: httpMethods.get,
        queryParameters: {"page": pageNumber},
      );

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
        BASE_URL = APPLE_BASE_URL;
      } else {
        BASE_URL = PRODUCTION_BASE_URL;
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

  static Future<List<ShopperModel>> getShoppers() async {
    Tools.logToConsole(
        "------------------ Get All Shoppers  --------------------");

    try {
      var response = await ApiProvider.sendRequest(
        url: GET_SHOPPER,
        method: httpMethods.get,
      );
      Tools.logToConsole("------- shoppers data -------");

      if (response.statusCode == SUCCESS_CODE) {
        LoadingScreenServices.allShoppers =
            shoppersFromJson(jsonEncode(response.data)).data;
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
        Tools.logToConsole("message from get level and decode");
        Tools.logToConsole(
            ModelResponse.fromJson(response.data).data.id.toString());
        Level level = ModelResponse.fromJson(response.data).data;
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

  static Future<List<DeliveryModel>> getDeliveries() async {
    Tools.logToConsole(
        "------------------ Get All Deliveries  --------------------");

    try {
      var response = await ApiProvider.sendRequest(
        url: GET_DELIVERIES,
        method: httpMethods.get,
      );
      Tools.logToConsole("------- Deliveries data -------");

      if (response.statusCode == SUCCESS_CODE) {
        LoadingScreenServices.allDeliveries =
            deliveriesFromJson(jsonEncode(response.data)).data;

        return LoadingScreenServices.allDeliveries;
      } else {
        return LoadingScreenServices.allDeliveries;
      }
    } catch (e) {
      Tools.logToConsole("------------ ERROR GET DELIVERIES --------------");
      Tools.logToConsole(e.toString());
      return null;
    }
  }

  static Future<bool> changeShopperStatus() async {
    String newStatus = Services.shopper.status == 1 ? '0' : '1';
    Map changeStatus = {'status': newStatus};
    try {
      var response = await ApiProvider.sendRequest(
          url: CHANGE_SHOPPER_STATUS + Services.shopper.id.toString(),
          method: httpMethods.put,
          body: jsonEncode(changeStatus));

      if (response.statusCode == SUCCESS_CODE) {
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

  static Future<List<Warehouse>> getWarehouses() async {
    try {
      var response = await ApiProvider.sendRequest(
        url: GET_WAREHOUSE,
        method: httpMethods.get,
      );
      Tools.logToConsole("------- Warehouses data -------");

      if (response.statusCode == SUCCESS_CODE) {
        LoadingScreenServices.warehouses = List<Warehouse>.from(
            response.data["data"].map((x) => Warehouse.fromJson(x)));

        return LoadingScreenServices.warehouses;
      } else {
        return LoadingScreenServices.warehouses;
      }
    } catch (e) {
      Tools.logToConsole("------------ ERROR GET WAREHOUSES --------------");
      Tools.logToConsole(e.toString());

      return null;
    }
  }

  static List<DropdownMenuItem<int>> inventorySubWarehouseNames() {
    List<String> names = [];
    for (int i = 0; i < LoadingScreenServices.subWarehouses.length; i++) {
      names.add(LoadingScreenServices.subWarehouses[i].name);
    }
    names.add('الجميع');
    return dropdownStringList(names);
  }

  static List<DropdownMenuItem<int>> transactionTypesNames() {
    List<String> names = LoadingScreenServices.transactionTypes
        .where((type) => type.automatic == 0)
        .map((type) => StringUtils.transactionTypesMap[type.slug])
        .toList();
    return dropdownStringList(names);
  }

  static List<DropdownMenuItem<String>> productSubWarehouseNames(
      BuildContext context) {
    List<DropdownMenuItem<String>> names = [];
    for (int i = 0; i < LoadingScreenServices.subWarehouses.length; i++) {
      names.add(
        DropdownMenuItem<String>(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.68,
            child: Text(
              LoadingScreenServices.subWarehouses[i].name,
              style: warehouseStyle,
            ),
          ),
          value: LoadingScreenServices.subWarehouses[i].id.toString(),
        ),
      );
    }
    return names;
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
          child: Center(
            child: Text(
              inputList[i],
              style: dropdownItemStyle,
            ),
          ),
          value: i,
        ),
      );
    }
    return list;
  }

  static List<DropdownMenuItem> shoppersNameList() {
    List<DropdownMenuItem> list = List();
    for (int i = 0; i < LoadingScreenServices.allShoppers.length; i++) {
      if (LoadingScreenServices.allShoppers[i].status == 1) {
        list.add(DropdownMenuItem<String>(
          child: Center(
            child: Text(
              LoadingScreenServices.allShoppers[i].name + ' ✅',
              style: dropdownItemStyle,
            ),
          ),
          value: LoadingScreenServices.allShoppers[i].name,
        ));
      }
    }
    for (int i = 0; i < LoadingScreenServices.allShoppers.length; i++) {
      if (LoadingScreenServices.allShoppers[i].status == 0) {
        list.add(DropdownMenuItem<String>(
          child: Center(
            child: Text(
              LoadingScreenServices.allShoppers[i].name + ' ❌',
              style: dropdownItemStyle,
            ),
          ),
          value: LoadingScreenServices.allShoppers[i].name,
        ));
      }
    }
    return list;
  }

  static List<DropdownMenuItem> deliveriesNameList() {
    List<DropdownMenuItem> itemList = List();
    for (int i = 0; i < LoadingScreenServices.allDeliveries.length; i++) {
      itemList.add(DropdownMenuItem<String>(
        child: Center(
          child: Text(
            LoadingScreenServices.allDeliveries[i].name,
            style: dropdownItemStyle,
          ),
        ),
        value: LoadingScreenServices.allDeliveries[i].name,
      ));
    }
    return itemList;
  }

  static bool isAdmin() {
    return Services.roles
            .where((element) => element.slug.contains(StringUtils.adminRole))
            .length >
        0;
  }

  static bool isOperationManager() {
    return Services.roles
            .where((element) =>
                element.slug.contains(StringUtils.operationManager))
            .length >
        0;
  }

  static bool isProductsController() {
    return Services.roles
            .where((element) =>
                element.slug.contains(StringUtils.productsController))
            .length >
        0;
  }

  static bool isSuperAdmin() {
    return Services.roles
            .where(
                (element) => element.slug.contains(StringUtils.superAdminRole))
            .length >
        0;
  }

  static bool isAccounting() {
    return Services.roles
            .where(
                (element) => element.slug.contains(StringUtils.accountingRole))
            .length >
        0;
  }

  static bool isDelivery() {
    return Services.roles
            .where((element) => element.slug.contains(StringUtils.deliveryRole))
            .length >
        0;
  }

  static bool isShopper() {
    return Services.roles
            .where((element) => element.slug.contains(StringUtils.shopperRole))
            .length >
        0;
  }

  static bool isSupplierManager() {
    return Services.roles
            .where((element) => element.slug.contains(StringUtils.supplierRol))
            .length >
        0;
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
      // titleText: Text("تمت الإضافة بنجاح"),
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

  static resultFlushBar(
      {@required BuildContext context, @required bool result}) {
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

  static List<OrderProducts> orderProductsSort(
      List<OrderProducts> productsList) {
    productsList.sort((a, b) {
      if (a.subWarehouseId > b.subWarehouseId)
        return 1;
      else
        return -1;
    });
    return productsList;
  }

  static String selectedShopperId(String name) {
    return LoadingScreenServices.allShoppers
        .firstWhere((shopper) =>
            shopper.name == name.replaceAll(' ✅', '').replaceAll(' ❌', ''))
        .id
        .toString();
  }

  static makePhoneCall(String number) async {
    String url = 'tel:$number';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
