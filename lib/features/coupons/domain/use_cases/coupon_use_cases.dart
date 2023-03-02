import '../../../../core/core_importer.dart';
import 'get_coupons_use_case.dart';
import 'get_users_coupons_use_case.dart';

class CouponsUseCases {
  final GetCouponsUseCase getCouponsUseCase;
  final GetUserCouponsUseCase getUSerCouponsUseCase;

  CouponsUseCases({@required this.getCouponsUseCase, @required this.getUSerCouponsUseCase})
      : assert(getCouponsUseCase != null && getUSerCouponsUseCase != null, 'All use cases should be initialized.');
}
