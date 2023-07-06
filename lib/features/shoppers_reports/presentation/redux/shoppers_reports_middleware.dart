import 'package:kammun_app/features/shoppers_reports/presentation/redux/shoppers_reports_action.dart';

import '../../../../core/core_importer.dart';

Future<void> shopperReportsMiddleware(Store<AppState> store, action, NextDispatcher next) async {
  if (action is ShoppersReportsAction) action.handle(store: store, state: store.state.shoppersReportsState);
  next(action);
}
