import 'package:kammun_app/features/admins/domain/entities/role_pivot_entity.dart';

class RolePivotModel extends RolePivotEntity {
  RolePivotModel({adminId, roleId}) : super(adminId: adminId, roleId: roleId);

  factory RolePivotModel.fromJson(Map<String, dynamic> json) =>
      RolePivotModel(adminId: json['admin_id'], roleId: json['role_id']);

  Map<String, dynamic> toJson() => {'admin_id': adminId, 'role_id': roleId};
}
