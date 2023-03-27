import 'package:kammun_app/features/admins/domain/entities/shopper_level_entity.dart';

class ShopperEntity {
  final int id;
  final int adminId;
  final String name;
  final int points;
  final int status;
  final int levelId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final ShopperLevelEntity level;

  ShopperEntity({
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
}
