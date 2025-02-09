import 'package:kammun_app/features/admins/domain/entities/create_admin_entity.dart';

class CreateAdminModel extends CreateAdminEntity {
  const CreateAdminModel({name, userName, password, warehouseId, isSuperUser})
      : super(warehouseId: warehouseId, isSuperUser: isSuperUser, name: name, password: password, userName: userName);

  Map<String, dynamic> toJson() => {
        'name': name,
        'username': userName,
        'password': password,
        'warehouse_id': warehouseId,
        'is_super_user': isSuperUser ? 1 : 0,
      };
}
