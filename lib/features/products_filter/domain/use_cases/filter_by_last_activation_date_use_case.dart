import 'package:dartz/dartz.dart';
import 'package:kammun_app/features/products_filter/domain/repositories/products_filter_repository.dart';

import '../../../../core/core_importer.dart';
import '../entities/products_pagination_entity.dart';

class FilterByLastActivationDateUseCase {
  final ProductsFilterRepository productsFilterRepository;

  FilterByLastActivationDateUseCase({this.productsFilterRepository});

  Future<Either<Failure, ProductsPageEntity>> call({int numberOfDays, int page, int biggerThan}) async {
    return await productsFilterRepository.filterByLastActivationDate(
        numberOfDays: numberOfDays, biggerThan: biggerThan, page: page);
  }
}
