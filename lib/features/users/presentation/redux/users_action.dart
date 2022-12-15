import '../../../../core/core_importer.dart';

class AttachUserToCouponAction {
  final BuildContext context;
  final int couponId;
  final int userId;
  final int availability;

  AttachUserToCouponAction({this.couponId, this.userId, this.availability, this.context});
}

class DepositUserWalletAction {
  final BuildContext context;
  final int userId;
  final int value;
  final String description;

  DepositUserWalletAction({this.userId, this.value, this.context, this.description});
}
