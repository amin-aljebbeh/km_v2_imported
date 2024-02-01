import 'package:dartz/dartz.dart';

import '../../../../core/core_importer.dart';
import '../../../coupons/presentation/redux/coupon_action.dart';
import '../../../orders/presentation/redux/orders_action.dart';
import '../../domain/entities/user_entity.dart';

abstract class UsersAction {
  handle({@required Store<AppState> store});
}

class AttachUserToCouponAction implements UsersAction {
  final BuildContext context;
  final int couponId;
  final int availability;

  AttachUserToCouponAction({this.couponId, this.availability, this.context});

  @override
  handle({Store<AppState> store}) async {
    store.dispatch(StartLoading());
    Either either = await store.state.usersState.usersUseCases.attachUserToCouponUseCase(
        availability: availability, couponId: couponId, userId: store.state.usersState.userEntity.id);
    either.fold((failure) => store.dispatch(CatchError(errorMessage: 'حدث خطأ، يرجى المحاولة مجدداً')),
        (_) => snackBar(message: 'تمت العملية بنجاح', success: true, context: context));
    store.dispatch(StopLoading());
  }
}

class ChangeNumberPhoneUserAction implements UsersAction {
  final BuildContext context;
  final int couponId;
  final String phoneNumber;

  ChangeNumberPhoneUserAction({this.couponId, this.phoneNumber, this.context});

  @override
  handle({Store<AppState> store}) async {
    store.dispatch(StartLoading());
    Either either = await store.state.usersState.usersUseCases.changeNumberPhoneUserUseCase(
        phoneNumber: phoneNumber, userId: store.state.usersState.userEntity.id);
    either.fold((failure) => store.dispatch(CatchError(errorMessage: 'الرقم مستخدم مسبقاً')),
            (_) {
              store.dispatch(GetAllOrdersAction());
              snackBar(message: 'تمت تغيير رقم الزبون بنجاح', success: true, context: context);
            } );
    store.dispatch(StopLoading());
  }
}

class SetUser {
  final UserEntity userEntity;

  SetUser({this.userEntity});
}
