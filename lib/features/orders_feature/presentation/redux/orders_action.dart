import 'package:dartz/dartz.dart';
import 'package:kammun_app/core/core_importer.dart';

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
