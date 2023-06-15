import 'package:dartz/dartz.dart';
import 'package:kammun_app/features/products_filter/domain/repositories/products_filter_repository.dart';

import '../../../../core/core_importer.dart';
import '../entities/filtered_products_entity.dart';

class FilterByNumberOfSalesUseCase {
  final ProductsFilterRepository productsFilterRepository;

  FilterByNumberOfSalesUseCase({this.productsFilterRepository});

  Future<Either<Failure, FilterPaginationEntity>> call({int numberOfSale, int page, int biggerThan}) async {
    return await productsFilterRepository.filterByNumberOfSales(
        numberOfSale: numberOfSale, biggerThan: biggerThan, page: page);
  }
}
