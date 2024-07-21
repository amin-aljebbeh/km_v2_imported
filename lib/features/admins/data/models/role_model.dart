import 'package:kammun_app/features/admins/domain/entities/role_entity.dart';

class RoleModel extends RoleEntity {
  RoleModel({id, name, slug}) : super(slug: slug, id: id, name: name);

  factory RoleModel.fromJson(Map<String, dynamic> json) =>
      RoleModel(id: json['id'], name: json['name'], slug: json['slug']);

  Map<String, dynamic> toJson() => {'id': id, 'name': name, 'slug': slug};
}
