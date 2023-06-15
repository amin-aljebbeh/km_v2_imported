import '../../../../core/core_importer.dart';
import '../models/filtered_products_model.dart';

abstract class ProductsFilterRemoteDataSource {
  Future<FilterPaginationModel> filterByLastActivationDate({int numberOfDays, int page, int biggerThan});

  Future<FilterPaginationModel> filterByNumberOfSales({int numberOfSale, int page, int biggerThan});

  Future<FilterPaginationModel> filterByNumberOfVisits({int numberOfVisit, int page, int biggerThan});

  Future<FilterPaginationModel> getDeletedProductsFromOrders({int page, String fromDate, String toDate});
}

class ProductsFilterRemoteDataSourceImplement implements ProductsFilterRemoteDataSource {
  @override
  Future<FilterPaginationModel> filterByLastActivationDate({int numberOfDays, int page, int biggerThan}) async {
    Response response = await ApiProvider.sendRequest(
        url: filterByLastActivationDateApi,
        method: HttpMethods.get,
        queryParameters: {'number_of_days': numberOfDays, 'page': page, 'biggar_than': biggerThan});
    try {
      if (response != null) {
        if (response.statusCode == successCode) return filteredProductsModelFromJson(jsonEncode(response.data)).page;
      }
    } catch (e) {
      throw (InternalException(message: e.toString()));
    }
    throw (ServerException());
  }

  @override
  Future<FilterPaginationModel> filterByNumberOfSales({int numberOfSale, int page, int biggerThan}) async {
    Response response = await ApiProvider.sendRequest(
        url: filterByNumberOfSalesApi,
        method: HttpMethods.get,
        queryParameters: {'number_of_sale': numberOfSale, 'page': page, 'biggar_than': biggerThan});
    try {
      if (response != null) {
        if (response.statusCode == successCode) return filteredProductsModelFromJson(jsonEncode(response.data)).page;
      }
    } catch (e) {
      Tools.logToConsole('exception data');
      Tools.logToConsole(e.toString());
      throw (InternalException(message: e.toString()));
    }
    throw (ServerException());
  }

  @override
  Future<FilterPaginationModel> filterByNumberOfVisits({int numberOfVisit, int page, int biggerThan}) async {
    Response response = await ApiProvider.sendRequest(
        url: filterByNumberOfVisitsApi,
        method: HttpMethods.get,
        queryParameters: {'number_of_visit': numberOfVisit, 'page': page, 'biggar_than': biggerThan});
    try {
      if (response != null) {
        if (response.statusCode == successCode) return filteredProductsModelFromJson(jsonEncode(response.data)).page;
      }
    } catch (e) {
      throw (InternalException(message: e.toString()));
    }
    throw (ServerException());
  }

  @override
  Future<FilterPaginationModel> getDeletedProductsFromOrders({int page, String fromDate, String toDate}) async {
    Response response = await ApiProvider.sendRequest(
        url: productsDeletedFromOrdersApi,
        method: HttpMethods.get,
        queryParameters: {'page': page, 'from_date': fromDate, 'to_date': toDate});
    try {
      if (response != null) {
        if (response.statusCode == successCode) return filteredProductsModelFromJson(jsonEncode(response.data)).page;
      }
    } catch (e) {
      throw (InternalException(message: e.toString()));
    }
    throw (ServerException());
  }
}
