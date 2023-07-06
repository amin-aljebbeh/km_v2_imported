import '../../../../core/core_importer.dart';
import 'get_monthly_shopper_reports_use_case.dart';
import 'get_shopper_activity_hours_use_case.dart';
import 'get_shopper_working_hours_use_case.dart';

class ShoppersReportsUseCases {
  final GetMonthlyShopperReportsUseCase getMonthlyShopperReportsUseCase;
  final GetShopperActivityHoursUseCase getShopperActivityHoursUseCase;
  final GetShopperWorkingHoursUseCase getShopperWorkingHoursUseCase;

  ShoppersReportsUseCases({
    @required this.getMonthlyShopperReportsUseCase,
    @required this.getShopperActivityHoursUseCase,
    @required this.getShopperWorkingHoursUseCase,
  }) : assert(
            getMonthlyShopperReportsUseCase != null &&
                getShopperActivityHoursUseCase != null &&
                getShopperWorkingHoursUseCase != null,
            'All use cases should ne initialized.');
}
