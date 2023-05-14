import 'package:dartz/dartz.dart';

import '../../../../core/core_importer.dart';
import '../../domain/entities/account_statement_entity.dart';
import '../../domain/entities/remaining_statement_entity.dart';

abstract class SupplierAction {
  handle({@required Store<AppState> store});
}

class GetAccountStatementAction implements SupplierAction {
  final String from;
  final String to;

  GetAccountStatementAction({this.from, this.to});

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

class GetRemainingStatementAction implements SupplierAction {
  final String from;
  final String to;

  GetRemainingStatementAction({this.from, this.to});

  @override
  handle({Store<AppState> store}) async {
    store.dispatch(StartLoading());
    Either either = await store.state.supplierState.supplierUseCases.remainingStatementUseCase(to: to, from: from);
    either.fold((failure) => store.dispatch(CatchError(errorMessage: 'حدث خطأ')), (remaining) {
      List<RemainingStatementEntity> result = remaining;
      Tools.logToConsole(result.length);
      store.dispatch(SetRemainingStatment(remaining: result));
    });
    store.dispatch(StopLoading());
  }
}

class SetAccountStatement {
  final AccountStatementEntity accountStatement;

  SetAccountStatement({this.accountStatement});
}

class SetRemainingStatment {
  final List<RemainingStatementEntity> remaining;

  SetRemainingStatment({this.remaining});
}
