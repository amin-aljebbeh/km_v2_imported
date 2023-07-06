import 'package:dartz/dartz.dart';
import 'package:kammun_app/core/core_importer.dart';
import 'package:kammun_app/features/reports/domain/entities/financial_report_entity.dart';
import 'package:kammun_app/features/reports/presentation/redux/reports_state.dart';

import '../../domain/entities/get_daily_statistics_entity.dart';

abstract class ReportsAction {
  handle({@required Store<AppState> store, ReportsState state});
}

class GetFinancialReportAction extends ReportsAction {
  final String fromDate, toDate;

  GetFinancialReportAction({this.fromDate, this.toDate});

  @override
  handle({Store<AppState> store, ReportsState state}) async {
    store.dispatch(StartLoading());
    Either either = await state.reportsUSeCases.getFinancialReportUseCase(fromDate: fromDate, toDate: toDate);
    either.fold((failure) => store.dispatch(CatchError(errorMessage: errorMessage)), (response) {
      FinancialReportEntity report = response;
      store.dispatch(SetFinancialReport(report: report));
    });
    store.dispatch(StopLoading());
  }
}

class GetSalesReportsAction extends ReportsAction {
  final String fromDate, toDate;

  GetSalesReportsAction({this.fromDate, this.toDate});

  @override
  handle({Store<AppState> store, ReportsState state}) async {
    store.dispatch(StartLoading());
    Either either = await state.reportsUSeCases.getSalesReportsUseCase(fromDate: fromDate, toDate: toDate);
    either.fold((failure) => store.dispatch(CatchError(errorMessage: errorMessage)), (response) {
      DailyStatisticsEntity report = response;
      store.dispatch(SetSalesReports(statistic: report));
    });
    store.dispatch(StopLoading());
  }
}

class SetFinancialReport {
  final FinancialReportEntity report;

  SetFinancialReport({this.report});
}

class SetSalesReports {
  final DailyStatisticsEntity statistic;

  SetSalesReports({this.statistic});
}

class InitReport {}
