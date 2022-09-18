import '../../domain/entities/supplier_account_statement_entity.dart';

class GetAccountStatement {
  final String from;
  final String to;

  GetAccountStatement({this.from, this.to});
}

class SetAccountStatement {
  final AccountStatementEntity accountStatement;

  SetAccountStatement({this.accountStatement});
}
