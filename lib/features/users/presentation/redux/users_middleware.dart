import 'package:dartz/dartz.dart';
import 'package:kammun_app/features/users/presentation/redux/users_action.dart';

import '../../../../core/core_importer.dart';

Future<void> usersMiddleware(Store<AppState> store, action, NextDispatcher next) async {
  switch (action.runtimeType) {
    case AttachUserToCouponAction:
      var actionType = action as AttachUserToCouponAction;
      store.dispatch(StartLoading());
      Either either = await store.state.usersState.usersUseCases.attachUserToCouponUseCase(
          availability: actionType.availability, couponId: actionType.couponId, userId: actionType.userId);
      either.fold((failure) => store.dispatch(CatchError(errorMessage: 'حدث خطأ، يرجى المحاولة مجدداً')),
          (_) => store.dispatch(ViewMessage(message: 'تمت العملية بنجاح')));
      store.dispatch(StopLoading());
      break;
    case DepositUserWalletAction:
      var actionType = action as DepositUserWalletAction;
      store.dispatch(StartLoading());
      Either either = await store.state.usersState.usersUseCases.depositUserWalletUseCase(
          value: actionType.value, userId: actionType.userId, description: actionType.description);
      either.fold(
          (failure) => snackBar(message: 'حدث خطأ، يرجى المحاولة مجدداً', context: actionType.context, success: false),
          (_) => snackBar(message: 'تمت العملية بنجاح', context: actionType.context, success: true));
      store.dispatch(StopLoading());
      break;
  }
  next(action);
}
