import 'package:kammun_app/features/shoppers/domain/entities/shopper_entity.dart';

import '../../../admins/data/models/admin_model.dart';
import 'shopper_level_model.dart';

class ShopperModel extends ShopperEntity {
  ShopperModel({
    id,
    adminId,
    name,
    points,
    status,
    levelId,
    createdAt,
    updatedAt,
    level,
    admin,
  }) : super(
          id: id,
          adminId: adminId,
          name: name,
          points: points,
          status: status,
          levelId: levelId,
          createdAt: createdAt,
          updatedAt: updatedAt,
          level: level,
          admin: admin,
        );

  factory ShopperModel.fromJson(Map<String, dynamic> json) => ShopperModel(
        id: json['id'],
        adminId: json['admin_id'],
        name: json['name'],
        admin: json['admin'] == null ? null : AdminModel.fromJson(json['admin']),
        points: json['points'],
        status: json['status'],
        levelId: json['level_id'],
        createdAt: json['created_at'] == null ? null : DateTime.parse(json['created_at']),
        updatedAt: json['updated_at'] == null ? null : DateTime.parse(json['updated_at']),
        level: json['level'] == null ? null : ShopperLevelModel.fromJson(json['level']),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'admin_id': adminId,
        'name': name,
        'points': points,
        'status': status,
        'level_id': levelId,
        'created_at': createdAt.toIso8601String(),
        'updated_at': updatedAt.toIso8601String(),
      };
}
