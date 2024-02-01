import 'package:kammun_app/features/users/domain/use_cases/change_number_phone_use_case.dart';

import '../../../../core/core_importer.dart';
import 'attach_user_to_coupon_use_case.dart';

class UsersUseCases {
  final AttachUserToCouponUseCase attachUserToCouponUseCase;
  final ChangeNumberPhoneUserUseCase changeNumberPhoneUserUseCase;

  UsersUseCases( {@required this.attachUserToCouponUseCase, @required this.changeNumberPhoneUserUseCase})
      : assert(attachUserToCouponUseCase != null, 'All use cases should be initialized.');
}
