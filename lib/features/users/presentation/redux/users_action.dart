import '../../../../core/core_importer.dart';
import '../../domain/entities/user_entity.dart';

class AttachUserToCouponAction {
  final BuildContext context;
  final int couponId;
  final int availability;

  AttachUserToCouponAction({this.couponId, this.availability, this.context});
}

class DepositUserWalletAction {
  final BuildContext context;
  final int value;
  final String description;

  DepositUserWalletAction({this.value, this.context, this.description});
}

class SetUser {
  final UserEntity userEntity;

  SetUser({this.userEntity});
}
