import 'package:kammun_app/features/admins/domain/entities/admins_entity.dart';

class GetAdminsAction {}

class SetAdmins {
  final List<AdminEntity> admins;

  SetAdmins({this.admins});
}
