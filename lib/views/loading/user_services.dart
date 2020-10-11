// import 'dart:async';
// import 'dart:convert';

// import 'package:kammun_app/core/api/api_URLs.dart';
// import 'package:kammun_app/core/api/api_provider.dart';
// import 'package:kammun_app/core/errors/error_types.dart';
// import 'package:kammun_app/models/userModel.dart';

// class UserServices {
//   static List<Address> userAddress = List<Address>();
//   static List<Product> userFavoriteProducts = List<Product>();
//   static List<Order> myOrdersList = new List<Order>();
//   static String userNumber = "لم تقم بتسجيل رقم";

//   static Future<bool> getUser({StreamController<int> streamController}) async {
//     // print("------------------ GET USER INFORMATION --------------------");

//     var response = await ApiProvider.sendRequest(
//       url: GET_USER,
//       method: httpMethods.get,
//     );

//     if (response.statusCode == SUCCESS_CODE) {
//       userAddress.clear();
//       userFavoriteProducts.clear();
//       myOrdersList.clear();
//       final userInformation = userSelfFromJson(jsonEncode(response.data));

//       userNumber = userInformation.data.phone;
//       userAddress.addAll(userInformation.data.addresses);

//       userFavoriteProducts.addAll(userInformation.data.userFavoriteProducts);
//       userAddress.sort((a, b) {
//         if ((a.id) < (b.id))
//           return 1;
//         else if ((a.id) > (b.id))
//           return -1;
//         else
//           return 0;
//       });

//       myOrdersList.addAll(userInformation.data.orders);
//       myOrdersList.sort((a, b) {
//         if (a.id < b.id)
//           return 1;
//         else if (a.id > b.id)
//           return -1;
//         else
//           return 0;
//       });

//       streamController.add(200);
//       return true;
//     } else {
//       print("------------ ERROR GET USER INFORMATION --------------");
//       return false;
//     }
//   }
// }
