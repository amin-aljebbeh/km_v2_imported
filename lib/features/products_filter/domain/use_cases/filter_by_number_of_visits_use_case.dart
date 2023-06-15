import 'package:dartz/dartz.dart';
import 'package:kammun_app/features/products_filter/domain/repositories/products_filter_repository.dart';

import '../../../../core/core_importer.dart';
import '../entities/filtered_products_entity.dart';

class FilterByNumberOfVisitsUseCase {
  final ProductsFilterRepository productsFilterRepository;

  FilterByNumberOfVisitsUseCase({this.productsFilterRepository});

  Future<Either<Failure, FilterPaginationEntity>> call({int numberOfVisit, int page, int biggerThan}) async {
    return await productsFilterRepository.filterByNumberOfVisits(
        numberOfVisit: numberOfVisit, biggerThan: biggerThan, page: page);
  }
}
