import 'package:dartz/dartz.dart';

import '../../../../core/core_importer.dart';
import '../../domain/entities/supplier_account_statement_entity.dart';

abstract class SupplierAction {
  handle({@required Store<AppState> store});
}

class GetAccountStatement implements SupplierAction {
  final String from;
  final String to;

  GetAccountStatement({this.from, this.to});

  @override
  handle({Store<AppState> store}) async {
    store.dispatch(StartLoading());
    Either either =
        await store.state.supplierState.supplierUseCases.getSupplierAccountStatementUseCase(to: to, from: from);
    either.fold((failure) => store.dispatch(CatchError(errorMessage: 'حدث خطأ')), (accountStatementEntity) {
      AccountStatementEntity accountStatement = accountStatementEntity;
      store.dispatch(SetAccountStatement(accountStatement: accountStatement));
    });
    store.dispatch(StopLoading());
  }
}

class SetAccountStatement {
  final AccountStatementEntity accountStatement;

  SetAccountStatement({this.accountStatement});
}
