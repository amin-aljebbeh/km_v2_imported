import 'package:dartz/dartz.dart';

import '../../../../core/core_importer.dart';
import '../entities/filtered_products_entity.dart';

abstract class ProductsFilterRepository {
  Future<Either<Failure, FilterPaginationEntity>> filterByLastActivationDate(
      {int numberOfDays, int page, int biggerThan});

  Future<Either<Failure, FilterPaginationEntity>> filterByNumberOfSales({int numberOfSale, int page, int biggerThan});

  Future<Either<Failure, FilterPaginationEntity>> filterByNumberOfVisits({int numberOfVisit, int page, int biggerThan});

  Future<Either<Failure, FilterPaginationEntity>> getDeletedProductsFromOrders(
      {int page, String fromDate, String toDate});
}
