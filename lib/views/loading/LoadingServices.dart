import 'dart:async';
import 'dart:convert';

import 'package:cache_image/cache_image.dart';
import 'package:flutter/material.dart'; 
import 'package:kammun_app/utils/tools.dart';
import 'package:kammun_app/core/api/api_URLs.dart';
import 'package:kammun_app/core/api/api_provider.dart';
import 'package:kammun_app/core/errors/error_types.dart';
import 'package:kammun_app/models/productsCategoriesModel.dart';
import 'package:kammun_app/models/start_model.dart';
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
  static List<FadeInImage> bannerListNetwork = List<FadeInImage>();
  // static List<DeliveryMethodOriginalData> deliveryMethodsList =
  //     new List<DeliveryMethodOriginalData>();
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
  static List<DropdownMenuItem> supportedCitiesListIntro =
      List<DropdownMenuItem>();

  // -------------------------------------------------------//

  // User Veriables
  static List<Address> userAddress = List<Address>();
  static List<ProductData> userFavoriteProducts = List<ProductData>();
  static List<OrdersOriginalData> myOrdersList = new List<OrdersOriginalData>();
  static String userNumber = "لم تقم بتسجيل رقم";

  // -------------------------------------------------------//

  /// -------- selecrted supported city information ------- ///

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
      final supportedCitiesResponse =
          supportedCityOriginalFromJson(jsonEncode(response.data));
      supportedCityOriginal = supportedCitiesResponse;

      supportedCitiesListIntro.clear();
      Tools.logToConsole(supportedCitiesResponse.data.length);
      for (int i = 0; i < supportedCitiesResponse.data.length; i++) {
        supportedCitiesListIntro.add(new DropdownMenuItem(
          child: ListTile(
            //isThreeLine: true,
            leading: Icon(
              Icons.pin_drop,
              color: UtilsImporter().colorUtils.kmColors,
            ),
            title: Text(
              '${supportedCitiesResponse.data[i].name} ',
              style: TextStyle(
                fontFamily: UtilsImporter().stringUtils.HKGrotesk,
              ),
            ),
            trailing: Text(
              "${supportedCitiesResponse.data[i].deliveryPrice.split(".")[0]}",
              style: TextStyle(
                fontFamily: UtilsImporter().stringUtils.HKGrotesk,
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

  Future<bool> checkIfUserloddedIn() async {
    Tools.logToConsole("--------- Checking User Token ---------- ");
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String userToken = prefs.getString('userToken');
      Tools.logToConsole("user token is :");
      // prefs.remove('userToken');
      Tools.logToConsole(userToken);
      if (userToken != null) {
        LoadingScreen.user_token = "Bearer " + userToken;
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

  Future<bool> featchStartInformation() async {
    try {
      Tools.logToConsole("------------- get Start Screen Information returns ---------");
      bool userLoggedIn = await checkIfUserloddedIn();
      if (userLoggedIn) {
        try {
          List responses;
          try {
            responses = await Future.wait([
              CartServices.getUserCart(),
              getStartScreenInformation(),
            ]);
          } catch (e) {
            Tools.logToConsole("--------- error call -----");
            Tools.logToConsole(e.toString());
            return false;
          }
          Tools.logToConsole("TTTTTTTTTTTTT : " + responses[0].toString());
          Tools.logToConsole("BBBBBBBBBBBBBB : " + responses[1].toString());
          if (responses[1] == null) {
            featchStartInformation();
          } else {
            if (responses[0] && responses[1]) {
              return true;
            } else {
              return false;
            }
          }

          // bool everyThingGood = await getStartScreenInformation(
          //     streamController: streamController);
          // if (everyThingGood) {
          //   return true;
          // } else {
          //   return false;
          // }
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

  static Future<bool> getStartScreenInformation() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String buildNumber = packageInfo.buildNumber;
    int lastSupported;
    int currenVersion;
    Tools.logToConsole("Sending Start Request");
    var response = await ApiProvider.sendRequest(
      url: GET_START_REQUEST,
      method: httpMethods.get,
    );
    if (response.statusCode == SUCCESS_CODE) {
      startRequest = startModelFromJson(jsonEncode(response.data));

      // Tools.logToConsole(response.data);

      // Get Company Information.
      companyInformation = startRequest.company.original.data[1];
      Tools.logToConsole("======= Get Company Information DONE =======");
      String oldBaseUrl = BaseUrl;
      BaseUrl = companyInformation.baseUrl;
      if (oldBaseUrl != BaseUrl) {
        return null;
      }
      // Get Image Url Prefix.
      imagePrefixUrl = startRequest.company.original.data[1].imageBaseUrl;
      Tools.logToConsole("======= Get Image Url Prefix DONE =======");

      // --------------------------------------------------------------------- //

      // Mobile Configuration

      androidShareUrl =
          startRequest.mobileAppConfigs.original.data[0].appStoreUrl;
      iOSShareUrl =
          startRequest.mobileAppConfigs.original.data[0].googlePlayUrl;

      if (Platform.isIOS) {
        lastSupported = int.parse(startRequest
            .mobileAppConfigs.original.data[0].iosLastSupportedVersion);
        currenVersion = int.parse(
            startRequest.mobileAppConfigs.original.data[0].iosCurrentVersion);

        LoadingScreen.updateUrl =
            startRequest.mobileAppConfigs.original.data[0].appStoreUrl;
      } else {
        lastSupported = int.parse(startRequest
            .mobileAppConfigs.original.data[0].androidLastSupportedVersion);
        currenVersion = int.parse(startRequest
            .mobileAppConfigs.original.data[0].androidCurrentVersion);
        LoadingScreen.updateUrl =
            startRequest.mobileAppConfigs.original.data[0].googlePlayUrl;
      }

      Tools.logToConsole("======= Mobile Configuration DONE =======");

      // Tools.logToConsole("------ the app version -------");
      // Tools.logToConsole(int.parse(buildNumber));

      if (startRequest.mobileAppConfigs.original.data[0].id == 0) {
        serverMaintain = true;
      } else if (int.parse(buildNumber) < lastSupported) {
        updateRequired = true;
      } else if (int.parse(buildNumber) < currenVersion) {
        updateOptional = true;
      }

      Tools.logToConsole("======= DONE Mobile Compaiesion =======");

      // --------------------------------------------------------------------- //

      // Get Category
      categoryList.clear();
      final category = startRequest.category.original.data;
      for (int i = 0; i < category.length; i++) {
        if (category[i].warehouses.length > 0 &&
            category[i].warehouses[0].pivot.isActive == "1") {
          categoryList.add(category[i]);
        }
      }
      //  categoryList.addAll(category);

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
      Tools.logToConsole("======= Get Category DONE =======");

      // Tools.logToConsole("========== The Categories ===========");

      // Tools.logToConsole(categoryList);

      // --------------------------------------------------------------------- //

      // Get Banner
      bannerList.clear();
      bannerListNetwork.clear();
      DateTime now = DateTime.now();
      if (startRequest.banner.original.data.length == 0) {
        bannerListNetwork.add(
          FadeInImage(
            image:
                CacheImage(LoadingScreenServices.imagePrefixUrl + "slide3.png"),
            // width: MediaQuery.of(context).size.width,
            fadeInDuration: const Duration(seconds: 1),
            // fadeInCurve: Curves.fastOutSlowIn,
            fadeInCurve: Curves.fastOutSlowIn,
            placeholder: AssetImage("assets/Logo_holder.jpg"),
            fit: BoxFit.cover,
          ),
        );
      } else {
        for (int i = 0; i < startRequest.banner.original.data.length; i++) {
          if (!startRequest.banner.original.data[i].expirationDate
              .isBefore(now)) {
            bannerList.add(
                AssetImage(startRequest.banner.original.data[i].imageFileName));

            bannerListNetwork.add(
              FadeInImage(
                image: CacheImage(LoadingScreenServices.imagePrefixUrl +
                    startRequest.banner.original.data[i].imageFileName),
                // width: MediaQuery.of(context).size.width,
                fadeInDuration: const Duration(seconds: 1),
                // fadeInCurve: Curves.fastOutSlowIn,
                fadeInCurve: Curves.fastOutSlowIn,
                placeholder: AssetImage("assets/Logo_holder.jpg"),
                fit: BoxFit.cover,
              ),
            );
          }
        }
      }

      Tools.logToConsole("======= Get Banner DONE =======");

      // --------------------------------------------------------------------- //
      // Get User

      userAddress.clear();
      //userFavoriteProducts.clear();
      myOrdersList.clear();

      userNumber = startRequest.user.original.data.phone;

      Tools.logToConsole("======= Get User Number DONE =======");

      // Tools.logToConsole("User Number ");
      // Tools.logToConsole(userNumber);
      userAddress.addAll(startRequest.user.original.data.addresses);

      userOriginal = startRequest.user.original;

      Tools.logToConsole("======= Get User Address DONE =======");

      myOrdersList.addAll(startRequest.orders.original.data.data);

      if (startRequest.user.original.data.isBanned == "1") {
        userBlocked = true;
      } else {
        userBlocked = false;
      }

      Tools.logToConsole("======= Get User Order DONE =======");

      for (int i = 0; i < myOrdersList.length; i++) {
        if (myOrdersList[i].underUpdate == "1") {
          OrderServices.orderUnderUpdateIndex = i;

          OrderServices.delivery_supported_City_id =
              myOrdersList[i].supportedCityId.toString();

          OrderServices.updateOrderNote = myOrdersList[i].userNotes;

          DeliverToView.selectedIndex = myOrdersList.indexWhere(
              (order) => order.addressId == myOrdersList[i].addressId);
        }
      }

      Tools.logToConsole("======= Check if Order Under Update DONE =======");

      // -------------------------------------------------------------------- //
      // Get Delivery Methods

      // deliveryMethodsList.clear();
      // for (int i = 0;
      //     i < startRequest.deliveryMethod.original.data.length;
      //     i++) {
      //   if (startRequest.deliveryMethod.original.data[i].isActive == "1") {
      //     deliveryMethodsList.add(startRequest.deliveryMethod.original.data[i]);
      //   }
      // }
      // deliveryMethodsList = startRequest.deliveryMethod.original.data;

      Tools.logToConsole("======= Get Delivery method DONE =======");

      // --------------------------------------------------------------------- //
      // Get Supported Cities

      supportedCitiesList.clear();
      supportedCitiesListIntro.clear();

      final supportedCitiesResponse = startRequest.supportedCity.original;
      Tools.logToConsole("======= Get Supported City DONE =======");
      supportedCityOriginal = supportedCitiesResponse;

      for (int i = 0; i < supportedCitiesResponse.data.length; i++) {
        if (supportedCitiesResponse.data[i].id.toString() ==
            startRequest.user.original.data.supportedCityId) {
          supportPhoneNumber =
              supportedCitiesResponse.data[i].supportPhoneNumber;

          if (supportedCitiesResponse.data[i].isActive == "0" ||
              (Platform.isIOS &&
                  startRequest.mobileAppConfigs.original.data[0].iosIsActive ==
                      "0") ||
              Platform.isAndroid &&
                  startRequest
                          .mobileAppConfigs.original.data[0].androidIsActive ==
                      "0") {
            serverMaintain = true;
            if (Platform.isIOS &&
                    startRequest
                            .mobileAppConfigs.original.data[0].iosIsActive ==
                        "0" ||
                Platform.isAndroid &&
                    startRequest.mobileAppConfigs.original.data[0]
                            .androidIsActive ==
                        "0") {
              systemMaintenanceMessages = startRequest
                  .mobileAppConfigs.original.data[0].maintenanceMessages;
            } else {
              systemMaintenanceMessages =
                  supportedCitiesResponse.data[i].maintenanceMessages;
            }
          } else {
            serverMaintain = false;
          }
        }
        for (int j = 0; j < userAddress.length; j++) {
          if (int.parse(userAddress[j].supportedCityId) ==
              supportedCitiesResponse.data[i].id) {
            userAddress[j].supportedCityName =
                supportedCitiesResponse.data[i].name;
            userAddress[j].deliveryPrice = (int.parse(supportedCitiesResponse
                .data[i].deliveryPrice
                .toString()
                .split(".")[0]));
          }
          if (userAddress[j].supportedCityName == null)
            userAddress[j].supportedCityName = "يرج�� حذف و إضافة العنوان";
        }

        // Tools.logToConsole("################ SUPPORTED CITIES ####################");

        supportedCitiesList.add(new DropdownMenuItem(
          child: Text(
            "${supportedCitiesResponse.data[i].name} - التوصيل : ${supportedCitiesResponse.data[i].deliveryPrice}",
            style: TextStyle(fontFamily: UtilsImporter().stringUtils.HKGrotesk),
          ),
          value: supportedCitiesResponse.data[i].name +
              " price" +
              "${supportedCitiesResponse.data[i].deliveryPrice}" +
              "id" +
              supportedCitiesResponse.data[i].id.toString(),
        ));
        Tools.logToConsole("The dropdownList value:" + supportedCitiesResponse.data[i].name);
      }
      return true;
    } else {
      Tools.logToConsole("------------ ERROR GET COMPANY INFORMATION --------------");
      Tools.logToConsole(response.statusCode.toString());
      return false;
    }
  }
}
