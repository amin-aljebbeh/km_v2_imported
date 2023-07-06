import '../../../../core/core_importer.dart';
import 'shoppers_reports_action.dart';
import 'shoppers_reports_state.dart';

Reducer<ShoppersReportsState> shopperReportsReducer = combineReducers<ShoppersReportsState>([
  TypedReducer<ShoppersReportsState, SetActivityHours>(setActivityHours),
  TypedReducer<ShoppersReportsState, SetWorkingHours>(setWorkingHours),
  TypedReducer<ShoppersReportsState, SetMonthlyReport>(setMonthlyReport),
  TypedReducer<ShoppersReportsState, InitShoppersReport>(initReport),
]);

ShoppersReportsState setActivityHours(ShoppersReportsState state, SetActivityHours action) {
  return state.copyWith(activityHours: action.activityHours);
}

ShoppersReportsState setWorkingHours(ShoppersReportsState state, SetWorkingHours action) {
  return state.copyWith(workingHours: action.workingHours);
}

ShoppersReportsState setMonthlyReport(ShoppersReportsState state, SetMonthlyReport action) {
  return state.copyWith(monthlyReport: action.monthlyReport);
}

ShoppersReportsState initReport(ShoppersReportsState state, InitShoppersReport action) {
  return state.copyWith(monthlyReport: [], workingHours: [], activityHours: []);
}
