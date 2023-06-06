import 'package:kammun_app/core/core_importer.dart';

import 'get_cart_use_case.dart';
import 'update_order_use_case.dart';

class CartUseCases {
  final UpdateOrderUseCase updateOrderUSeCase;
  final GetCartUseCase getCartUseCase;

  CartUseCases({@required this.updateOrderUSeCase, @required this.getCartUseCase})
      : assert(updateOrderUSeCase != null && getCartUseCase != null, 'All use cases should be initialized.');
}
