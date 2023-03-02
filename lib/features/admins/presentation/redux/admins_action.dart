import 'package:kammun_app/features/admins/domain/entities/admins_entity.dart';

class GetAdminsAction {}

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
