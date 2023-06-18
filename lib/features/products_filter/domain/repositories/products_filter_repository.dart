import 'package:dartz/dartz.dart';

import '../../../../core/core_importer.dart';
import '../entities/products_pagination_entity.dart';

abstract class ProductsFilterRepository {
  Future<Either<Failure, ProductsPageEntity>> filterByLastActivationDate({int numberOfDays, int page, int biggerThan});

  Future<Either<Failure, ProductsPageEntity>> filterByNumberOfSales({int numberOfSale, int page, int biggerThan});

  Future<Either<Failure, ProductsPageEntity>> filterByNumberOfVisits({int numberOfVisit, int page, int biggerThan});

  Future<Either<Failure, ProductsPageEntity>> getDeletedProductsFromOrders({int page, String fromDate, String toDate});
}
