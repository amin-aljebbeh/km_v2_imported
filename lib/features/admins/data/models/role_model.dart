import 'package:kammun_app/features/admins/data/models/role_pivot_model.dart';
import 'package:kammun_app/features/admins/domain/entities/role_entity.dart';

class RoleModel extends RoleEntity {
  RoleModel({id, name, slug, description, rolePivot})
      : super(slug: slug, description: description, id: id, name: name, rolePivot: rolePivot);

  factory RoleModel.fromJson(Map<String, dynamic> json) => RoleModel(
        id: json['id'],
        name: json['name'],
        slug: json['slug'],
        description: json['description'],
        rolePivot: json["pivot"] == null ? null : RolePivotModel.fromJson(json["pivot"]),
      );

  Map<String, dynamic> toJson() => {'id': id, 'name': name, 'slug': slug, 'description': description};
}
