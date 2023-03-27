import 'package:kammun_app/features/admins/domain/entities/admins_entity.dart';
import 'package:kammun_app/features/admins/domain/entities/role_entity.dart';

class GetAdminsWithoutDetailsAction {
  final int roleId;
  final int warehouseId;
  final String searchName;

  GetAdminsWithoutDetailsAction({this.roleId, this.warehouseId, this.searchName});
}

class GetRolesAction {}

class SetRoles {
  final List<RoleEntity> roles;

  SetRoles({this.roles});
}

class GetTransactionsActorsAction {
  final int categoryId;

  GetTransactionsActorsAction({this.categoryId});
}

class SetAdmins {
  final List<AdminEntity> admins;

  SetAdmins({this.admins});
}

class SetTransactionsActors {
  final List<AdminEntity> admins;

  SetTransactionsActors({this.admins});
}

class SetAdmin {
  final AdminEntity admin;

  SetAdmin({this.admin});
}
