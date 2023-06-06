import 'package:dartz/dartz.dart';
import 'package:kammun_app/features/cart/data/data_sources/cart_remote_date_source.dart';
import 'package:kammun_app/features/cart/data/models/submit_order_model.dart';
import 'package:kammun_app/features/cart/domain/entities/submit_order_entity.dart';
import 'package:kammun_app/features/cart/domain/entities/update_order_response_entity.dart';
import 'package:kammun_app/features/cart/domain/repositories/cart_repository.dart';
import 'package:kammun_app/features/products/domain/entities/product_entity.dart';

import '../../../../core/core_importer.dart';
import '../models/invoice_product_model.dart';

class CartRepositoryImplement implements CartRepository {
  final CartRemoteDataSource cartRemoteDataSource;
  final RepositoryFactory repositoryFactory;

  CartRepositoryImplement({this.cartRemoteDataSource, this.repositoryFactory});

  @override
  Future<Either<Failure, UpdateOrderResponseEntity>> updateOrder(
      {int orderId, SubmitOrderEntity submitOrderEntity}) async {
    try {
      UpdateOrderResponseEntity response = await cartRemoteDataSource.updateOrder(
          orderId: orderId,
          submitOrderModel: SubmitOrderModel(
            products: submitOrderEntity.products
                .map((product) =>
                    InvoiceProductModel(price: product.price, quantity: product.quantity, productId: product.productId))
                .toList(),
            userNote: submitOrderEntity.userNote,
            checkChangedPriceProduct: submitOrderEntity.checkChangedPriceProduct,
            purchasePrices: submitOrderEntity.purchasePrices,
            saveRefund: submitOrderEntity.saveRefund,
            useWallet: submitOrderEntity.useWallet,
          ));
      return Right(response);
    } on CacheException {
      return Left(CacheFailure());
    } on ServerException {
      return Left(ServerFailure());
    } on OfflineException {
      return Left(OfflineFailure());
    } on OfflineRegionException catch (e) {
      return Left(OfflineRegionFailure(message: e.message));
    } catch (e) {
      return Left(InternalFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ProductEntity>>> getCart({String cart}) async {
    try {
      List<ProductEntity> products = await cartRemoteDataSource.getCart(cart: cart);
      return Right(products);
    } on CacheException {
      return Left(CacheFailure());
    } on ServerException {
      return Left(ServerFailure());
    } on OfflineException {
      return Left(OfflineFailure());
    } on OfflineRegionException catch (e) {
      return Left(OfflineRegionFailure(message: e.message));
    } catch (e) {
      return Left(InternalFailure(message: e.toString()));
    }
  }
}
