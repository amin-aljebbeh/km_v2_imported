import 'package:kammun_app/features/order_details/domain/use_cases/add_image_to_order_use_case.dart';
import 'package:kammun_app/features/order_details/domain/use_cases/delete_image_from_order_use_case.dart';
import 'package:kammun_app/features/order_details/domain/use_cases/update_order_product_use_case.dart';

import '../../../../core/core_importer.dart';

class OrderDetailsUseCases {
  final AddImageToOrderUseCase addImageToOrderUseCase;
  final DeleteImageFromOrderUseCase deleteImageFromOrderUseCase;
  final UpdateOrderProductUseCase updateOrderProductUseCase;

  OrderDetailsUseCases({
    @required this.addImageToOrderUseCase,
    @required this.deleteImageFromOrderUseCase,
    @required this.updateOrderProductUseCase,
  }) : assert(
            addImageToOrderUseCase != null && deleteImageFromOrderUseCase != null && updateOrderProductUseCase != null,
            'All use cases should be initialized.');
}
