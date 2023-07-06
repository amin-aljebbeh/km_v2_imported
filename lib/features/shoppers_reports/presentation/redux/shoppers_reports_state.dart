import 'package:kammun_app/features/shoppers_reports/domain/use_cases/shoppers_reports_use_cases.dart';

import '../../../../core/core_importer.dart';
import '../../domain/entities/activity_hours_entity.dart';
import '../../domain/entities/shopper_monthly_report_entity.dart';
import '../../domain/entities/shopper_working_hours_entity.dart';

@immutable
class ShoppersReportsState extends Equatable {
  final ShoppersReportsUseCases shoppersReportsUseCases;
  final List<ActivityHoursEntity> activityHours;
  final List<ShopperWorkingHoursEntity> workingHours;
  final List<ShopperMonthlyReportEntity> monthlyReport;

  const ShoppersReportsState({this.shoppersReportsUseCases, this.activityHours, this.workingHours, this.monthlyReport});

  factory ShoppersReportsState.initial() {
    return ShoppersReportsState(
        shoppersReportsUseCases: sl<ShoppersReportsUseCases>(),
        activityHours: const [],
        workingHours: const [],
        monthlyReport: const []);
  }

  ShoppersReportsState copyWith({
    List<ActivityHoursEntity> activityHours,
    List<ShopperWorkingHoursEntity> workingHours,
    List<ShopperMonthlyReportEntity> monthlyReport,
  }) {
    return ShoppersReportsState(
      activityHours: activityHours ?? this.activityHours,
      workingHours: workingHours ?? this.workingHours,
      monthlyReport: monthlyReport ?? this.monthlyReport,
      shoppersReportsUseCases: shoppersReportsUseCases,
    );
  }

  @override
  List<Object> get props => [activityHours, workingHours, monthlyReport, shoppersReportsUseCases];
}
