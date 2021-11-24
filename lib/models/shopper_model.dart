import 'package:flutter/material.dart';
import 'package:kammun_app/models/shopper_level_model.dart';

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
    print('copyyyyyyyyy');
    this.status = shopperModel.status;
    this.name = shopperModel.name;
    this.id = shopperModel.id;
    this.updatedAt = shopperModel.updatedAt;
    this.points = shopperModel.points;
    this.levelId = shopperModel.levelId;
    this.level = shopperModel.level;
    this.createdAt = shopperModel.createdAt;
    this.adminId = shopperModel.adminId;
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
        id: json["id"] == null ? null : json["id"],
        adminId: json["admin_id"] == null ? null : json["admin_id"],
        name: json["name"] == null ? null : json["name"],
        points: json["points"] == null ? null : json["points"],
        status: json["status"] == null ? null : json["status"],
        levelId: json["level_id"] == null ? null : json["level_id"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        level: json["level"] == null ? null : Level.fromJson(json["level"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "admin_id": adminId == null ? null : adminId,
        "name": name == null ? null : name,
        "points": points == null ? null : points,
        "status": status == null ? null : status,
        "level_id": levelId == null ? null : levelId,
        "created_at": createdAt == null ? null : createdAt.toIso8601String(),
        "updated_at": updatedAt == null ? null : updatedAt.toIso8601String(),
        "level": level == null ? null : level.toJson(),
      };
}
