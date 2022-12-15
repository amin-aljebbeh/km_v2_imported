import 'package:kammun_app/features/users/domain/use_cases/deposit_user_wallet_use_case.dart';

import '../../../../core/core_importer.dart';
import 'attach_user_to_coupon_use_case.dart';

class UsersUseCases {
  final AttachUserToCouponUseCase attachUserToCouponUseCase;
  final DepositUserWalletUseCase depositUserWalletUseCase;

  UsersUseCases({@required this.attachUserToCouponUseCase, @required this.depositUserWalletUseCase})
      : assert(attachUserToCouponUseCase != null && depositUserWalletUseCase != null,
            'All use cases should be initialized.');
}
