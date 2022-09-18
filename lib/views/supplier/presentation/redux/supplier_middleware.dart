import 'package:dartz/dartz.dart';
import 'package:kammun_app/views/error/presentation/redux/error_action.dart';

import '../../../../core/core_importer.dart';
import '../../domain/entities/supplier_account_statement_entity.dart';
import 'supplier_action.dart';

Future<void> supplierMiddleware(Store<AppState> store, action, NextDispatcher next) async {
  if (action is GetAccountStatement) {
    store.dispatch(StartLoading());
    Either either = await store.state.supplierState.supplierRepository
        .getSupplierAccountStatement(to: action.to, from: action.from);
    either.fold((failure) => store.dispatch(CatchError(errorMessage: 'حدث خطأ')), (accountStatementEntity) {
      AccountStatementEntity accountStatement = accountStatementEntity;
      store.dispatch(SetAccountStatement(accountStatement: accountStatement));
    });
    store.dispatch(StopLoading());
  }
  next(action);
}
