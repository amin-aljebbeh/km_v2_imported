import 'package:kammun_app/views/error/presentation/redux/error_reducer.dart';
import 'package:kammun_app/views/inventory_feature/presentation/redux/inventory_reducer.dart';
import 'package:kammun_app/views/loading_feature/presentation/redux/loading_reducer.dart';
import 'package:kammun_app/views/supplier/presentation/redux/supplier_reducer.dart';

import '../views/complaints/presentation/redux/complaints_reducer.dart';
import 'redux_importer.dart';

AppState appReducer(AppState state, dynamic action) {
  if (action is RestartApp) return AppState.initial();
  return AppState(
      inventoryState: inventoryReducer(state.inventoryState, action),
      loadingState: loadingReducer(state.loadingState, action),
      errorState: errorReducer(state.errorState, action),
      supplierState: supplierReducer(state.supplierState, action),
      complaintsState: complaintsReducer(state.complaintsState, action));
}
