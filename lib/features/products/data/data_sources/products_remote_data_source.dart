import 'package:kammun_app/features/products/data/models/category_products_model.dart';
import 'package:kammun_app/features/products/data/models/product_model.dart';

import '../../../../core/core_importer.dart';
import '../models/barcode_products_model.dart';
import '../models/category_products_pagination_model.dart';

abstract class ProductsRemoteDataSource {
  Future<CategoryProductsModel> getCategoryProducts({int categoryId, int pageNumber});
  Future<CategoryProductsModel> searchProducts({String query, int pageNumber});
  Future<List<ProductModel>> getBarcodeProducts({String barcode});
  Future<CategoryProductsPaginationModel> getFeaturedProducts({int pageNumber});
  Future<CategoryProductsPaginationModel> getNewlyAddedProducts({int pageNumber});
}

class ProductsRemoteDataSourceImplement implements ProductsRemoteDataSource {
  @override
  Future<List<ProductModel>> getBarcodeProducts({String barcode}) async {
    Response response =
        await ApiProvider.sendRequest(url: searchProductByBarcodeApi + barcode, method: HttpMethods.get);
    try {
      if (response != null) {
        if (response.statusCode == successCode) return barcodeProductsModelFromJson(jsonEncode(response.data)).products;
      }
    } catch (e) {
      throw (InternalException(message: e.toString()));
    }
    throw (ServerException());
  }

  @override
  Future<CategoryProductsModel> getCategoryProducts({int categoryId, int pageNumber}) async {
    Response response = await ApiProvider.sendRequest(
        url: getCategoryApi + categoryId.toString(), method: HttpMethods.get, queryParameters: {'page': pageNumber});
    try {
      if (response != null) {
        if (response.statusCode == successCode) return categoryProductsFromJson(jsonEncode(response.data));
      }
    } catch (e) {
      throw (InternalException(message: e.toString()));
    }
    throw (ServerException());
  }

  @override
  Future<CategoryProductsModel> searchProducts({String query, int pageNumber}) async {
    Response response = await ApiProvider.sendRequest(
        url: searchProductsApi + query, method: HttpMethods.get, queryParameters: {'page': pageNumber});
    try {
      if (response != null) {
        if (response.statusCode == successCode) return categoryProductsFromJson(jsonEncode(response.data));
      }
    } catch (e) {
      throw (InternalException(message: e.toString()));
    }
    throw (ServerException());
  }

  @override
  Future<CategoryProductsPaginationModel> getFeaturedProducts({int pageNumber}) async {
    Response response = await ApiProvider.sendRequest(
        url: featuredProductsApi, method: HttpMethods.get, queryParameters: {"page":pageNumber});
    try {
      if (response != null) {
        if (response.statusCode == successCode) return categoryProductsFromJson(jsonEncode(response.data)).page;
        if (response.data['reason'].toString().contains('discontinued')) throw (OfflineRegionException());
      }
    } catch (e) {
      throw (InternalException(message: e.toString()));
    }
    throw (ServerException());
  }

  @override
  Future<CategoryProductsPaginationModel> getNewlyAddedProducts({int pageNumber}) async {
    Response response = await ApiProvider.sendRequest(
        url: newlyAddedProductsApi, method: HttpMethods.get, queryParameters: {"page":pageNumber});
    try {
      if (response != null) {
        if (response.statusCode == successCode) {
          return categoryProductsFromJson(jsonEncode(response.data)).page;
        }
        if (response.data['reason'].toString().contains('discontinued')) throw (OfflineRegionException());
      }
    } catch (e) {
      throw (InternalException(message: e.toString()));
    }
    throw (ServerException());
  }
}
