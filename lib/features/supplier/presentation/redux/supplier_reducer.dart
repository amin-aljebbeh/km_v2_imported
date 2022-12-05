import '../../../../core/core_importer.dart';
import 'supplier_action.dart';
import 'supplier_state.dart';

Reducer<SupplierState> supplierReducer = combineReducers<SupplierState>([
  TypedReducer<SupplierState, SetAccountStatement>(setAccountStatement),
]);

SupplierState setAccountStatement(SupplierState state, SetAccountStatement action) =>
    state.copyWith(accountStatement: action.accountStatement);
