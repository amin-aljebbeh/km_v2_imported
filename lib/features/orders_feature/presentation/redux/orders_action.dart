import 'package:dartz/dartz.dart';
import 'package:kammun_app/core/core_importer.dart';

import '../../domain/entities/order_entity.dart';

abstract class OrdersAction {
  handle({@required Store<AppState> store});
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
        (_) => snackBar(message: 'تمت العملية بنجاح', success: true, context: context));
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
    either.fold((failure) => snackBar(context: context, success: false, message: 'حدث خطأ، يرجى المحاولة مجدداً'), (_) {
      Navigator.pop(context);
      snackBar(context: context, success: true, message: 'تم تعديل تقييم الطلب إلى $deliveryRating');
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
    either.fold((failure) => snackBar(context: context, success: false, message: 'حدث خطأ، يرجى المحاولة مجدداً'),
        (_) => snackBar(context: context, success: true, message: 'تم إسناد الطلب بنجاح'));
    store.dispatch(StopLoading());
  }
}

class ChangeOrderStatusAction implements OrdersAction {
  final int orderId, statusId;
  final BuildContext context;

  ChangeOrderStatusAction({this.orderId, this.statusId, this.context});

  @override
  handle({Store<AppState> store}) async {
    store.dispatch(StartLoading());
    Either either =
        await store.state.ordersState.ordersUSeCases.changeOrderStatusUseCase(orderId: orderId, statusId: statusId);
    either.fold((failure) => snackBar(context: context, success: false, message: 'حدث خطأ، يرجى المحاولة مجدداً'),
        (_) => snackBar(context: context, success: true, message: 'تم تغيير حالة الطلب بنجاح'));
    store.dispatch(StopLoading());
  }
}

class GetAllOrdersAction implements OrdersAction {
  final int pageNumber, filterEvaluatedOrders;
  final CancelToken cancelToken;

  GetAllOrdersAction({this.pageNumber, this.filterEvaluatedOrders, this.cancelToken});

  @override
  handle({Store<AppState> store}) async {
    store.dispatch(StartLoading());
    Either either = await store.state.ordersState.ordersUSeCases.getAllOrdersUseCase(
        cancelToken: cancelToken, filterEvaluatedOrders: filterEvaluatedOrders, pageNumber: pageNumber);
    either.fold((failure) => store.dispatch(CatchError(errorMessage: 'حدث خطأ، يرجى المحاولة مجدداً')), (orders) {
      store.dispatch(SetViewOrders(orders: orders));
    });
    store.dispatch(StopLoading());
  }
}

class GetOrderAction implements OrdersAction {
  final int orderId;
  final CancelToken cancelToken;

  GetOrderAction({this.orderId, this.cancelToken});

  @override
  handle({Store<AppState> store}) async {
    store.dispatch(StartLoading());
    Either either =
        await store.state.ordersState.ordersUSeCases.getOrderUseCase(cancelToken: cancelToken, orderId: orderId);
    either.fold((failure) => store.dispatch(CatchError(errorMessage: 'حدث خطأ، يرجى المحاولة مجدداً')),
        (orders) => store.dispatch(SetSearchOrders(orders: orders)));
    store.dispatch(StopLoading());
  }
}

class GetOrdersByUserNumberAction implements OrdersAction {
  final int pageNumber;
  final String phoneNumber;
  final CancelToken cancelToken;

  GetOrdersByUserNumberAction({this.pageNumber, this.cancelToken, this.phoneNumber});

  @override
  handle({Store<AppState> store}) async {
    store.dispatch(StartLoading());
    Either either = await store.state.ordersState.ordersUSeCases
        .getOrdersByUserNumberUseCase(cancelToken: cancelToken, pageNumber: pageNumber, phoneNumber: phoneNumber);
    either.fold((failure) => store.dispatch(CatchError(errorMessage: 'حدث خطأ، يرجى المحاولة مجدداً')),
        (orders) => store.dispatch(SetSearchOrders(orders: orders)));
    store.dispatch(StopLoading());
  }
}

class GetShopperOrdersAction implements OrdersAction {
  final int pageNumber;
  final CancelToken cancelToken;

  GetShopperOrdersAction({this.pageNumber, this.cancelToken});

  @override
  handle({Store<AppState> store}) async {
    store.dispatch(StartLoading());
    Either either = await store.state.ordersState.ordersUSeCases
        .getShopperOrdersUseCase(cancelToken: cancelToken, pageNumber: pageNumber);
    either.fold((failure) => store.dispatch(CatchError(errorMessage: 'حدث خطأ، يرجى المحاولة مجدداً')),
        (orders) => store.dispatch(SetViewOrders(orders: orders)));
    store.dispatch(StopLoading());
  }
}

class GetSupplierOrdersAction implements OrdersAction {
  final int pageNumber;
  final CancelToken cancelToken;

  GetSupplierOrdersAction({this.pageNumber, this.cancelToken});

  @override
  handle({Store<AppState> store}) async {
    store.dispatch(StartLoading());
    Either either = await store.state.ordersState.ordersUSeCases
        .getSupplierOrdersUseCase(cancelToken: cancelToken, pageNumber: pageNumber);
    either.fold((failure) => store.dispatch(CatchError(errorMessage: 'حدث خطأ، يرجى المحاولة مجدداً')),
        (orders) => store.dispatch(SetViewOrders(orders: orders)));
    store.dispatch(StopLoading());
  }
}

class LockOrderAction implements OrdersAction {
  final int orderId;

  LockOrderAction({this.orderId});

  @override
  handle({Store<AppState> store}) async {
    store.dispatch(StartLoading());
    Either either = await store.state.ordersState.ordersUSeCases.lockOrderUseCase(orderId: orderId);
    either.fold((failure) => store.dispatch(CatchError(errorMessage: 'حدث خطأ، يرجى المحاولة مجدداً')), (_) {
      //todo implement state
      List<OrderEntity> orders = store.state.ordersState.viewOrders;
      store.dispatch(SetViewOrders(orders: orders));
    });
    store.dispatch(StopLoading());
  }
}

class UnLockOrderAction implements OrdersAction {
  final int orderId;

  UnLockOrderAction({this.orderId});

  @override
  handle({Store<AppState> store}) async {
    store.dispatch(StartLoading());
    Either either = await store.state.ordersState.ordersUSeCases.unlockOrderUseCase(orderId: orderId);
    either.fold((failure) => store.dispatch(CatchError(errorMessage: 'حدث خطأ، يرجى المحاولة مجدداً')), (_) {
      //todo implement state
      List<OrderEntity> orders = store.state.ordersState.viewOrders;
      store.dispatch(SetViewOrders(orders: orders));
    });
    store.dispatch(StopLoading());
  }
}

class SetViewOrders {
  final List<OrderEntity> orders;

  SetViewOrders({this.orders});
}

class SetSearchOrders {
  final List<OrderEntity> orders;

  SetSearchOrders({this.orders});
}
