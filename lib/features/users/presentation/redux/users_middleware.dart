import 'package:dartz/dartz.dart';
import 'package:kammun_app/features/users/presentation/redux/users_action.dart';

import '../../../../core/core_importer.dart';

Future<void> usersMiddleware(Store<AppState> store, action, NextDispatcher next) async {
  if (action is AttachUserToCouponAction) {
    store.dispatch(StartLoading());
    Either either = await store.state.usersState.usersUseCases.attachUserToCouponUseCase(
        availability: action.availability, couponId: action.couponId, userId: store.state.usersState.userEntity.id);
    either.fold((failure) => store.dispatch(CatchError(errorMessage: 'حدث خطأ، يرجى المحاولة مجدداً')),
        (_) => store.dispatch(ViewMessage(message: 'تمت العملية بنجاح')));
    store.dispatch(StopLoading());
  }
  next(action);
}
