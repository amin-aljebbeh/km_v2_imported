import 'package:kammun_app/features/product_details/domain/use_cases/delete_product_use_case.dart';

import '../../../../core/core_importer.dart';

class ProductDetailsUSeCases {
  final DeleteProductUseCase deleteProductUseCase;

  ProductDetailsUSeCases({@required this.deleteProductUseCase})
      : assert(deleteProductUseCase != null, 'All use cases should be initialized.');
}
