import 'package:kammun_app/features/admins/domain/entities/admins_entity.dart';
import 'package:kammun_app/features/shoppers/domain/entities/shopper_level_entity.dart';

class ShopperEntity {
  ShopperEntity({
    this.id,
    this.adminId,
    this.name,
    this.status,
    this.levelId,
    this.level,
    this.admin,
  });

  int id;
  int adminId;
  String name;
  int status;
  int levelId;
  ShopperLevelEntity level;
  AdminEntity admin;
}
