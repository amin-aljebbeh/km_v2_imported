import '../../../../core/core_importer.dart';
import '../../domain/entities/user_entity.dart';

class AttachUserToCouponAction {
  final BuildContext context;
  final int couponId;
  final int availability;

  AttachUserToCouponAction({this.couponId, this.availability, this.context});
}

class SetUser {
  final UserEntity userEntity;

  SetUser({this.userEntity});
}
