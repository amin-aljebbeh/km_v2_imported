import 'package:kammun_app/features/product_details/domain/use_cases/delete_product_use_case.dart';

import '../../../../core/core_importer.dart';
import 'delete_image_use_case.dart';

class ProductDetailsUSeCases {
  final DeleteProductUseCase deleteProductUseCase;
  final DeleteImageUseCase deleteImageUseCase;

  ProductDetailsUSeCases({@required this.deleteProductUseCase, @required this.deleteImageUseCase})
      : assert(deleteProductUseCase != null && deleteImageUseCase != null, 'All use cases should be initialized.');
}
