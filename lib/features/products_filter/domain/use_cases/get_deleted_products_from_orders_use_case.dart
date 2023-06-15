import 'package:dartz/dartz.dart';
import 'package:kammun_app/features/products_filter/domain/repositories/products_filter_repository.dart';

import '../../../../core/core_importer.dart';
import '../entities/filtered_products_entity.dart';

class GetDeletedProductsFromOrdersUseCase {
  final ProductsFilterRepository productsFilterRepository;

  GetDeletedProductsFromOrdersUseCase({this.productsFilterRepository});

  Future<Either<Failure, FilterPaginationEntity>> call({int page, String fromDate, String toDate}) async {
    return await productsFilterRepository.getDeletedProductsFromOrders(fromDate: fromDate, toDate: toDate, page: page);
  }
}
