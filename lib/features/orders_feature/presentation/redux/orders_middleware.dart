import 'package:dartz/dartz.dart';
import 'package:kammun_app/features/orders_feature/presentation/redux/orders_action.dart';

import '../../../../core/core_importer.dart';

Future<void> ordersMiddleware(Store<AppState> store, action, NextDispatcher next) async {
  if (action is ReAssignOrderAction) {
    store.dispatch(StartLoading());
    Either either = await store.state.ordersState.ordersUSeCases.reAssignOrderUseCase(orderId: action.orderId);
    either.fold((failure) => store.dispatch(CatchError(errorMessage: 'حدث خطأ، يرجى المحاولة مجدداً')),
        (_) => store.dispatch(ViewMessage(message: 'تمت العملية بنجاح')));
    store.dispatch(StopLoading());
  }
  next(action);
}
