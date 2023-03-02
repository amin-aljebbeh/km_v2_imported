import 'package:kammun_app/core/core_importer.dart';

import 'get_admins_use_case.dart';
import 'get_transactions_actors_use_case.dart';

class AdminsUseCases {
  final GetAdminsUseCase getAdminsUseCase;
  final GetTransactionsActorsUseCase getTransactionsActorsUseCase;

  AdminsUseCases({@required this.getAdminsUseCase, @required this.getTransactionsActorsUseCase})
      : assert(getAdminsUseCase != null && getTransactionsActorsUseCase != null, 'All use cases should be initialized');
}
