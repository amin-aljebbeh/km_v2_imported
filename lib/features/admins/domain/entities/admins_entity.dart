import 'package:kammun_app/core/core_importer.dart';

class AdminEntity extends Equatable {
  final int id;
  final String username;
  final String name;
  final String phone;
  final String apiToken;
  final List<SubWarehouse> subWarehouses;
  final List<Role> roles;
  final ShopperModel shopper;
  final List<String> permissions;

  const AdminEntity({
    this.id,
    this.username,
    this.name,
    this.phone,
    this.apiToken,
    this.subWarehouses,
    this.roles,
    this.shopper,
    this.permissions,
  });

  @override
  List<Object> get props => [id, username, name, phone, apiToken, subWarehouses, roles, shopper, permissions];
}
