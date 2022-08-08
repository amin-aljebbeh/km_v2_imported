import '../../../core/core_importer.dart';

class ProductsServices {
  static Future<List<ProductData>> getCategory({String categoryId, int pageNumber}) async {
    try {
      var response = await ApiProvider.sendRequest(
          url: category + categoryId, method: HttpMethods.get, queryParameters: {'page': pageNumber});
      if (response.statusCode == successCode) {
        if (!response.data['success'] && response.data['reason'] == 'No results') {
          return [];
        } else {
          return categoryProductFromJson(jsonEncode(response.data)).data.data;
        }
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  static Future<List<ProductData>> searchProduct({String query, int pageNumber}) async {
    try {
      var response = await ApiProvider.sendRequest(
        url: searchProducts + query,
        method: HttpMethods.get,
        queryParameters: {'page': pageNumber},
      );
      if (response.statusCode == successCode) {
        if (!response.data['success'] && response.data['reason'] == 'No results') {
          return [];
        } else {
          return categoryProductFromJson(jsonEncode(response.data)).data.data;
        }
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  static Future<List<ProductData>> getUserFavorites({int pageNumber}) async {
    try {
      var response = await ApiProvider.sendRequest(
          url: favoritesProducts, method: HttpMethods.get, queryParameters: {'page': pageNumber});
      if (response != null) {
        if (response.statusCode == successCode && response.data['success']) {
          final favoritesProducts = categoryProductFromJson(jsonEncode(response.data));
          return favoritesProducts.data.data;
        } else if (response.statusCode == successCode &&
            response.data['success'] == false &&
            response.data['reason'].toString().contains('no favorite products')) {
          return [];
        } else {
          return null;
        }
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  static Future<List<ProductData>> getBarcodeProducts({String code}) async {
    try {
      var response = await ApiProvider.sendRequest(url: searchProductByBarcode + code, method: HttpMethods.get);
      if (response != null) {
        if (response.statusCode == successCode) {
          if (!response.data['success'] && response.data['reason'] == 'No results') {
            return [];
          } else {
            return syncCartFromJson(jsonEncode(response.data['data']));
          }
        } else {
          return null;
        }
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  static Future<List<ProductData>> getMyAlertProducts({int pageNumber}) async {
    try {
      var response = await ApiProvider.sendRequest(
          url: getMyAlertProductsList, method: HttpMethods.get, queryParameters: {'page': pageNumber});
      if (response != null) {
        if (response.statusCode == successCode) {
          if (!response.data['success'] && response.data['reason'] == 'No results') {
            return [];
          } else {
            return categoryProductFromJson(jsonEncode(response.data)).data.data;
          }
        } else {
          return null;
        }
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}
