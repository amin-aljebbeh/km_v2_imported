import 'package:dartz/dartz.dart';
import 'package:kammun_app/features/products/domain/repositories/products_repository.dart';

import '../../../../core/core_importer.dart';
import '../entities/product_entity.dart';

class GetBarcodeProductsUseCase {
  final ProductsRepository productsRepository;

  GetBarcodeProductsUseCase({this.productsRepository});

  Future<Either<Failure, List<ProductEntity>>> call({String barcode}) async {
    return await productsRepository.getBarcodeProducts(barcode: barcode);
  }
}
