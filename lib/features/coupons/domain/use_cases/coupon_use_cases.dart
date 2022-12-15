import '../../../../core/core_importer.dart';
import 'get_coupons_use_case.dart';

class CouponsUseCases {
  final GetCouponsUseCase getCouponsUseCase;

  CouponsUseCases({@required this.getCouponsUseCase})
      : assert(getCouponsUseCase != null, 'All use cases should be initialized.');
}
