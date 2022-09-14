import 'package:http/http.dart' as http;
import 'package:kammun_app/core/core_importer.dart';
import 'package:kammun_app/views/products_attached_to_warehouse/services/added_products_services.dart';

class ProductsServices {
  static Future<bool> updateProductsDetails(
      {String bodyKey,
      String value,
      @required String productId,
      bool isForSubWarehouse = true,
      String subWarehouseId}) async {
    try {
      Map<String, String> body;

      body = {bodyKey: value};

      Response response;
      if (bodyKey == 'category_id') {
        response = await ApiProvider.sendRequest(
            url: addProductToCategory + productId, method: HttpMethods.post, body: jsonEncode(body));
      } else if (!isForSubWarehouse) {
        response =
            await ApiProvider.sendRequest(url: getProduct + productId, method: HttpMethods.put, body: jsonEncode(body));
      } else {
        response = await ApiProvider.sendRequest(
            url: updateSubWarehouseProducts + productId,
            method: HttpMethods.put,
            body: jsonEncode({'sub_warehouse_id': subWarehouseId, bodyKey: value}));
      }
      return response.statusCode == successCode;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> removeProductFromCategoryService(
      {@required String productId, @required String categoryId}) async {
    try {
      var response = await ApiProvider.sendRequest(
          queryParameters: {'category_id': categoryId},
          url: removeProductFromCategory + productId,
          method: HttpMethods.delete);
      return response.statusCode == successCode;
    } catch (e) {
      return false;
    }
  }

  static Future<int> addNewProducts(
      {String name,
      String quantity,
      String unit,
      String description,
      String categoryId,
      int price,
      int isActive,
      String supplierCode,
      String minThreshold,
      String priceFactor,
      bool autoActivation,
      @required int subWarehouseId,
      int barcode}) async {
    var productBody = {
      'name': name,
      'unit': unit,
      'is_in_facebook': 0,
      'description': description,
      'category_ids': categoryId,
      'quantity': quantity,
      'barcode': barcode
    };

    try {
      var response =
          await ApiProvider.sendRequest(url: getProduct, method: HttpMethods.post, body: jsonEncode(productBody));

      if (response.statusCode == successCode && response.data['success'] == true) {
        var subWarehouseBody = {
          'product_id': response.data['data']['id'],
          'sub_warehouse_id': subWarehouseId,
          'price': price,
          'is_featured': 0,
          'is_active': isActive,
          'priority': 20,
          'supplier_code': supplierCode,
          'min_threshold': 0,
          'increase_percentage': 0,
          'price_factor': priceFactor,
          'automatic_activation': autoActivation
        };
        bool result =
            await AddedProductsServices.attachProductsToSubWarehouseService(fullRequestBody: subWarehouseBody);
        if (result) {
          return int.parse(response.data['data']['id'].toString());
        }
        return null;
      }
      return 0;
    } catch (e) {
      return 0;
    }
  }

  static Future<bool> setImageToProducts({File image, int productId}) async {
    try {
      var headers = {'Authorization': LoadingScreen.userToken.length > 10 ? LoadingScreen.userToken : ''};
      var request = http.MultipartRequest('POST', Uri.parse(baseUrl + '/api/' + addImageToProduct));
      request.fields.addAll({'product_id': '$productId'});
      request.files.add(await http.MultipartFile.fromPath('image', image.path));
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();
      return response.statusCode == successCode;
    } catch (e) {
      Tools.logToConsole('exception');
      Tools.logToConsole(e.toString());
      return false;
    }
  }

  static Future<String> setBarcodeToProduct({@required int bareCode, @required int productId}) async {
    var requestBody = {'product_id': productId, 'barcode': bareCode};
    try {
      var response =
          await ApiProvider.sendRequest(url: productBarcode, method: HttpMethods.post, body: jsonEncode(requestBody));
      if (response.statusCode == successCode) {
        Barcode barcode = barcodeFromJson(jsonEncode(response.data['data']));
        return barcode.barcode;
      }
      return 'error';
    } catch (e) {
      return 'error';
    }
  }

  static Future<List<ProductData>> searchProductByBarcodeService({@required String bareCode}) async {
    try {
      var response = await ApiProvider.sendRequest(url: searchProductByBarcode + bareCode, method: HttpMethods.get);
      if (response.statusCode == successCode) return syncCartFromJson(jsonEncode(response.data['data']));
      return null;
    } catch (e) {
      return null;
    }
  }

  static Future<List<ProductData>> checkProductBarcodeService({@required String bareCode}) async {
    try {
      var response = await ApiProvider.sendRequest(url: checkProductBarcode + bareCode, method: HttpMethods.get);
      if (response.statusCode == successCode) return syncCartFromJson(jsonEncode(response.data['data']));
      return null;
    } catch (e) {
      return null;
    }
  }

  static Future<bool> deleteBarcode({@required String bareCodeId}) async {
    try {
      var response = await ApiProvider.sendRequest(url: productBarcode + bareCodeId, method: HttpMethods.delete);
      return response.statusCode == successCode;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> deleteProductService(String productId) async {
    try {
      var response = await ApiProvider.sendRequest(url: deleteProduct + productId, method: HttpMethods.delete);
      return response.statusCode == successCode;
    } catch (e) {
      return false;
    }
  }
}
