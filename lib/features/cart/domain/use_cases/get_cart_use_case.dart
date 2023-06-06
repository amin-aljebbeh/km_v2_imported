import 'package:dartz/dartz.dart';
import 'package:kammun_app/features/cart/domain/repositories/cart_repository.dart';

import '../../../../core/core_importer.dart';
import '../../../products/domain/entities/product_entity.dart';

class GetCartUseCase {
  final CartRepository cartRepository;

  GetCartUseCase({this.cartRepository});

  Future<Either<Failure, List<ProductEntity>>> call({String cart}) async {
    return await cartRepository.getCart(cart: cart);
  }
}
