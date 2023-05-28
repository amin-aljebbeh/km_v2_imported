import 'package:kammun_app/features/admins/domain/entities/admins_entity.dart';
import 'package:kammun_app/features/shoppers/domain/entities/shopper_level_entity.dart';

class ShopperEntity {
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
    this.admin,
  });

  int id;
  int adminId;
  String name;
  int points;
  int status;
  int levelId;
  DateTime createdAt;
  DateTime updatedAt;
  ShopperLevelEntity level;
  AdminEntity admin;
}
