import 'package:dartz/dartz.dart';
import 'package:kammun_app/core/core_importer.dart';

import '../../domain/entities/activity_hours_entity.dart';
import '../../domain/entities/shopper_monthly_report_entity.dart';
import '../../domain/entities/shopper_working_hours_entity.dart';
import 'shoppers_reports_state.dart';

abstract class ShoppersReportsAction {
  handle({@required Store<AppState> store, ShoppersReportsState state});
}

class GetActivityHoursAction extends ShoppersReportsAction {
  final String shopperId, fromDate, toDate;

  GetActivityHoursAction({this.shopperId, this.fromDate, this.toDate});

  @override
  handle({Store<AppState> store, ShoppersReportsState state}) async {
    store.dispatch(StartLoading());
    Either either = await state.shoppersReportsUseCases
        .getShopperActivityHoursUseCase(shopperId: shopperId, fromDate: fromDate, toDate: toDate);
    either.fold((failure) => store.dispatch(CatchError(errorMessage: errorMessage)),
        (response) => store.dispatch(SetActivityHours(activityHours: response)));
    store.dispatch(StopLoading());
  }
}

class GetWorkingHoursAction extends ShoppersReportsAction {
  final String shopperId;
  final String filterBy;

  GetWorkingHoursAction({this.shopperId, this.filterBy});

  @override
  handle({Store<AppState> store, ShoppersReportsState state}) async {
    store.dispatch(StartLoading());
    Either either =
        await state.shoppersReportsUseCases.getShopperWorkingHoursUseCase(shopperId: shopperId, filterBy: filterBy);
    either.fold((failure) => store.dispatch(CatchError(errorMessage: errorMessage)),
        (response) => store.dispatch(SetWorkingHours(workingHours: response)));
    store.dispatch(StopLoading());
  }
}

class GetMonthlyReportAction extends ShoppersReportsAction {
  final String shopperId;

  GetMonthlyReportAction({this.shopperId});

  @override
  handle({Store<AppState> store, ShoppersReportsState state}) async {
    store.dispatch(StartLoading());
    Either either = await state.shoppersReportsUseCases
        .getMonthlyShopperReportsUseCase(shopperId: shopperId);
    either.fold((failure) => store.dispatch(CatchError(errorMessage: errorMessage)),
        (response) => store.dispatch(SetMonthlyReport(monthlyReport: response)));
    store.dispatch(StopLoading());
  }
}

class SetActivityHours {
  final List<ActivityHoursEntity> activityHours;

  SetActivityHours({this.activityHours});
}

class SetWorkingHours {
  final List<ShopperWorkingHoursEntity> workingHours;

  SetWorkingHours({this.workingHours});
}

class SetMonthlyReport {
  final List<ShopperMonthlyReportEntity> monthlyReport;

  SetMonthlyReport({this.monthlyReport});
}

class InitShoppersReport {}
