import 'dart:async';
import 'dart:convert';

import 'package:adv_image_cache/adv_image_cache.dart';
import 'package:flutter/material.dart';
import 'package:kammun_app/core/core_importer.dart';
import 'package:kammun_app/models/models_importer.dart';
import 'package:kammun_app/utils/utils_importer.dart';
import 'package:kammun_app/views/cart/services/cart_services.dart';
import 'package:kammun_app/views/deliver_to/deliver_to_view.dart';
import 'package:kammun_app/views/orders/services/order_services.dart';
import 'package:package_info/package_info.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io' show Platform;
import 'Loading.dart';

class LoadingScreenServices {
  static StartModel startRequest = new StartModel();
  static CompanyOriginalData companyInformation = new CompanyOriginalData();

  static List<CategoryOriginalData> categoryList = List<CategoryOriginalData>();
  static String imagePrefixUrl = "";
  static List<AssetImage> bannerList = List<AssetImage>();
  static List<Image> bannerListNetwork = List<Image>();
  static String updateUrl = "";
  static String androidShareUrl = "";
  static String iOSShareUrl = "";
  static bool serverMaintain = false;
  static bool userBlocked = false;
  static bool updateRequired = false;
  static bool updateOptional = false;
  static bool checkIfLoggedIn = false;
  static bool showOnLunchNotification = true;

  static SupportedCityOriginal supportedCityOriginal;
  static String supportPhoneNumber;
  static String systemMaintenanceMessages;
  static UserOriginal userOriginal;
  // -------------------------------------------------------//

  // Supported City variables

  static List<DropdownMenuItem> supportedCitiesList = List<DropdownMenuItem>();
  static List<DropdownMenuItem> supportedCitiesListIntro = List<DropdownMenuItem>();

  // -------------------------------------------------------//

  // User Variables
  static List<Address> userAddress = List<Address>();
  static List<ProductData> userFavoriteProducts = List<ProductData>();
  static List<OrdersOriginalData> myOrdersList = new List<OrdersOriginalData>();
  static String userNumber = "لم تقم بتسجيل رقم";

  // -------------------------------------------------------//

  /// -------- selected supported city information ------- ///

  static String selectedSupportedCityName;
  static String selectedSupportedCityPrice;
  static String selectedSupportedCityIsActive;
  static String selectedSupportedCityId;

  // -------------------------------------------------------//

  Future<bool> updateFirebaseToken(String firebaseToken) async {
    Map body = {
      "firebase_token": firebaseToken,
    };
    await ApiProvider.sendRequest(
      url: UPDATE_FIREBASE_TOKEN,
      method: httpMethods.post,
      body: jsonEncode(body),
    );
    return true;
  }

  Future<bool> getSupportedCity() async {
    var response = await ApiProvider.sendRequest(
      url: GET_SUPPORTED_CITIES,
      method: httpMethods.get,
    );
    if (response.statusCode == SUCCESS_CODE) {
      final supportedCitiesResponse = supportedCityOriginalFromJson(jsonEncode(response.data));
      supportedCityOriginal = supportedCitiesResponse;

      supportedCityOriginal.data.removeWhere((city) => city.isActive == "0");
      supportedCitiesListIntro.clear();
      for (int i = 0; i < supportedCitiesResponse.data.length; i++) {
        supportedCitiesListIntro.add(new DropdownMenuItem(
          child: ListTile(
            leading: Icon(
              Icons.pin_drop,
              color: ColorUtils.kmColors,
            ),
            title: Text(
              '${supportedCitiesResponse.data[i].name} ',
              style: TextStyle(
                fontFamily: StringUtils.fontFamilyHKGrotesk,
              ),
            ),
            trailing: Text(
              "${supportedCitiesResponse.data[i].deliveryPrice.split(".")[0]}",
              style: TextStyle(
                fontFamily: StringUtils.fontFamilyHKGrotesk,
              ),
            ),
          ),
          value: supportedCitiesResponse.data[i].name +
              " price" +
              "${supportedCitiesResponse.data[i].deliveryPrice}" +
              "id" +
              supportedCitiesResponse.data[i].id.toString(),
        ));
      }
      return true;
    } else {
      return false;
    }
  }

  Future<bool> checkIfUserLoggedIn() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String userToken = prefs.getString('userToken');
      String userSelectSupportedCity = prefs.getString('supportedCitySelected');

      if (userToken != null) {
        LoadingScreen.userToken = "Bearer " + userToken;
        if (userToken.contains("APPLE_VERIFICATION")) {
          BASE_URL = APPLE_BASE_URL;
        } else {
          BASE_URL = PRODUCTION_BASE_URL;
        }
        if (userSelectSupportedCity == null) {
          return null;
        } else {
          return true;
        }
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  int finishedRequests = 0;
  int contractsLength = 0;

  Future<bool> fetchStartInformation() async {
    try {
      bool userLoggedIn = await checkIfUserLoggedIn();
      if (userLoggedIn) {
        try {
          List responses;
          try {
            responses = await Future.wait([
              CartServices.getUserCart(),
              getStartScreenInformation(),
            ]);
          } catch (e) {
            return false;
          }

          if (responses[1] == null) {
            fetchStartInformation();
            return false;
          } else {
            if (responses[0] && responses[1]) {
              return true;
            } else {
              return false;
            }
          }
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

  static Future<bool> getStartScreenInformation() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String buildNumber = packageInfo.buildNumber;
    int lastSupported;
    int currentVersion;

    var response = await ApiProvider.sendRequest(
      url: GET_START_REQUEST,
      method: httpMethods.get,
    );
    if (response.statusCode == SUCCESS_CODE) {
      startRequest = startModelFromJson(jsonEncode(response.data));

      // Get Company Information.
      companyInformation = startRequest.company.original.data[1];
      imagePrefixUrl = startRequest.company.original.data[1].imageBaseUrl;

      // --------------------------------------------------------------------- //

      // Mobile Configuration

      androidShareUrl = startRequest.mobileAppConfigs.original.data[0].appStoreUrl;
      iOSShareUrl = startRequest.mobileAppConfigs.original.data[0].googlePlayUrl;

      if (Platform.isIOS) {
        lastSupported = int.parse(startRequest.mobileAppConfigs.original.data[0].iosLastSupportedVersion);
        currentVersion = int.parse(startRequest.mobileAppConfigs.original.data[0].iosCurrentVersion);

        LoadingScreen.updateUrl = startRequest.mobileAppConfigs.original.data[0].appStoreUrl;
      } else {
        lastSupported = int.parse(startRequest.mobileAppConfigs.original.data[0].androidLastSupportedVersion);
        currentVersion = int.parse(startRequest.mobileAppConfigs.original.data[0].androidCurrentVersion);
        LoadingScreen.updateUrl = startRequest.mobileAppConfigs.original.data[0].googlePlayUrl;
      }

      if (startRequest.mobileAppConfigs.original.data[0].id == 0) {
        serverMaintain = true;
      } else if (int.parse(buildNumber) < lastSupported) {
        updateRequired = true;
      } else if (int.parse(buildNumber) < currentVersion) {
        updateOptional = true;
      }

      // --------------------------------------------------------------------- //

      // Get Category
      categoryList.clear();
      final category = startRequest.category.original.data;
      for (int i = 0; i < category.length; i++) {
        if (category[i].warehouses.length > 0 && category[i].warehouses[0].pivot.isActive == "1") {
          categoryList.add(category[i]);
        }
      }

      categoryList.sort((a, b) {
        if ((int.parse(a.warehouses[0].pivot.priority)) > (int.parse(b.warehouses[0].pivot.priority)))
          return 1;
        else if ((int.parse(a.warehouses[0].pivot.priority) < (int.parse(b.warehouses[0].pivot.priority))))
          return -1;
        else
          return 0;
      });

      // --------------------------------------------------------------------- //

      // Get Banner
      bannerList.clear();
      bannerListNetwork.clear();
      DateTime now = DateTime.now();
      if (startRequest.banner.original.data.length == 0) {
        bannerListNetwork.add(Image(
          image: AdvImageCache(
            LoadingScreenServices.imagePrefixUrl + "slide3.png",
            useMemCache: true,
            diskCacheExpire: Duration(seconds: 0),
          ),
        ));
      } else {
        for (int i = 0; i < startRequest.banner.original.data.length; i++) {
          if (!startRequest.banner.original.data[i].expirationDate.isBefore(now)) {
            bannerList.add(AssetImage(startRequest.banner.original.data[i].imageFileName));

            bannerListNetwork.add(
              Image(
                image: AdvImageCache(
                  LoadingScreenServices.imagePrefixUrl + startRequest.banner.original.data[i].imageFileName,
                  useMemCache: true,
                  diskCacheExpire: Duration(seconds: 0),
                ),
              ),
            );
          }
        }
      }

      // --------------------------------------------------------------------- //
      // Get User

      userAddress.clear();
      //userFavoriteProducts.clear();
      myOrdersList.clear();

      userNumber = startRequest.user.original.data.phone;

      userAddress.addAll(startRequest.user.original.data.addresses);

      userOriginal = startRequest.user.original;

      myOrdersList.addAll(startRequest.orders.original.data.data);

      if (startRequest.user.original.data.isBanned == "1") {
        userBlocked = true;
      } else {
        userBlocked = false;
      }

      for (int i = 0; i < myOrdersList.length; i++) {
        if (myOrdersList[i].underUpdate == "1") {
          OrderServices.orderUnderUpdateIndex = i;

          OrderServices.deliverySupportedCityId = myOrdersList[i].supportedCityId.toString();

          OrderServices.updateOrderNote = myOrdersList[i].userNotes;

          DeliverToView.selectedIndex =
              myOrdersList.indexWhere((order) => order.addressId == myOrdersList[i].addressId);
        }
      }

      supportedCitiesList.clear();
      supportedCitiesListIntro.clear();

      final supportedCitiesResponse = startRequest.supportedCity.original;
      supportedCityOriginal = supportedCitiesResponse;

      for (int i = 0; i < supportedCitiesResponse.data.length; i++) {
        if (supportedCitiesResponse.data[i].id.toString() == startRequest.user.original.data.supportedCityId) {
          supportPhoneNumber = supportedCitiesResponse.data[i].supportPhoneNumber;

          if (supportedCitiesResponse.data[i].isActive == "2" ||
              (Platform.isIOS && startRequest.mobileAppConfigs.original.data[0].iosIsActive == "0") ||
              Platform.isAndroid && startRequest.mobileAppConfigs.original.data[0].androidIsActive == "0") {
            serverMaintain = true;
            if (Platform.isIOS && startRequest.mobileAppConfigs.original.data[0].iosIsActive == "0" ||
                Platform.isAndroid && startRequest.mobileAppConfigs.original.data[0].androidIsActive == "0") {
              systemMaintenanceMessages = startRequest.mobileAppConfigs.original.data[0].maintenanceMessages;
            } else {
              systemMaintenanceMessages = supportedCitiesResponse.data[i].maintenanceMessages;
            }
          } else {
            serverMaintain = false;
          }
        }
        for (int j = 0; j < userAddress.length; j++) {
          if (int.parse(userAddress[j].supportedCityId) == supportedCitiesResponse.data[i].id) {
            userAddress[j].supportedCityName = supportedCitiesResponse.data[i].name;
            userAddress[j].deliveryPrice =
                (int.parse(supportedCitiesResponse.data[i].deliveryPrice.toString().split(".")[0]));
          }
          if (userAddress[j].supportedCityName == null)
            userAddress[j].supportedCityName = "يرجى حذف و إضافة العنوان";
        }

        if (int.parse(supportedCitiesResponse.data[i].isActive) != 0) {
          supportedCitiesList.add(new DropdownMenuItem(
            child: Text(
              "${supportedCitiesResponse.data[i].name} - التوصيل : ${supportedCitiesResponse.data[i].deliveryPrice}",
              style: TextStyle(fontFamily: StringUtils.fontFamilyHKGrotesk),
            ),
            value: supportedCitiesResponse.data[i].name +
                " price" +
                "${supportedCitiesResponse.data[i].deliveryPrice}" +
                "id" +
                supportedCitiesResponse.data[i].id.toString(),
          ));
        }
      }
      return true;
    } else {
      return false;
    }
  }
}
