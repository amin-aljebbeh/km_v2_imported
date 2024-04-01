import 'package:dartz/dartz.dart';
import 'package:kammun_app/core/core_importer.dart';
import 'package:kammun_app/features/search_orders/presentation/redux/search_orders_action.dart';

import '../../../../core/utils/toasta.dart';
import '../../../cart/presentation/redux/cart_action.dart';
import '../../../order_details/presentation/redux/order_details_action.dart';
import '../../domain/entities/lock_order_response_entity.dart';
import '../../domain/entities/order_entity.dart';
import '../../orders_services.dart';

abstract class OrdersAction {
  handle({@required Store<AppState> store});
}

class GetOrdersAction implements OrdersAction {
  final BuildContext context;

  GetOrdersAction({this.context});

  @override
  handle({Store<AppState> store}) {
    ApiProvider.cancelOrdersRequests();
    store.dispatch(NoError());
    if (Services.hasRole(context, operationManagerRole)) {
      store.dispatch(GetAllOrdersAction());
    } else if (Services.hasRole(context, shopperRole)) {
      store.dispatch(GetShopperOrdersAction());
    } else if (Services.hasRole(context, supplierRole)) {
      store.dispatch(GetSupplierOrdersAction());
    }
  }
}

class ReAssignOrderAction implements OrdersAction {
  final int orderId;
  final BuildContext context;

  ReAssignOrderAction({this.orderId, this.context});

  @override
  handle({Store<AppState> store}) async {
    store.dispatch(StartLoading());
    Either either = await store.state.ordersState.ordersUSeCases.reAssignOrderUseCase(orderId: orderId);
    either.fold((failure) => store.dispatch(CatchError(errorMessage: 'حدث خطأ، يرجى المحاولة مجدداً')),
        (_) => Utility.showToast(message: 'تمت العملية بنجاح'));
    store.dispatch(StopLoading());
  }
}

class UpdateOrderRatingAction implements OrdersAction {
  final int orderId;
  final int deliveryRating;
  final BuildContext context;

  UpdateOrderRatingAction({this.orderId, this.deliveryRating, this.context});

  @override
  handle({Store<AppState> store}) async {
    store.dispatch(StartLoading());
    Either either = await store.state.ordersState.ordersUSeCases
        .updateOrderRatingUseCase(orderId: orderId, deliveryRating: deliveryRating);
    either.fold((failure) => store.dispatch(CatchError(errorMessage: 'حدث خطأ، يرجى المحاولة مجدداً')), (_) {
      Navigator.pop(context);
      Utility.showToast(message: 'تم تعديل تقييم الطلب إلى $deliveryRating');

      // snackBar(context: context, success: true, message: 'تم تعديل تقييم الطلب إلى $deliveryRating');
    });
    store.dispatch(StopLoading());
  }
}

class AssignOrderToShopperAction implements OrdersAction {
  final int orderId, assignedId;
  final BuildContext context;

  AssignOrderToShopperAction({this.orderId, this.assignedId, this.context});

  @override
  handle({Store<AppState> store}) async {
    store.dispatch(StartLoading());
    Either either = await store.state.ordersState.ordersUSeCases
        .assignOrderToShopperUseCase(orderId: orderId, assignedId: assignedId);
    either.fold((failure) => store.dispatch(CatchError(errorMessage: 'حدث خطأ، يرجى المحاولة مجدداً')),
        (_) => Utility.showToast(message: 'تم إسناد الطلب بنجاح'));
    store.dispatch(StopLoading());
  }
}

class ChangeOrderStatusAction implements OrdersAction {
  final int orderId, statusId;
  final BuildContext context;

  ChangeOrderStatusAction({this.orderId, this.statusId, this.context});

  @override
  handle({Store<AppState> store}) async {
    // Navigator.of(context).pop();
    store.dispatch(StartLoading());
    Either either =
        await store.state.ordersState.ordersUSeCases.changeOrderStatusUseCase(orderId: orderId, statusId: statusId);
    either.fold((failure) => store.dispatch(CatchError(errorMessage: 'حدث خطأ، يرجى المحاولة مجدداً')), (_) async {
      Utility.showToast(message: 'تم تغيير حالة الطلب بنجاح');
      if (store.state.searchOrdersState.searchOrdersType == SearchOrdersTypes.none) {
        List<OrderEntity> orders = store.state.ordersState.orders;
        orders.firstWhere((order) => order.id == orderId).orderStatusId = statusId.toString();
        store.dispatch(SetViewOrders(orders: orders));
      } else {
        List<OrderEntity> orders = store.state.searchOrdersState.orders;
        orders.firstWhere((order) => order.id == orderId).orderStatusId = statusId.toString();
        store.dispatch(SetSearchOrders(orders: orders));
      }
      // snackBar(context: context, success: true, message: 'تم تغيير حالة الطلب بنجاح');
    });
    store.dispatch(StopLoading());
  }
}

class GetAllOrdersAction implements OrdersAction {
  GetAllOrdersAction();

  @override
  handle({Store<AppState> store}) async {
    store.dispatch(StartLoading());
    Either either = await store.state.ordersState.ordersUSeCases.getAllOrdersUseCase(
        cancelToken: OrdersServices.cancelRequest,
        filterEvaluatedOrders: store.state.ordersState.rateFilter,
        pageNumber: store.state.ordersState.ordersPage);
    either.fold((failure) {
      store.dispatch(CatchError(errorMessage: 'حدث خطأ، يرجى المحاولة مجدداً'));
    }, (orders) => store.dispatch(FilterOrders(orders: orders)));
    store.dispatch(StopLoading());
  }
}

class GetShopperOrdersAction implements OrdersAction {
  GetShopperOrdersAction();

  @override
  handle({Store<AppState> store}) async {
    store.dispatch(StartLoading());
    Either either = await store.state.ordersState.ordersUSeCases.getShopperOrdersUseCase(
        cancelToken: OrdersServices.cancelRequest, pageNumber: store.state.ordersState.ordersPage);
    either.fold((failure) => store.dispatch(CatchError(errorMessage: 'حدث خطأ، يرجى المحاولة مجدداً')), (result) {
      List<OrderEntity> orders = result;
      Map<int, List<int>> subWarehouseAuthCodes = orders.fold<Map<int, List<int>>>({}, (map, order) {
        if (!map.containsKey(order.id)) map[order.id] = [];
        map[order.id].addAll(order.subWarehouseAuthCodes.map((code) => code.subWarehouseId).toList());

        return map;
      });

      store.dispatch(SetAuthenticatedSubWarehouses(authenticatedSubWarehouses: subWarehouseAuthCodes));
      store.dispatch(FilterOrders(orders: orders));
    });
    store.dispatch(StopLoading());
  }
}

class GetSupplierOrdersAction implements OrdersAction {
  GetSupplierOrdersAction();

  @override
  handle({Store<AppState> store}) async {
    store.dispatch(StartLoading());
    Either either = await store.state.ordersState.ordersUSeCases.getSupplierOrdersUseCase(
        cancelToken: OrdersServices.cancelRequest, pageNumber: store.state.ordersState.ordersPage);
    either.fold((failure) => store.dispatch(CatchError(errorMessage: 'حدث خطأ، يرجى المحاولة مجدداً')),
        (orders) => store.dispatch(FilterOrders(orders: orders)));
    store.dispatch(StopLoading());
  }
}

class LockOrderAction implements OrdersAction {
  final int orderId;
  final BuildContext context;

  LockOrderAction({this.orderId, this.context});

  @override
  handle({Store<AppState> store}) async {
    store.dispatch(StartLoading());
    Either either = await store.state.ordersState.ordersUSeCases.lockOrderUseCase(orderId: orderId);
    either.fold((failure) => store.dispatch(CatchError(errorMessage: 'حدث خطأ، يرجى المحاولة مجدداً')),
        (responseEntity) async {
      LockOrderResponseEntity response = responseEntity;
      if (response != null) {
        List<OrderEntity> orders = [];
        if (store.state.searchOrdersState.searchOrdersType == SearchOrdersTypes.none) {
          orders.addAll(store.state.ordersState.orders);
        } else {
          orders.addAll(store.state.searchOrdersState.orders);
        }
        if (response.success) {
          store.dispatch(
              SetOrderStatus(statusId: int.parse(orders.firstWhere((order) => order.id == orderId).orderStatusId)));
          orders.firstWhere((order) => order.id == orderId).underUpdate = '1';
          await moveOrderProductsToCart(orderProducts: response.products, context: context);
        } else if (!response.success) {
          orders.firstWhere((order) => order.id == orderId).underUpdate = '2';
          store.dispatch(
              CatchError(errorMessage: 'لا يمكنك تعديل طلبك حالياً لأن مسؤول الطلب أو الزبون يقوم بتعديله حالياً'));
        }
        if (store.state.searchOrdersState.searchOrdersType == SearchOrdersTypes.none) {
          store.dispatch(SetViewOrders(orders: orders));
        } else {
          store.dispatch(SetSearchOrders(orders: orders));
        }
      } else {
        store.dispatch(CatchError(errorMessage: 'حدث خطأ أثناء محاولة تعديل الطلب يرجى التأكد من إتصالك بالإنترنت'));
      }
    });
    store.dispatch(StopLoading());
  }
}

class UnLockOrderAction implements OrdersAction {
  final int orderId;
  final BuildContext context;

  UnLockOrderAction({this.orderId, this.context});

  @override
  handle({Store<AppState> store}) async {
    store.dispatch(StartLoading());
    Either either = await store.state.ordersState.ordersUSeCases.unlockOrderUseCase(orderId: orderId);
    either.fold((failure) => Utility.showToast(message: 'فشلت عملية إلغاء تعليق الطلب يرجى المحاولة مجدداً'), (_) {
      Utility.showToast(message: 'تم إلغاء تعليق الطلب بنجاح');
      if (store.state.searchOrdersState.searchOrdersType == SearchOrdersTypes.none) {
        List<OrderEntity> orders = store.state.ordersState.orders;
        orders.firstWhere((order) => order.id == orderId).underUpdate = '0';
        store.dispatch(SetViewOrders(orders: orders));
      } else {
        List<OrderEntity> orders = store.state.searchOrdersState.orders;
        orders.firstWhere((order) => order.id == orderId).underUpdate = '0';
        store.dispatch(SetSearchOrders(orders: orders));
      }
    });
    store.dispatch(StopLoading());
  }
}

class SetViewOrders {
  final List<OrderEntity> orders;

  SetViewOrders({this.orders});
}

class SetOrdersStatusFilter {
  final int filter;

  SetOrdersStatusFilter({this.filter});
}

class SetOrdersPage {
  final int page;

  SetOrdersPage({this.page});
}

class SetLimitedOrdersPage {
  final int page;

  SetLimitedOrdersPage({this.page});
}

class SetAssignFilter {
  final int filter;

  SetAssignFilter({this.filter});
}

class SetWarehouseFilter {
  final int filter;

  SetWarehouseFilter({this.filter});
}

class SetRateFilter {
  final int filter;

  SetRateFilter({this.filter});
}

class FilterOrders extends OrdersAction {
  final List<OrderEntity> orders;

  FilterOrders({this.orders});

  @override
  handle({Store<AppState> store}) {
    if (store.state.ordersState.rateFilter == 0) {
      if (store.state.ordersState.statusFilter == 0) {
        orders.removeWhere((order) => int.parse(order.orderStatusId) > 4);
      } else {
        orders.removeWhere((order) => int.parse(order.orderStatusId) != store.state.ordersState.statusFilter);
      }
      switch (store.state.ordersState.assignFilter) {
        case (0):
          break;
        case (1):
          orders.removeWhere((order) => order.shopper == null);
          break;
        case (2):
          orders.removeWhere((order) => order.shopper != null);
          break;
      }
    }
    if (store.state.ordersState.warehouseFilter != 0) {
      orders.removeWhere((order) => int.parse(order.warehouseId) != store.state.ordersState.warehouseFilter);
    }
    orders.removeWhere((order) => order.products.isEmpty);
    store.dispatch(SetViewOrders(orders: orders));
  }
}
