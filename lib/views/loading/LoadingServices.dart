import 'dart:async';
import 'dart:convert';

import 'package:cache_image/cache_image.dart';
import 'package:flutter/material.dart';
import 'package:kammun_app/core/api/api_URLs.dart';
import 'package:kammun_app/core/api/api_provider.dart';
import 'package:kammun_app/core/errors/error_types.dart';
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
  static List<DeliveryMethodOriginalData> deliveryMethodsList =
      new List<DeliveryMethodOriginalData>();
  // Mobile Configuration variables
  static String updateUrl = "";
  static String androidShareUrl = "";
  static String iOSShareUrl = "";
  static bool serverMaintain = false;
  static bool updateRequired = false;
  static bool updateOptional = false;
  static bool checkIfLoggedIn = false;
  // -------------------------------------------------------//

  // Supported City variables

  static List<DropdownMenuItem> supportedCitiesList = List<DropdownMenuItem>();
  static List<DropdownMenuItem> supportedCitiesListIntro =
      List<DropdownMenuItem>();

  // -------------------------------------------------------//

  // User Veriables
  static List<Address> userAddress = List<Address>();
  static List<OrderProducts> userFavoriteProducts = List<OrderProducts>();
  static List<OrdersOriginalData> myOrdersList = new List<OrdersOriginalData>();
  static String userNumber = "لم تقم بتسجيل رقم";

  // -------------------------------------------------------//

  Future<bool> getSupportedCity() async {
    var response = await ApiProvider.sendRequest(
      url: GET_SUPPORTED_CITIES,
      method: httpMethods.get,
    );
    if (response.statusCode == SUCCESS_CODE) {
      final supportedCitiesResponse =
          supportedCityOriginalFromJson(jsonEncode(response.data));
      supportedCitiesList.clear();
      print(supportedCitiesResponse.data.length);
      for (int i = 0; i < supportedCitiesResponse.data.length; i++) {
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
        print("The dropdownList value:" + supportedCitiesResponse.data[i].name);
      }
      return true;
    } else {
      return false;
    }
  }

  Future<bool> checkIfUserloddedIn() async {
    print("--------- Checking User Token ---------- ");
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String userToken = prefs.getString('userToken');
      print("user token is :");
      print(userToken);
      if (userToken != null) {
        LoadingScreen.user_token = "Bearer " + userToken;
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<bool> featchStartInformation() async {
    try {
      bool everyThingGood = await getStartScreenInformation();
      return everyThingGood;

      // if (true) {
      //   try {
      //     bool everyThingGood = await getStartScreenInformation();
      //     print("------ every thing good");
      //     print(everyThingGood);
      //     if (everyThingGood) {
      //       return true;
      //     } else {
      //       return false;
      //     }
      //   } catch (e) {
      //     print(e.toString());
      //     return false;
      //   }
      // }
      // return false;
    } catch (e) {
      print("Error While checking user if loggedIn");
      print(e.toString());
      return false;
    }
  }

  static Future<bool> getStartScreenInformation() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String buildNumber = packageInfo.buildNumber;
    int lastSupported;
    int currenVersion;
    print("Sending Start Request");
    var response = await ApiProvider.sendRequest(
      url: GET_START_REQUEST,
      method: httpMethods.get,
    );
    if (response.statusCode == SUCCESS_CODE) {
      startRequest = startModelFromJson(jsonEncode(response.data));

      print(response.data);

      // Get Company Information.
      companyInformation = startRequest.company.original.data[0];

      // Get Image Url Prefix.
      imagePrefixUrl = startRequest.company.original.data[0].imageBaseUrl;

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

      // print("------ the app version -------");
      // print(int.parse(buildNumber));

      if (startRequest.mobileAppConfigs.original.data[0].id == 0) {
        serverMaintain = true;
      } else if (int.parse(buildNumber) < lastSupported) {
        updateRequired = true;
      } else if (int.parse(buildNumber) < currenVersion) {
        updateOptional = true;
      }

      // --------------------------------------------------------------------- //

      // Get Category
      categoryList.clear();
      final category = startRequest.category.original.data;
      categoryList.addAll(category);

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

      print("========== The Categories ===========");

      print(categoryList);

      // --------------------------------------------------------------------- //

      // Get Banner
      bannerList.clear();
      bannerListNetwork.clear();
      DateTime now = DateTime.now();
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
      print("The Banner List ");
      print(bannerList);

      // --------------------------------------------------------------------- //
      // Get User

      userAddress.clear();
      //userFavoriteProducts.clear();
      myOrdersList.clear();

      userNumber = startRequest.user.original.data.phone;

      print("User Number ");
      print(userNumber);
      userAddress.addAll(startRequest.user.original.data.addresses);

      print("User Address ");
      print(userAddress);

      // userFavoriteProducts
      //     .addAll(startRequest.user.original.data.userFavoriteProducts);
      // userAddress.sort((a, b) {
      //   if ((a.id) < (b.id))
      //     return 1;
      //   else if ((a.id) > (b.id))
      //     return -1;
      //   else
      //     return 0;
      // });

      myOrdersList.addAll(startRequest.orders.original.data.data);
      myOrdersList.sort((a, b) {
        if (a.id < b.id)
          return 1;
        else if (a.id > b.id)
          return -1;
        else
          return 0;
      });

      if (myOrdersList.indexWhere((order) => order.underUpdate == "1") !=
          null) {
        OrderServices.orderUnderUpdateIndex =
            myOrdersList.indexWhere((order) => order.underUpdate == "1");
        OrderServices.delivery_supported_City_id =
            myOrdersList[OrderServices.orderUnderUpdateIndex]
                .supportedCityId
                .toString();
        OrderServices.updateOrderNote =
            myOrdersList[OrderServices.orderUnderUpdateIndex].userNotes;

        DeliverToView.selectedIndex = myOrdersList.indexWhere((order) =>
            order.addressId ==
            myOrdersList[OrderServices.orderUnderUpdateIndex].addressId);

        //int.parse(LoadingScreenServices.deliveryMethodsList[selectedIndex].price.split(".")[0])
        //LoadingScreenServices.userAddress[DeliverToView.selectedIndex].deliveryPrice
      }

      // -------------------------------------------------------------------- //
      // Get Delivery Methods

      deliveryMethodsList.clear();
      deliveryMethodsList = startRequest.deliveryMethod.original.data;
      // deliveryMethodsList.sort((a, b) {
      //   if (a.id < b.id)
      //     return 1;
      //   else if (a.id > b.id)
      //     return -1;
      //   else
      //     return 0;
      // });
      print(" deliveryMethodsList ");
      print(deliveryMethodsList);

      // --------------------------------------------------------------------- //
      // Get Supported Cities

      supportedCitiesList.clear();
      supportedCitiesListIntro.clear();

      final supportedCitiesResponse = startRequest.supportedCity.original;
      for (int i = 0; i < supportedCitiesResponse.data.length; i++) {
        for (int j = 0; j < userAddress.length; j++) {
          print("************************");
          print(userAddress[j].supportedCityId.toString() +
              " : " +
              supportedCitiesResponse.data[i].id.toString());
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
            userAddress[j].supportedCityName = "يرجى حذف و إضافة العنوان";
        }

        print("################ SUPPORTED CITIES ####################");
        print(supportedCitiesResponse.data[i].id);

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
        print("The dropdownList value:" + supportedCitiesResponse.data[i].name);

        await CartServices.getUserCart();
        return true;
      }
    } else {
      print("------------ ERROR GET COMPANY INFORMATION --------------");
      print(response.statusCode.toString());
      return false;
    }
    return false;
  }
}
