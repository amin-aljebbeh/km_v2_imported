import 'package:kammun_app/features/admins/domain/entities/role_pivot_entity.dart';

class RoleEntity {
  RoleEntity({this.id, this.name, this.slug, this.description, this.rolePivot});

  int id;
  String name;
  String slug;
  String description;
  RolePivotEntity rolePivot;
}
