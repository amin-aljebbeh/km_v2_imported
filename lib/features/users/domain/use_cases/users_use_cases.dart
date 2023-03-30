import '../../../../core/core_importer.dart';
import 'attach_user_to_coupon_use_case.dart';

class UsersUseCases {
  final AttachUserToCouponUseCase attachUserToCouponUseCase;

  UsersUseCases({@required this.attachUserToCouponUseCase})
      : assert(attachUserToCouponUseCase != null, 'All use cases should be initialized.');
}
