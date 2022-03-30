// ignore_for_file: prefer_null_aware_operators

import 'models_importer.dart';

class Permission {
  Permission({
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
  PermissionPivot pivot;

  factory Permission.fromJson(Map<String, dynamic> json) => Permission(
        id: json["id"],
        name: json["name"],
        slug: json["slug"],
        description: json["description"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"],
        pivot: json["pivot"] == null ? null : PermissionPivot.fromJson(json["pivot"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "slug": slug,
        "description": description,
        "created_at": createdAt == null ? null : createdAt.toIso8601String(),
        "updated_at": updatedAt,
        "pivot": pivot == null ? null : pivot.toJson(),
      };
}
