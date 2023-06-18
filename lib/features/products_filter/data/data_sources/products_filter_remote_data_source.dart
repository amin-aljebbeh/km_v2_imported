import '../../../../core/core_importer.dart';
import '../models/products_pagination_model.dart';

abstract class ProductsFilterRemoteDataSource {
  Future<ProductsPageModel> filterByLastActivationDate({int numberOfDays, int page, int biggerThan});

  Future<ProductsPageModel> filterByNumberOfSales({int numberOfSale, int page, int biggerThan});

  Future<ProductsPageModel> filterByNumberOfVisits({int numberOfVisit, int page, int biggerThan});

  Future<ProductsPageModel> getDeletedProductsFromOrders({int page, String fromDate, String toDate});
}

class ProductsFilterRemoteDataSourceImplement implements ProductsFilterRemoteDataSource {
  @override
  Future<ProductsPageModel> filterByLastActivationDate({int numberOfDays, int page, int biggerThan}) async {
    Response response = await ApiProvider.sendRequest(
        url: filterByLastActivationDateApi,
        method: HttpMethods.get,
        queryParameters: {'number_of_days': numberOfDays, 'page': page, 'biggar_than': biggerThan});
    try {
      if (response != null) {
        if (response.statusCode == successCode) return productsPaginationModelFromJson(jsonEncode(response.data)).page;
      }
    } catch (e) {
      throw (InternalException(message: e.toString()));
    }
    throw (ServerException());
  }

  @override
  Future<ProductsPageModel> filterByNumberOfSales({int numberOfSale, int page, int biggerThan}) async {
    Response response = await ApiProvider.sendRequest(
        url: filterByNumberOfSalesApi,
        method: HttpMethods.get,
        queryParameters: {'number_of_sale': numberOfSale, 'page': page, 'biggar_than': biggerThan});
    try {
      if (response != null) {
        if (response.statusCode == successCode) return productsPaginationModelFromJson(jsonEncode(response.data)).page;
      }
    } catch (e) {
      throw (InternalException(message: e.toString()));
    }
    throw (ServerException());
  }

  @override
  Future<ProductsPageModel> filterByNumberOfVisits({int numberOfVisit, int page, int biggerThan}) async {
    Response response = await ApiProvider.sendRequest(
        url: filterByNumberOfVisitsApi,
        method: HttpMethods.get,
        queryParameters: {'number_of_visit': numberOfVisit, 'page': page, 'biggar_than': biggerThan});
    try {
      if (response != null) {
        if (response.statusCode == successCode) return productsPaginationModelFromJson(jsonEncode(response.data)).page;
      }
    } catch (e) {
      throw (InternalException(message: e.toString()));
    }
    throw (ServerException());
  }

  @override
  Future<ProductsPageModel> getDeletedProductsFromOrders({int page, String fromDate, String toDate}) async {
    Response response = await ApiProvider.sendRequest(
        url: productsDeletedFromOrdersApi,
        method: HttpMethods.get,
        queryParameters: {'page': page, 'from_date': fromDate, 'to_date': toDate});
    try {
      if (response != null) {
        if (response.statusCode == successCode) return productsPaginationModelFromJson(jsonEncode(response.data)).page;
      }
    } catch (e) {
      throw (InternalException(message: e.toString()));
    }
    throw (ServerException());
  }
}
