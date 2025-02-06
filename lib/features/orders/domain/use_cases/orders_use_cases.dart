import 'package:kammun_app/features/orders/domain/use_cases/get_cancel_reasons_use_case.dart';
import 'package:kammun_app/features/orders/domain/use_cases/re_assign_order_use_case.dart';
import 'package:kammun_app/features/orders/domain/use_cases/unlock_order_use_case.dart';

import '../../../../core/core_importer.dart';
import 'assign_order_to_shopper_use_case.dart';
import 'change_order_status_use_case.dart';
import 'get_all_orders_use_case.dart';
import 'get_shopper_orders_use_case.dart';
import 'get_supplier_orders_use_case.dart';
import 'lock_order_use_case.dart';
import 'update_order_rating_use_case.dart';

class OrdersUSeCases {
  final ReAssignOrderUseCase reAssignOrderUseCase;
  final UpdateOrderRatingUseCase updateOrderRatingUseCase;
  final AssignOrderToShopperUseCase assignOrderToShopperUseCase;
  final ChangeOrderStatusUseCase changeOrderStatusUseCase;
  final GetAllOrdersUseCase getAllOrdersUseCase;
  final GetShopperOrdersUseCase getShopperOrdersUseCase;
  final GetSupplierOrdersUseCase getSupplierOrdersUseCase;
  final LockOrderUseCase lockOrderUseCase;
  final UnlockOrderUseCase unlockOrderUseCase;
  final GetCancelReasonsUseCase getCancelReasonsUseCase;

  OrdersUSeCases({
    @required this.assignOrderToShopperUseCase,
    @required this.changeOrderStatusUseCase,
    @required this.getAllOrdersUseCase,
    @required this.getShopperOrdersUseCase,
    @required this.getSupplierOrdersUseCase,
    @required this.lockOrderUseCase,
    @required this.unlockOrderUseCase,
    @required this.reAssignOrderUseCase,
    @required this.updateOrderRatingUseCase,
    @required this.getCancelReasonsUseCase,
  }) : assert(
            assignOrderToShopperUseCase != null &&
                changeOrderStatusUseCase != null &&
                getAllOrdersUseCase != null &&
                getShopperOrdersUseCase != null &&
                getSupplierOrdersUseCase != null &&
                lockOrderUseCase != null &&
                unlockOrderUseCase != null &&
                reAssignOrderUseCase != null &&
                getCancelReasonsUseCase != null &&
                updateOrderRatingUseCase != null,
            'All use cases should be initialized.');
}
