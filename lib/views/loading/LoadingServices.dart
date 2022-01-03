import 'dart:async';
import 'dart:convert';

import 'package:adv_image_cache/adv_image_cache.dart';
import 'package:flutter/material.dart';
import 'package:kammun_app/core/api/admin_URLs.dart';
import 'package:kammun_app/models/models_importer.dart';
import 'package:kammun_app/core/api/api_URLs.dart';
import 'package:kammun_app/core/api/api_provider.dart';
import 'package:kammun_app/core/errors/error_types.dart';
import 'package:kammun_app/views/inventory/services/inventory_services.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io' show Platform;
import '../../Services.dart';
import 'Loading.dart';
import 'package:kammun_app/utils/utils_importer.dart';

class LoadingScreenServices {
  static StartModel startRequest = new StartModel();
  static CompanyOriginalData companyInformation = new CompanyOriginalData();

  static List<CategoryOriginalData> categoryList = List<CategoryOriginalData>();

  static List<SubWarehouse> subWarehouses = new List<SubWarehouse>();
  static List<Warehouse> warehouses = new List<Warehouse>();

  static List<DropdownMenuItem> fullCategoryList = List<DropdownMenuItem>();

  static String imagePrefixUrl = "";

  static List<FadeInImage> bannerListNetwork = List<FadeInImage>();

  // Mobile Configuration variables
  static String updateUrl = "";
  static String androidShareUrl = "";
  static String iOSShareUrl = "";
  static bool serverMaintain = false;
  static bool userBlocked = false;
  static bool updateRequired = false;
  static bool updateOptional = false;
  static bool checkIfLoggedIn = false;

  static SupportedCityOriginal supportedCityOriginal;
  static String supportPhoneNumber;
  static String systemMaintenanceMessages;
  static UserOriginal userOriginal;

  // -------------------------------------------------------//

  // Supported City variables

  static List<DropdownMenuItem> supportedCitiesList = List<DropdownMenuItem>();

  static List<IndigoDatum> supportedCitiesListIntro = List<IndigoDatum>();

  // -------------------------------------------------------//

  // User Variables
  static List<Address> userAddress = List<Address>();
  static List<ProductData> userFavoriteProducts = List<ProductData>();
  static List<OrdersOriginalData> myOrdersList = new List<OrdersOriginalData>();
  static List<OrdersOriginalData> allOrdersList =
      new List<OrdersOriginalData>();
  static List<ShopperModel> allShoppers = List<ShopperModel>();
  static List<DeliveryModel> allDeliveries = List<DeliveryModel>();
  static List<OrdersOriginalData> shoppersAssignedOrdersList =
      new List<OrdersOriginalData>();
  static List<OrdersOriginalData> deliveriesAssignedOrdersList =
      new List<OrdersOriginalData>();
  static List<OrdersOriginalData> notAssignedOrdersList =
      new List<OrdersOriginalData>();
  static List<OrdersOriginalData> supplierOrderList =
      new List<OrdersOriginalData>();
  static String phoneNumber = "لم تقم بتسجيل رقم";
  static String name;
  static String userName;
  static bool preferLeftSide = true;

  /// -------- selected supported city information ------- ///

  static String selectedSupportedCityName;
  static String selectedSupportedCityPrice;
  static String selectedSupportedCityIsActive;
  static String selectedSupportedCityId;

  // -------------------------------------------------------//

  // static String subSupplierCodeHint = 'kh';
  static RegExp subSupplierCodeHint = RegExp(".*kh");

  Future<bool> updateFirebaseToken(String firebaseToken) async {
    Map body = {
      "firebase_token": firebaseToken,
    };
    await ApiProvider.sendRequest(
      url: UPDATE_ADMIN_FIREBASE_TOKEN,
      method: httpMethods.post,
      body: jsonEncode(body),
    );
    return true;
  }

  static setPreferLeftSide(bool side) async {
    preferLeftSide = side;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('preferLeftSide', side);
  }

  static Future<bool> getSubWarehouse() async {
    subWarehouses.clear();
    SharedPreferences prefs = await SharedPreferences.getInstance();

    List<SubWarehouse> response = await InventoryServices.getSubWarehoused(
        adminId: prefs.getString("adminId"));
    Tools.logToConsole("Admin response");
    Tools.logToConsole(response);
    if (response != null) {
      subWarehouses.addAll(response);

      return true;
    } else {
      return false;
    }
  }

  Future<bool> getSupportedCity() async {
    var response = await ApiProvider.sendRequest(
      url: GET_SUPPORTED_CITIES,
      method: httpMethods.get,
    );
    if (response.statusCode == SUCCESS_CODE) {
      final supportedCitiesResponse =
          supportedCityOriginalFromJson(jsonEncode(response.data));
      supportedCityOriginal = supportedCitiesResponse;

      supportedCitiesListIntro.clear();

      supportedCitiesListIntro.addAll(supportedCitiesResponse.data);

      return true;
    } else {
      return false;
    }
  }

  Future<bool> checkIfUserLoadedIn() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      preferLeftSide = prefs.getBool('preferLeftSide');
      String userToken = prefs.getString('userToken');
      String userSelectSupportedCity = prefs.getString('supportedCitySelected');

      if (userToken != null) {
        LoadingScreen.userToken = "Bearer " + userToken;
        if (userToken == "APPLE_VERIFICATION") {
          BaseUrl = APPLE_BASE_URL;
        } else {
          BaseUrl = PRODUCTION_BASE_URL;
        }
        return true;
      } else {
        return false;
      }
    } catch (e) {
      Tools.logToConsole(e.toString());
      return false;
    }
  }

  int finishedRequests = 0;
  int contractsLength = 0;

  Future<bool> getCategory() async {
    var response = await ApiProvider.sendRequest(
      url: GET_CATEGORY,
      method: httpMethods.get,
    );

    if (response.statusCode == SUCCESS_CODE) {
      categoryList.clear();
      fullCategoryList.clear();
      final category = categoryOriginalFromJson(jsonEncode(response.data)).data;

      for (int i = 0; i < category.length; i++) {
        if (category[i].parentCategoryId == null) {
          fullCategoryList.add(new DropdownMenuItem(
            child: Column(
              children: [
                Container(
                  width: 287,
                  child: Text(
                    category[i].name + " من القائمة الرئيسية",
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
            value: category[i].name + ";" + category[i].id.toString(),
          ));
        }
      }

      for (int i = 0; i < category.length; i++) {
        if (category[i].parentCategoryId != null) {
          fullCategoryList.add(new DropdownMenuItem(
            child: Text(
              category[i].name,
              style: warehouseStyle.copyWith(fontSize: 18),
            ),
            value: category[i].name + ";" + category[i].id.toString(),
          ));
        }
        if (category[i].warehouses.length > 0 &&
            category[i].warehouses[0].pivot.isActive == "1") {
          categoryList.add(category[i]);
        }
      }

      categoryList.sort((a, b) {
        if ((int.parse(a.warehouses[0].pivot.priority)) >
            (int.parse(b.warehouses[0].pivot.priority)))
          return 1;
        else if ((int.parse(a.warehouses[0].pivot.priority) <
            (int.parse(b.warehouses[0].pivot.priority))))
          return -1;
        else
          return 0;
      });
      return true;
    } else {
      return false;
    }
  }

  Future<bool> fetchAdminInformation() async {
    String buildNumber = "100";
    int lastSupported;
    int currentVersion;

    companyInformation = new CompanyOriginalData(
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

    imagePrefixUrl = BaseUrl + "/images/";

    // --------------------------------------------------------------------- //

    // Mobile Configuration

    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString("adminRoll") != null &&
        prefs.getString("adminRoll").contains("@")) {
      subSupplierCodeHint =
          RegExp(".*${prefs.getString("adminRoll").split("@")[1]}");
    } else {
      subSupplierCodeHint = RegExp(".*");
    }

    androidShareUrl =
        "https://play.google.com/store/apps/details?id=com.kammun.app";
    iOSShareUrl =
        "https://apps.apple.com/us/app/%D9%83%D9%85-%D9%88%D9%86/id1505291329";

    if (Platform.isIOS) {
      lastSupported = 100;
      currentVersion = 100;

      LoadingScreen.updateUrl =
          "https://apps.apple.com/us/app/%D9%83%D9%85-%D9%88%D9%86/id1505291329";
    } else {
      lastSupported = 100;
      currentVersion = 100;
      LoadingScreen.updateUrl =
          "https://play.google.com/store/apps/details?id=com.kammun.app";
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
          diskCacheExpire: Duration(days: 400),
        ),
        // width: MediaQuery.of(context).size.width,
        fadeInDuration: const Duration(seconds: 1),
        // fadeInCurve: Curves.fastOutSlowIn,
        fadeInCurve: Curves.fastOutSlowIn,
        placeholder: AssetImage("assets/kmlogoo.png"),
        fit: BoxFit.cover,
      ),
    );

    phoneNumber = "0000000000";

    userBlocked = false;

    return true;
  }

  Future<bool> fetchStartInformation() async {
    try {
      Tools.logToConsole(
          "------------- get Start Screen Information returns ---------");
      bool userLoggedIn = await checkIfUserLoadedIn();
      if (userLoggedIn) {
        try {
          List responses;
          try {
            responses = await Future.wait([
              //CartServices.getUserCart(),
              getSupportedCity(),
              getSubWarehouse(),
              getCategory(),
              fetchAdminInformation(),
            ]);
            if (Services.isOperationManager()) {
              await Services.getShoppers();
              await Services.getDeliveries();
            }
          } catch (e) {
            Tools.logToConsole("--------- error call -----");
            Tools.logToConsole(e.toString());
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
          Tools.logToConsole(e.toString());
          return false;
        }
      } else {
        return false;
      }
    } catch (e) {
      Tools.logToConsole("Error While checking user if loggedIn");
      Tools.logToConsole(e.toString());
      return false;
    }
  }
}
