import 'package:kammun_app/features/product_details/domain/use_cases/product_details_use_cases.dart';

import '../../../../core/core_importer.dart';

@immutable
class ProductDetailsState extends Equatable {
  final ProductDetailsUSeCases productDetailsUSeCases;

  const ProductDetailsState({this.productDetailsUSeCases});

  factory ProductDetailsState.initial() {
    return ProductDetailsState(productDetailsUSeCases: sl<ProductDetailsUSeCases>());
  }

  ProductDetailsState copyWith() {
    return ProductDetailsState(productDetailsUSeCases: productDetailsUSeCases);
  }

  @override
  List<Object> get props => [productDetailsUSeCases];
}
