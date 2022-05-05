import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:kammun_app/utils/utils_importer.dart';
import 'package:kammun_app/views/Widget/widgets_importer.dart';
import 'package:kammun_app/views/loading/loading.dart';
import 'package:kammun_app/views/loading/loading_services.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'core/core_importer.dart';
import 'models/models_importer.dart';

class Services {
  static bool updateOption = false;

  static Future<bool> addToFavorites(String productsId) async {
    var response = await ApiProvider.sendRequest(
      url: addToFavorite + productsId,
      method: HttpMethods.put,
    );

    if (response.statusCode == successCode) {
      return true;
    } else {
      return false;
    }
  }

  static Future<bool> removeFromFavorites(String productsId) async {
    var response = await ApiProvider.sendRequest(
      url: removeFromFavorite + productsId,
      method: HttpMethods.put,
    );

    if (response.statusCode == successCode) {
      return true;
    } else {
      return false;
    }
  }

  static Future<bool> addNewAddress({
    String city,
    String street,
    String building,
    String floor,
    String description,
    String supportedCityId,
    double lat,
    double lon,
    String entrance,
  }) async {
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
      var response =
          await ApiProvider.sendRequest(url: userAddress, method: HttpMethods.post, body: jsonEncode(addressData));

      if (response.statusCode == successCode) {
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

  static Future<bool> updateAddress({
    String addressId,
    String city,
    String street,
    String building,
    String floor,
    String description,
    String supportedCityId,
    double lat,
    double lon,
    String entrance,
  }) async {
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
          url: userAddress + "/$addressId", method: HttpMethods.put, body: jsonEncode(addressData));

      if (response.statusCode == successCode) {
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
        url: userAddress + "/$addressId",
        method: HttpMethods.delete,
      );

      if (response.statusCode == successCode) {
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
        url: getUserOrder,
        method: HttpMethods.get,
        queryParameters: {"page": pageNumber},
      );

      if (response.statusCode == successCode) {
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
      baseUrl = appleBaseUrl;
    } else {
      baseUrl = productionBaseUrl;
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
          url: loginUrl, method: HttpMethods.post, body: jsonEncode(loginBody), responseType: ResponseType.json);
      var theResponse = response.data;

      if (response.statusCode == successCode && (theResponse["success"].toString() == "true")) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  static Future<bool> verifyCode(String code) async {
    var response = await ApiProvider.sendRequest(url: otpVerification + code, method: HttpMethods.get);

    var data = (response.data);

    if (response.statusCode == successCode && data["success"] == true) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("userToken", data["api_token"]);
      LoadingScreen.userToken = "Bearer " + data["api_token"];
      if (data["api_token"].toString().contains("APPLE_VERIFICATION")) {
        baseUrl = appleBaseUrl;
      } else {
        baseUrl = productionBaseUrl;
      }
      return true;
    } else {
      return false;
    }
  }

  static Future<void> userVisitProduct(String productId) async {
    await ApiProvider.sendRequest(url: getProduct + productId, method: HttpMethods.post);
  }

  static openUrl(String selected) async {
    String url = "";
    if (selected == "whatsapp") {
      url = 'whatsapp://send?phone=' + LoadingScreenServices.supportPhoneNumber.toString();
    } else if (selected == "messenger") {
      url = LoadingScreenServices.companyInformation.messengerUrl;
    } else if (selected == "facebook") {
      if (Platform.isIOS) {
        url = 'fb://profile/${LoadingScreenServices.companyInformation.facebookUrl.toString()}';
      } else {
        url = 'fb://page/${LoadingScreenServices.companyInformation.facebookUrl.toString()}';
      }
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
      url = "tel:${LoadingScreenServices.supportPhoneNumber.toString()}";
    }

    launch(url, forceSafariVC: false);
  }

  static shareApp() {
    String infoMessage = "تطبيق كمّون لتوصيل المنتجات الغذائية لباب بيتك و بأسعار منافسة\n";
    String androidGrating = "\n لتحميل التطبيق على الأندوريد \n";

    String androidUrl = androidGrating + LoadingScreenServices.androidShareUrl;
    String iosGrating = "\n لتحميل التطبيق على الآيفون \n";
    String iPhoneUrl = iosGrating + LoadingScreenServices.iOSShareUrl;

    Share.share(infoMessage + androidUrl + iPhoneUrl);
  }

  static showUpdateOrderInstruction({BuildContext context}) {
    showMyDialog(
      title: '',
      context: context,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "انت تقوم حالياً بتعديل طلبك",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                  fontFamily: StringUtils.fontFamilyHKGrotesk,
                  fontSize: 18),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "بإمكانك إضافة أو حذف او تعديل المنتجات الخاصة بك ضمن سلة المشتريات بالشكل الطبيعي الذي تقوم به عادة",
              style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: Colors.grey[800],
                  fontFamily: StringUtils.fontFamilyHKGrotesk,
                  fontSize: 18),
            ),
          ),
          KammunButton(
            color: ColorUtils.primaryColor,
            onTap: () => Navigator.of(context).pop(),
            text: StringUtils.approveUsagePolicy,
            width: MediaQuery.of(context).size.width / 2,
          ),
        ],
      ),
      dialogButtons: [],
    );
  }
}
