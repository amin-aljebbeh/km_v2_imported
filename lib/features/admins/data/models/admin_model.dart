import 'package:kammun_app/features/admins/data/models/role_model.dart';
import 'package:kammun_app/features/admins/domain/entities/admins_entity.dart';
import 'package:kammun_app/features/general_information/data/models/sub_warehouse_model.dart';

import '../../../shoppers/data/models/shopper_model.dart';

class AdminModel extends AdminEntity {
  const AdminModel(
      {id,
      username,
      name,
      firebaseToken,
      phone,
      apiToken,
      subWarehouses,
      roles,
      shopper,
      permissions,
      balance,
      warehouseId})
      : super(
          id: id,
          name: name,
          apiToken: apiToken,
          firebaseToken: firebaseToken,
          phone: phone,
          shopper: shopper,
          roles: roles,
          subWarehouses: subWarehouses,
          username: username,
          permissions: permissions,
          balance: balance,
          warehouseId: warehouseId,
        );

  factory AdminModel.fromJson(Map<String, dynamic> json) => AdminModel(
        id: json['id'],
        username: json['username'],
        warehouseId: json['warehouse_id'],
        firebaseToken: json['firebase_token'],
        name: json['name'],
        balance: json['balance'],
        phone: json['phone'],
        apiToken: json['api_token'],
        permissions: json['permissions'] != null ? List<String>.from(json['permissions'].map((x) => x)) : [''],
        subWarehouses: json['sub_warehouses'] == null
            ? null
            : List<SubWarehouseModel>.from(json['sub_warehouses'].map((x) => SubWarehouseModel.fromJson(x))),
        roles: json['roles'] == null ? null : List<RoleModel>.from(json['roles'].map((x) => RoleModel.fromJson(x))),
        shopper: json['shopper'] == null ? null : ShopperModel.fromJson(json['shopper']),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'username': username,
        'name': name,
        'phone': phone,
        'api_token': apiToken,
      };
}
