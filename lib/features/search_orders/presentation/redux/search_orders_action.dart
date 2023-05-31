import 'package:dartz/dartz.dart';
import 'package:kammun_app/core/core_importer.dart';

import '../../../orders_feature/domain/entities/order_entity.dart';

abstract class SearchOrdersAction {
  handle({@required Store<AppState> store});
}

class SearchOrderAction implements SearchOrdersAction {
  @override
  handle({Store<AppState> store}) {
    // TODO: implement handle
    throw UnimplementedError();
  }
}

class GetOrderAction implements SearchOrdersAction {
  final int orderId;
  final CancelToken cancelToken;

  GetOrderAction({this.orderId, this.cancelToken});

  @override
  handle({Store<AppState> store}) async {
    store.dispatch(StartLoading());
    Either either = await store.state.searchOrdersState.searchOrdersUSeCases
        .getOrderUseCase(cancelToken: cancelToken, orderId: orderId);
    either.fold((failure) => store.dispatch(CatchError(errorMessage: 'حدث خطأ، يرجى المحاولة مجدداً')),
        (orders) => store.dispatch(SetSearchOrders(orders: orders)));
    store.dispatch(StopLoading());
  }
}

class GetOrdersByUserNumberAction implements SearchOrdersAction {
  final String phoneNumber;
  final CancelToken cancelToken;

  GetOrdersByUserNumberAction({this.cancelToken, this.phoneNumber});

  @override
  handle({Store<AppState> store}) async {
    store.dispatch(StartLoading());
    Either either = await store.state.searchOrdersState.searchOrdersUSeCases.getOrdersByUserNumberUseCase(
        cancelToken: cancelToken, pageNumber: store.state.searchOrdersState.page, phoneNumber: phoneNumber);
    either.fold((failure) => store.dispatch(CatchError(errorMessage: 'حدث خطأ، يرجى المحاولة مجدداً')),
        (orders) => store.dispatch(SetSearchOrders(orders: orders)));
    store.dispatch(StopLoading());
  }
}

class SetSearchOrders {
  final List<OrderEntity> orders;

  SetSearchOrders({this.orders});
}

class SetSearchStatusFilter {
  final int filter;

  SetSearchStatusFilter({this.filter});
}

class SetSearchPage {
  final int page;

  SetSearchPage({this.page});
}

class SetSearchOrdersType {
  final SearchOrdersTypes searchOrdersType;

  SetSearchOrdersType({this.searchOrdersType});
}
