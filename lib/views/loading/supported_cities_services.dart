// import 'dart:async';
// import 'dart:convert';

// import 'package:flutter/material.dart'; 
import 'package:kammun_app/utils/tools.dart';
// import 'package:kammun_app/core/api/api_URLs.dart';
// import 'package:kammun_app/core/api/api_provider.dart';
// import 'package:kammun_app/core/errors/error_types.dart';
// import 'package:kammun_app/models/supportedCities.dart';
// import 'package:kammun_app/utils/utils_importer.dart';
// import 'package:kammun_app/views/loading/user_services.dart';

// class SupportedCitiesServices {
//   static List<DropdownMenuItem> supportedCitiesList = List<DropdownMenuItem>();

//   static Future<bool> getSupportedCities(
//       {StreamController<int> streamController}) async {
//     var response = await ApiProvider.sendRequest(
//       url: GET_SUPPORTED_CITY,
//       method: httpMethods.get,
//     );

//     if (response.statusCode == SUCCESS_CODE) {
//       supportedCitiesList.clear();
//       final supportedCitiesResponse =
//           supportedCitiesFromJson(jsonEncode(response.data));

//       for (int i = 0; i < supportedCitiesResponse.data.length; i++) {
//         for (int j = 0; j < UserServices.userAddress.length; j++) {
//           Tools.logToConsole("************************");
//           Tools.logToConsole(UserServices.userAddress[j].supportedCityId.toString() +
//               " : " +
//               supportedCitiesResponse.data[i].id.toString());
//           if (UserServices.userAddress[j].supportedCityId.toString() ==
//               supportedCitiesResponse.data[i].id.toString()) {
//             UserServices.userAddress[j].supportedCityName =
//                 supportedCitiesResponse.data[i].name;
//             UserServices.userAddress[j].deliveryPrice =
//                 (supportedCitiesResponse.data[i].deliveryPrice);
//           }
//           if (UserServices.userAddress[j].supportedCityName == null)
//             UserServices.userAddress[j].supportedCityName =
//                 "يرجى حذف و إضافة العنوان";
//         }
//         Tools.logToConsole("################ SUPPORTED CITIES ####################");
//         Tools.logToConsole(supportedCitiesResponse.data[i].id);

//         supportedCitiesList.add(new DropdownMenuItem(
//           child: Text(
//             "${supportedCitiesResponse.data[i].name} - التوصيل : ${supportedCitiesResponse.data[i].deliveryPrice}",
//             style: TextStyle(fontFamily: UtilsImporter().stringUtils.HKGrotesk),
//           ),
//           value: supportedCitiesResponse.data[i].name +
//               " price" +
//               "${supportedCitiesResponse.data[i].deliveryPrice}" +
//               "id" +
//               supportedCitiesResponse.data[i].id.toString(),
//         ));
//         Tools.logToConsole("The dropdownList value:" + supportedCitiesResponse.data[i].name);
//       }
//       streamController.add(200);
//       return true;
//     } else {
//       Tools.logToConsole("------------ ERROR GETING SUPPORTED CITY --------------");
//       return false;
//     }
//   }
// }
