// import 'dart:async';
// import 'dart:convert';

// import 'package:cache_image/cache_image.dart';
// import 'package:flutter/material.dart'; 
import 'package:kammun_app/utils/tools.dart';
// import 'package:kammun_app/core/api/api_URLs.dart';
// import 'package:kammun_app/core/api/api_provider.dart';
// import 'package:kammun_app/core/errors/error_types.dart';
// import 'package:kammun_app/models/banner.dart';
// import 'LoadingServices.dart';

// class BannerServices {
//   static List<AssetImage> bannerList = List<AssetImage>();
//   static List<FadeInImage> bannerListNetwork = List<FadeInImage>();

//   static Future<bool> getBanner(
//       {StreamController<int> streamController}) async {
//     //  Tools.logToConsole("------------ GET BANNER --------------");

//     DateTime now = DateTime.now();

//     var response = await ApiProvider.sendRequest(
//       url: GET_BANNER,
//       method: httpMethods.get,
//     );

//     if (response.statusCode == SUCCESS_CODE) {
//       bannerList.clear();
//       final bannerResponse = bannerFromJson(jsonEncode(response.data));

//       for (int i = 0; i < bannerResponse.data.length; i++) {
//         if (!bannerResponse.data[i].expirationDate.isBefore(now)) {
//           bannerList.add(AssetImage(bannerResponse.data[i].imageFileName));

//           bannerListNetwork.add(
//             FadeInImage(
//               image: CacheImage(LoadingScreenServices.imagePrefixUrl +
//                   bannerResponse.data[i].imageFileName),
//               // width: MediaQuery.of(context).size.width,
//               fadeInDuration: const Duration(seconds: 1),
//               // fadeInCurve: Curves.fastOutSlowIn,
//               fadeInCurve: Curves.fastOutSlowIn,
//               placeholder: AssetImage("assets/Logo_holder.jpg"),
//               fit: BoxFit.cover,
//             ),
//           );
//         }
//       }
//       streamController.add(200);

//       return true;
//     } else {
//       Tools.logToConsole("------------ ERROR GETING BANNER INFORMATION --------------");
//       return false;
//     }
//   }
// }
