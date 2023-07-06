import '../../../../core/core_importer.dart';
import '../../domain/entities/financial_report_entity.dart';
import '../../domain/entities/get_daily_statistics_entity.dart';
import '../../domain/use_cases/reports_use_cases.dart';

@immutable
class ReportsState extends Equatable {
  final ReportsUseCases reportsUSeCases;
  final FinancialReportEntity financialReportEntity;
  final DailyStatisticsEntity dailyStatisticsEntity;

  const ReportsState({this.reportsUSeCases, this.financialReportEntity, this.dailyStatisticsEntity});

  factory ReportsState.initial() {
    return ReportsState(reportsUSeCases: sl<ReportsUseCases>());
  }

  ReportsState copyWith({FinancialReportEntity financialReportEntity, DailyStatisticsEntity dailyStatisticsEntity}) {
    return ReportsState(
      financialReportEntity: financialReportEntity ?? this.financialReportEntity,
      dailyStatisticsEntity: dailyStatisticsEntity ?? this.dailyStatisticsEntity,
      reportsUSeCases: reportsUSeCases,
    );
  }

  @override
  List<Object> get props => [financialReportEntity, dailyStatisticsEntity, reportsUSeCases];
}
