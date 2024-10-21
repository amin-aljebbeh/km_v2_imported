import 'package:kammun_app/core/core_importer.dart';
import 'package:kammun_app/features/admins/domain/entities/role_entity.dart';
import 'package:kammun_app/features/shoppers/domain/entities/shopper_entity.dart';

import '../../../general_information/domain/entities/sub_warehouse_entity.dart';

class AdminEntity extends Equatable {
  final int id;
  final String username;
  final String name;
  final String phone;
  final String apiToken;
  final List<SubWarehouseEntity> subWarehouses;
  final List<RoleEntity> roles;
  final ShopperEntity shopper;
  final List<String> permissions;
  final int balance;
  final int warehouseId;
  final String firebaseToken;

  const AdminEntity({
    this.firebaseToken,
    this.id,
    this.username,
    this.name,
    this.phone,
    this.apiToken,
    this.subWarehouses,
    this.roles,
    this.shopper,
    this.permissions,
    this.balance,
    this.warehouseId,
  });

  @override
  List<Object> get props =>
      [id, username, name, firebaseToken, phone, apiToken, subWarehouses, roles, shopper, permissions, balance];
}
