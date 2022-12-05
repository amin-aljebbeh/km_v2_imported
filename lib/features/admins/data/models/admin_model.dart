import 'package:kammun_app/core/models/models_importer.dart';
import 'package:kammun_app/features/admins/domain/entities/admins_entity.dart';

class AdminModel extends AdminEntity {
  const AdminModel({id, username, name, phone, apiToken, subWarehouses, roles, shopper})
      : super(
          id: id,
          name: name,
          apiToken: apiToken,
          phone: phone,
          shopper: shopper,
          roles: roles,
          subWarehouses: subWarehouses,
          username: username,
        );

  factory AdminModel.fromJson(Map<String, dynamic> json) => AdminModel(
        id: json['id'],
        username: json['username'],
        name: json['name'],
        phone: json['phone'],
        apiToken: json['api_token'],
        subWarehouses: json['sub_warehouses'] == null
            ? null
            : List<SubWarehouse>.from(json['sub_warehouses'].map((x) => SubWarehouse.fromJson(x))),
        roles: json['roles'] == null ? null : List<Role>.from(json['roles'].map((x) => Role.fromJson(x))),
        shopper: json['shopper'] == null ? null : ShopperModel.fromJson(json['shopper']),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'username': username,
        'name': name,
        'phone': phone,
        'api_token': apiToken,
        'sub_warehouses': subWarehouses == null ? null : List<dynamic>.from(subWarehouses.map((x) => x.toJson())),
        'roles': roles == null ? null : List<dynamic>.from(roles.map((x) => x.toJson())),
      };
}
