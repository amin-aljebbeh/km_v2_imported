import 'package:dartz/dartz.dart';
import 'package:kammun_app/core/core_importer.dart';
import 'package:kammun_app/features/cart/domain/entities/submit_order_entity.dart';
import 'package:kammun_app/features/cart/domain/entities/update_order_response_entity.dart';
import 'package:kammun_app/features/products/domain/entities/product_entity.dart';

abstract class CartRepository {
  Future<Either<Failure, UpdateOrderResponseEntity>> updateOrder({int orderId, SubmitOrderEntity submitOrderEntity});
  Future<Either<Failure, List<ProductEntity>>> getCart({String cart});
}
