import 'dart:async';
import 'dart:io' show Platform;

import 'package:adv_image_cache/adv_image_cache.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/core_importer.dart';
import '../../models/models_importer.dart';
import '../../service.dart';
import '../../utils/utils_importer.dart';
import '../../views/inventory/services/inventory_services.dart';
import '../../views/reports/models/transaction_type_model.dart';
import '../../views/reports/services/reports_services.dart';
import 'loading.dart';

class LoadingScreenServices {
  static CompanyOriginalData companyInformation = CompanyOriginalData();
  static List<Level> levels = [];

  static List<CategoryOriginalData> categoryList = [];

  static List<SubWarehouse> subWarehouses = [];
  static List<Warehouse> warehouses = [];

  static List<DropdownMenuItem> fullCategoryList = [];

  static String imagePrefixUrl = "";

  static List<FadeInImage> bannerListNetwork = [];

  // Mobile Configuration variables
  static String androidShareUrl = "";
  static String iOSShareUrl = "";
  static bool serverMaintain = false;
  static bool updateRequired = false;
  static bool updateOptional = false;

  static SupportedCityOriginal supportedCityOriginal;
  static String supportPhoneNumber;
  static String systemMaintenanceMessages;

  // -------------------------------------------------------//

  // Supported City variables

  static List<IndigoDatum> supportedCitiesListIntro = [];

  // -------------------------------------------------------//

  // User Variables
  static List<ProductData> allProducts = [];
  static List<ProductData> notAddedProducts = [];
  static List<OrdersOriginalData> myOrdersList = [];
  static List<OrdersOriginalData> allOrdersList = [];
  static List<OrdersOriginalData> phoneOrderList = [];
  static List<ShopperModel> allShoppers = [];
  static List<TransactionTypeModel> transactionTypes = [];
  static String phoneNumber = "لم تقم بتسجيل رقم";
  static String name;
  static String userName;
  static bool preferLeftSide = true;
  static int ordersViewFilter = 0;

  // -------------------------------------------------------//

  static RegExp subSupplierCodeHint = RegExp(".*kh");

  Future<bool> updateFirebaseTokenService(String firebaseToken) async {
    try {
      Map body = {
        "firebase_token": firebaseToken,
      };
      await ApiProvider.sendRequest(
        url: updateFirebaseToken,
        method: HttpMethods.post,
        body: jsonEncode(body),
      );
      return true;
    } catch (e) {
      return null;
    }
  }

  static setPreferLeftSide(bool side) async {
    preferLeftSide = side;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('preferLeftSide', side);
  }

  static Future<bool> getSubWarehouse() async {
    try {
      subWarehouses.clear();
      SharedPreferences prefs = await SharedPreferences.getInstance();

      List<SubWarehouse> response = await InventoryServices.getSubWarehoused(adminId: prefs.getString("adminId"));

      if (response != null) {
        subWarehouses.addAll(response);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return null;
    }
  }

  Future<bool> getSupportedCity() async {
    try {
      var response = await ApiProvider.sendRequest(
        url: getSupportedCities,
        method: HttpMethods.get,
      );
      if (response.statusCode == successCode) {
        final supportedCitiesResponse = supportedCityOriginalFromJson(jsonEncode(response.data));
        supportedCityOriginal = supportedCitiesResponse;

        supportedCitiesListIntro.clear();

        supportedCitiesListIntro.addAll(supportedCitiesResponse.data);

        return true;
      } else {
        return false;
      }
    } catch (e) {
      return null;
    }
  }

  Future<bool> checkIfUserLoggedIn() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      preferLeftSide = prefs.getBool('preferLeftSide');
      String userToken = prefs.getString('userToken');
      if (userToken != null) {
        LoadingScreen.userToken = "Bearer " + userToken;
        if (userToken == "APPLE_VERIFICATION") {
          baseUrl = appleBaseUrl;
        } else {
          baseUrl = productionBaseUrl;
        }
        if (['rabie', 'supplier', 'rabia'].contains(userToken)) {
          baseUrl = testUrl;
        }
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return null;
    }
  }

  int finishedRequests = 0;
  int contractsLength = 0;

  Future<bool> getCategoryService() async {
    try {
      var response = await ApiProvider.sendRequest(
        url: getCategory,
        method: HttpMethods.get,
      );

      if (response.statusCode == successCode) {
        categoryList.clear();
        fullCategoryList.clear();
        final categories = categoryOriginalFromJson(jsonEncode(response.data)).data;
        fullCategoryList = categories
            .where((category) => category.parentCategoryId == 'null')
            .toList()
            .map(
              (category) => DropdownMenuItem(
                child: Column(
                  children: [
                    SizedBox(
                      width: 287,
                      child: Text(
                        category.name + " من القائمة الرئيسية",
                        overflow: TextOverflow.visible,
                        maxLines: 2,
                        style: warehouseStyle,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Divider(
                        thickness: 1,
                        color: ColorUtils.greyColor,
                      ),
                    )
                  ],
                ),
                value: category.name + ";" + category.id.toString(),
              ),
            )
            .toList();

        fullCategoryList.addAll(
          categories
              .where((category) => category.parentCategoryId != null)
              .toList()
              .map(
                (category) => DropdownMenuItem(
                  child: Text(
                    category.name,
                    style: warehouseStyle.copyWith(fontSize: 18),
                  ),
                  value: category.name + ";" + category.id.toString(),
                ),
              )
              .toList(),
        );
        categoryList = categories
            .where((category) => category.warehouses.isNotEmpty && category.warehouses[0].pivot.isActive == "1")
            .toList();

        categoryList.sort((a, b) {
          if ((int.parse(a.warehouses[0].pivot.priority)) > (int.parse(b.warehouses[0].pivot.priority))) {
            return 1;
          } else if ((int.parse(a.warehouses[0].pivot.priority) < (int.parse(b.warehouses[0].pivot.priority)))) {
            return -1;
          } else {
            return 0;
          }
        });
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return null;
    }
  }

  Future<bool> fetchAdminInformation() async {
    String buildNumber = "100";
    int lastSupported;
    int currentVersion;

    companyInformation = CompanyOriginalData(
        email: "support@kammun.com",
        whatsappNumber: "+963969999204",
        supportNumber: "0969999204",
        facebookUrl: "106414764313952",
        instagramUrl: "https://www.instagram.com/kammunapp",
        messengerUrl: "http://m.me/KammunApp",
        supportUrl: "https://www.instagram.com/",
        baseUrl: "https://kammun.com",
        imageBaseUrl: "https://kammun.app/images/",
        currency: "S.P",
        additionalInfo: "http://m.me/KammunApp");

    imagePrefixUrl = appUrl + "/images/";

    // --------------------------------------------------------------------- //

    // Mobile Configuration

    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString("adminRoll") != null && prefs.getString("adminRoll").contains("@")) {
      subSupplierCodeHint = RegExp(".*${prefs.getString("adminRoll").split("@")[1]}");
    } else {
      subSupplierCodeHint = RegExp(".*");
    }

    androidShareUrl = "https://play.google.com/store/apps/details?id=com.kammun.app";
    iOSShareUrl = "https://apps.apple.com/us/app/%D9%83%D9%85-%D9%88%D9%86/id1505291329";

    if (Platform.isIOS) {
      lastSupported = 100;
      currentVersion = 100;

      LoadingScreen.updateUrl = "https://apps.apple.com/us/app/%D9%83%D9%85-%D9%88%D9%86/id1505291329";
    } else {
      lastSupported = 100;
      currentVersion = 100;
      LoadingScreen.updateUrl = "https://play.google.com/store/apps/details?id=com.kammun.app";
    }

    if (int.parse(buildNumber) < lastSupported) {
      updateRequired = true;
    } else if (int.parse(buildNumber) < currentVersion) {
      updateOptional = true;
    }

    bannerListNetwork.clear();
    bannerListNetwork.add(
      FadeInImage(
        image: AdvImageCache(
          LoadingScreenServices.imagePrefixUrl + "slide3.png",
          useMemCache: true,
          diskCacheExpire: const Duration(days: 400),
        ),
        fadeInDuration: const Duration(seconds: 1),
        fadeInCurve: Curves.fastOutSlowIn,
        placeholder: const AssetImage("assets/kmlogoo.png"),
        fit: BoxFit.cover,
      ),
    );

    phoneNumber = "0000000000";

    return true;
  }

  Future<bool> fetchStartInformation() async {
    try {
      bool userLoggedIn = await checkIfUserLoggedIn();
      if (userLoggedIn) {
        try {
          List responses;
          try {
            responses = await Future.wait([
              getSupportedCity(),
              getSubWarehouse(),
              getCategoryService(),
              Services.getWarehousesService(),
              fetchAdminInformation(),
            ]);
            if (Services.isOperationManager() ||
                Services.isSuperAdmin() ||
                Services.isAdmin() ||
                Services.isAccounting()) {
              await Services.getShoppers();
              levels = await Services.getLevels();
            }
            if (Services.isAccounting() || Services.isSuperAdmin() || Services.isAdmin() || Services.isShopper()) {
              transactionTypes = await ReportsServices.getTransactionTypes();
            }
          } catch (e) {
            return false;
          }

          if (responses[1] == null) {
            fetchAdminInformation();
          } else {
            if (responses[0] && responses[1]) {
              return true;
            } else {
              return false;
            }
          }
          return true;
        } catch (e) {
          return false;
        }
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }
}
