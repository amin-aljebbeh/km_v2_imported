import 'package:kammun_app/core/core_importer.dart';

class AccountStatementEntity extends Equatable {
  const AccountStatementEntity({this.accountStatement});

  final List<List<String>> accountStatement;

  @override
  List<Object> get props => [accountStatement];
}
