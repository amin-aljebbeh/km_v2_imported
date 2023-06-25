import 'package:kammun_app/features/admins/domain/entities/admins_entity.dart';

class AdminLoginResponseEntity {
  AdminLoginResponseEntity({this.success, this.admin});

  bool success;
  AdminEntity admin;
}
