import 'package:dartz/dartz.dart';
import 'package:kammun_app/core/core_importer.dart';
import 'package:kammun_app/features/search_orders/domain/entities/get_order_response_entity.dart';

import '../../../orders/domain/entities/order_entity.dart';
import '../../../orders/orders_services.dart';
import '../pages/search_orders_page.dart';

abstract class SearchOrdersAction {
  handle({@required Store<AppState> store});
}

class SearchOrderAction implements SearchOrdersAction {
  final SearchOrdersTypes searchOrdersType;
  final BuildContext context;

  SearchOrderAction({this.searchOrdersType, this.context});

  @override
  handle({Store<AppState> store}) {
    ApiProvider.cancelOrdersRequests();
    store.dispatch(StartLoading());
    store.dispatch(SetSearchOrders(orders: []));
    store.dispatch(SetSearchStatusFilter(filter: 0));
    store.dispatch(SetSearchPage(page: 1));
    store.dispatch(SetSearchOrdersType(searchOrdersType: searchOrdersType));
    switch (searchOrdersType) {
      case SearchOrdersTypes.phoneNumber:
        store.dispatch(GetOrdersByUserNumberAction(phoneNumber: store.state.searchOrdersState.phoneNumber));
        break;
      case SearchOrdersTypes.id:
        store.dispatch(GetOrderAction(orderId: store.state.searchOrdersState.id));
        break;
      case SearchOrdersTypes.none:
        break;
      /*default:
        return store.dispatch(GetOrderAction(orderId: store.state.searchOrdersState.id));*/
    }
    Navigator.push(context, MaterialPageRoute(builder: (screenContext) => const SearchOrdersPage()));
  }
}

class GetOrderAction implements SearchOrdersAction {
  final int orderId;

  GetOrderAction({this.orderId});

  @override
  handle({Store<AppState> store}) async {
    Either either = await store.state.searchOrdersState.searchOrdersUSeCases
        .getOrderUseCase(cancelToken: OrdersServices.cancelRequest, orderId: orderId);
    either.fold((failure) {}, (response) {
      GetOrderResponseEntity order = response;
      store.dispatch(SetSearchOrders(orders: [order.order]));

    });
    store.dispatch(StopLoading());
  }
}

class GetOrdersByUserNumberAction implements SearchOrdersAction {
  final String phoneNumber;

  GetOrdersByUserNumberAction({this.phoneNumber});

  @override
  handle({Store<AppState> store}) async {
    Either either = await store.state.searchOrdersState.searchOrdersUSeCases.getOrdersByUserNumberUseCase(
        cancelToken: OrdersServices.cancelRequest,
        pageNumber: store.state.searchOrdersState.page,
        phoneNumber: phoneNumber);
    either.fold((failure) => store.dispatch(CatchError(errorMessage: 'حدث خطأ، يرجى المحاولة مجدداً')),
        (orders) => store.dispatch(FilterSearchOrders(orders: orders)));
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

class SetPhoneNumber {
  final String phoneNumber;

  SetPhoneNumber({this.phoneNumber});
}

class SetId {
  final int id;

  SetId({this.id});
}

class FilterSearchOrders extends SearchOrdersAction {
  final List<OrderEntity> orders;

  FilterSearchOrders({this.orders});

  @override
  handle({Store<AppState> store}) {
    if (store.state.searchOrdersState.statusFilter != 0) {
      if (store.state.searchOrdersState.statusFilter == 1) {
        orders.removeWhere((order) => int.parse(order.orderStatusId) > 4);
      } else {
        orders.removeWhere((order) => int.parse(order.orderStatusId) != store.state.searchOrdersState.statusFilter - 1);
      }
    }

    orders.removeWhere((order) => order.products.isEmpty);
    store.dispatch(SetSearchOrders(orders: orders));
  }
}
