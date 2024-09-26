import 'package:http/http.dart' as http;
import 'package:kammun_app/core/core_importer.dart';

import '../../products/domain/entities/product_entity.dart';

class ProductsServices {
  static Future<bool> updateProductsDetails({
    String bodyKey,
    String value,
    @required String productId,
    bool isForSubWarehouse = true,
    String subWarehouseId,
  }) async {
    try {
      Map<String, String> body;

      body = {bodyKey: value};

      Response response;
      if (bodyKey == 'category_id') {
        response = await ApiProvider.sendRequest(
            url: addProductToCategory + productId, method: HttpMethods.post, body: jsonEncode(body));
      } else if (!isForSubWarehouse) {
        response =
            await ApiProvider.sendRequest(url: productApi + productId, method: HttpMethods.put, body: jsonEncode(body));
      } else {
        response = await ApiProvider.sendRequest(
            url: updateSubWarehouseProductsApi + productId,
            method: HttpMethods.put,
            body: jsonEncode({'sub_warehouse_id': subWarehouseId, bodyKey: value}));
      }
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
      int categoryId,
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
          await ApiProvider.sendRequest(url: productApi, method: HttpMethods.post, body: jsonEncode(productBody));

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
        bool result = await ProductsServices.attachProductsToSubWarehouseService(fullRequestBody: subWarehouseBody);
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

//todo clean
  static Future<bool> setImageToProducts({File image, int productId}) async {
    try {
      var headers = {'Authorization': LoadingScreen.userToken.length > 10 ? LoadingScreen.userToken : ''};
      var request = http.MultipartRequest('POST', Uri.parse(baseUrl + '/api/' + productImageApi));
      request.fields.addAll({'product_id': '$productId'});
      request.files.add(await http.MultipartFile.fromPath('image', image.path));
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();
      return response.statusCode == successCode;
    } catch (e) {
      return false;
    }
  }

//todo clean

  static Future<bool> unAttachProductsToSubWarehouseService({String productsId, String subWarehouse}) async {
    try {
      Map<String, int> body = {'sub_warehouse_id': int.parse(subWarehouse)};
      var response = await ApiProvider.sendRequest(
          queryParameters: body,
          responseType: ResponseType.json,
          url: unAttachProductsToSubWarehouse + productsId,
          method: HttpMethods.delete);

      return response.statusCode == successCode && response.data['success'];
    } catch (e) {
      return false;
    }
  }

  static Future<bool> attachProductsToSubWarehouseService({dynamic fullRequestBody}) async {
    try {
      var response = await ApiProvider.sendRequest(
          url: attachProductsToSubWarehouse, method: HttpMethods.post, body: jsonEncode(fullRequestBody));

      return response.statusCode == successCode && response.data['success'];
    } catch (e) {
      return null;
    }
  }

  static Future<bool> changeProductSubWarehouse(
      ProductEntity product, String productSubWarehouseId, bool remove) async {
    var subWarehouseBody = {
      'product_id': product.productId,
      'sub_warehouse_id': productSubWarehouseId,
      'price': product.price,
      'is_featured': product.isFeatured,
      'is_active': product.isActive,
      'priority': product.priority,
      'supplier_code': product.supplierCode,
      'min_threshold': product.minThreshold,
      'increase_percentage': product.increasePercentage,
      'price_factor': product.priceFactor,
      'automatic_activation': product.automaticActivation,
    };
    try {
      bool removed;
      if (remove) {
        removed = await ProductsServices.unAttachProductsToSubWarehouseService(
            productsId: product.productId.toString(), subWarehouse: product.subWarehouseId.toString());
      } else {
        removed = true;
      }
      bool add = false;
      if (removed) {
        add = await ProductsServices.attachProductsToSubWarehouseService(fullRequestBody: subWarehouseBody);
      }
      if (!add && removed) {
        var subWarehouseBody = {
          'product_id': product.productId,
          'sub_warehouse_id': product.subWarehouseId,
          'price': product.price,
          'is_featured': product.isFeatured,
          'is_active': product.isActive,
          'priority': product.priority,
          'supplier_code': product.supplierCode,
          'min_threshold': product.minThreshold,
          'increase_percentage': product.increasePercentage,
          'price_factor': product.priceFactor,
          'automatic_activation': product.automaticActivation,
        };
        await ProductsServices.attachProductsToSubWarehouseService(fullRequestBody: subWarehouseBody);
      }
      return removed && add;
    } catch (e) {
      return false;
    }
  }
}
