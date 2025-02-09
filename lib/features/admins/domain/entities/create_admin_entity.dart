import 'package:kammun_app/core/core_importer.dart';

class CreateAdminEntity extends Equatable {
  final String name;
  final String userName;
  final String password;
  final int warehouseId;
  final bool isSuperUser;

  const CreateAdminEntity({this.name, this.userName, this.password, this.warehouseId, this.isSuperUser});

  @override
  List<Object> get props => [name, userName, password, warehouseId, isSuperUser];
}
