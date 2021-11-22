import 'package:kammun_app/models/role_pivot_model.dart';

class Role {
  Role({
    this.id,
    this.name,
    this.slug,
    this.description,
    this.createdAt,
    this.updatedAt,
    this.pivot,
  });

  int id;
  String name;
  String slug;
  dynamic description;
  DateTime createdAt;
  dynamic updatedAt;
  RolePivot pivot;

  factory Role.fromJson(Map<String, dynamic> json) => Role(
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
        slug: json["slug"] == null ? null : json["slug"],
        description: json["description"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"],
        pivot: json["pivot"] == null ? null : RolePivot.fromJson(json["pivot"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "name": name == null ? null : name,
        "slug": slug == null ? null : slug,
        "description": description,
        "created_at": createdAt == null ? null : createdAt.toIso8601String(),
        "updated_at": updatedAt,
        "pivot": pivot == null ? null : pivot.toJson(),
      };
}
