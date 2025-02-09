import 'package:kammun_app/core/core_importer.dart';

import 'create_admin_use_case.dart';
import 'get_admin_use_case.dart';
import 'get_admins_use_case.dart';
import 'get_roles_use_case.dart';
import 'get_transactions_actors_use_case.dart';

class AdminsUseCases {
  final GetAdminsWithoutDetailsUseCase getAdminsWithoutDetailsUseCase;
  final GetTransactionsActorsUseCase getTransactionsActorsUseCase;
  final CreateAdminUseCase createAdminUseCase;
  final GetAdminUseCase getAdminUseCase;
  final GetRolesUseCase getRolesUseCase;

  AdminsUseCases({
    @required this.getAdminsWithoutDetailsUseCase,
    @required this.getTransactionsActorsUseCase,
    @required this.createAdminUseCase,
    @required this.getRolesUseCase,
    @required this.getAdminUseCase,
  }) : assert(
          getAdminsWithoutDetailsUseCase != null &&
              getTransactionsActorsUseCase != null &&
              createAdminUseCase != null &&
              getRolesUseCase != null &&
              getAdminUseCase != null,
          'All use cases should be initialized',
        );
}
