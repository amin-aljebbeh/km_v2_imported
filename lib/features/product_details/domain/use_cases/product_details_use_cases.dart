import 'package:kammun_app/features/product_details/domain/use_cases/delete_product_use_case.dart';

import '../../../../core/core_importer.dart';
import 'delete_image_use_case.dart';
import 'remove_product_from_category_use_case.dart';

class ProductDetailsUSeCases {
  final DeleteProductUseCase deleteProductUseCase;
  final DeleteImageUseCase deleteImageUseCase;
  final RemoveProductFromCategoryUseCase removeProductFromCategoryUseCase;

  ProductDetailsUSeCases({
    @required this.deleteProductUseCase,
    @required this.deleteImageUseCase,
    @required this.removeProductFromCategoryUseCase,
  }) : assert(deleteProductUseCase != null && deleteImageUseCase != null && removeProductFromCategoryUseCase != null,
            'All use cases should be initialized.');
}
