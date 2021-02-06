// import 'dart:async';
// import 'dart:convert';

// import 'package:kammun_app/core/api/api_URLs.dart';
// import 'package:kammun_app/core/api/api_provider.dart';
// import 'package:kammun_app/core/errors/error_types.dart';
// import 'package:kammun_app/models/getCategories.dart';
// import 'package:kammun_app/views/cart/services/cart_services.dart';
// import 'package:kammun_app/views/loading/Loading.dart';

// import 'banner_services.dart';
// import 'supported_cities_services.dart';
// import 'user_services.dart';

// class CategoryServices {
//   static List<CategoryData> categoryList = List<CategoryData>();

//   Future<bool> getCategories({StreamController<int> streamController}) async {
//     var response = await ApiProvider.sendRequest(
//       url: GET_CATEGORY,
//       method: httpMethods.get,
//     );

//     if (response.statusCode == SUCCESS_CODE) {
//       categoryList.clear();

//       final category = categoryFromJson(jsonEncode(response.data));

//       categoryList.addAll(category.data);

//       categoryList.sort((a, b) {
//         if ((a.priority) > (b.priority))
//           return 1;
//         else if ((a.priority) < (b.priority))
//           return -1;
//         else
//           return 0;
//       });
//       streamController.add(200);

//       return true;
//     } else {
//       return false;
//     }
//   }
// }
