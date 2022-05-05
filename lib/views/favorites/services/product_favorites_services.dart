import 'dart:convert';

import 'package:kammun_app/core/core_importer.dart';
import 'package:kammun_app/models/products_categories_model.dart';

class FavoritesProductsServices {
  static int lastPageNumber = 1;
  static bool theEndOfFavoraites = false;
  static Future<ProductResponse> getUserFavorites({int pageNumber}) async {
    var response = await ApiProvider.sendRequest(
      url: favoritesProducts,
      method: HttpMethods.get,
      queryParameters: {"page": pageNumber},
    );
    if (response.statusCode == successCode && response.data["success"]) {
      final favoraitesProducts = categoryProductFromJson(jsonEncode(response.data));
      return favoraitesProducts.data;
    } else if (response.statusCode == successCode &&
        response.data["success"] == false &&
        response.data["reason"].toString().contains("no favorite products")) {
      return ProductResponse(data: []);
    } else {
      return null;
    }
  }
}
