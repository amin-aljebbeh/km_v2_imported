import 'dart:convert';

import 'package:kammun_app/core/core_importer.dart';
import 'package:kammun_app/models/productsCategoriesModel.dart';
import 'package:kammun_app/views/loading/LoadingServices.dart';

class FavoraitesProductsServices {
  static int lastPageNumber = 1;
  static bool theEndOfFavoraites = false;
  static Future<ProductResponse> getUserFavoraites({int pageNumber}) async {
    var response = await ApiProvider.sendRequest(
      url: FAVORAITES_PRODUCTS,
      method: httpMethods.get,
      queryParameters: {"page": pageNumber},
    );
    if (response.statusCode == SUCCESS_CODE && response.data["success"]) {
      final favoraitesProducts = categoryProductFromJson(jsonEncode(response.data));
      return favoraitesProducts.data;
    } else if (response.statusCode == SUCCESS_CODE &&
        response.data["success"] == false &&
        response.data["reason"].toString().contains("no favorite products")) {
      return new ProductResponse(data: null);
    } else {
      return null;
    }
  }
}
