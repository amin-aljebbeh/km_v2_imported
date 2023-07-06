import '../../../../core/core_importer.dart';
import 'reports_action.dart';
import 'reports_state.dart';

Reducer<ReportsState> reportsReducer = combineReducers<ReportsState>([
  TypedReducer<ReportsState, SetFinancialReport>(setFinancialReport),
  TypedReducer<ReportsState, SetSalesReports>(setDailyStatistic),
  TypedReducer<ReportsState, InitReport>(initReport),
]);

ReportsState setFinancialReport(ReportsState state, SetFinancialReport action) {
  return state.copyWith(financialReportEntity: action.report);
}

ReportsState setDailyStatistic(ReportsState state, SetSalesReports action) {
  return state.copyWith(dailyStatisticsEntity: action.statistic);
}

ReportsState initReport(ReportsState state, InitReport action) {
  return ReportsState(reportsUSeCases: state.reportsUSeCases);
}
