import 'package:kammun_app/core/models/shopper_level_model.dart';

class ShopperModel {
  ShopperModel({
    this.id,
    this.adminId,
    this.name,
    this.points,
    this.status,
    this.levelId,
    this.createdAt,
    this.updatedAt,
    this.level,
  });

  ShopperModel.copy(ShopperModel shopperModel) {
    status = shopperModel.status;
    name = shopperModel.name;
    id = shopperModel.id;
    updatedAt = shopperModel.updatedAt;
    points = shopperModel.points;
    levelId = shopperModel.levelId;
    level = shopperModel.level;
    createdAt = shopperModel.createdAt;
    adminId = shopperModel.adminId;
  }

  int id;
  int adminId;
  String name;
  int points;
  int status;
  int levelId;
  DateTime createdAt;
  DateTime updatedAt;
  Level level;

  factory ShopperModel.fromJson(Map<String, dynamic> json) => ShopperModel(
        id: json["id"],
        adminId: json["admin_id"],
        name: json["name"],
        points: json["points"],
        status: json["status"],
        levelId: json["level_id"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        level: json["level"] == null ? null : Level.fromJson(json["level"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "admin_id": adminId,
        "name": name,
        "points": points,
        "status": status,
        "level_id": levelId,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "level": level.toJson(),
      };
}
