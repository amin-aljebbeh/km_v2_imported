import 'package:kammun_app/features/shoppers/domain/entities/shopper_entity.dart';

import '../../../admins/data/models/admin_model.dart';
import 'shopper_level_model.dart';

class ShopperModel extends ShopperEntity {
  ShopperModel({id, adminId, name, status, levelId, level, admin})
      : super(id: id, adminId: adminId, name: name, status: status, levelId: levelId, level: level, admin: admin);

  factory ShopperModel.fromJson(Map<String, dynamic> json) => ShopperModel(
        id: json['id'],
        adminId: json['admin_id'],
        name: json['name'],
        admin: json['admin'] == null ? null : AdminModel.fromJson(json['admin']),
        status: json['status'],
        levelId: json['level_id'],
        level: json['level'] == null ? null : ShopperLevelModel.fromJson(json['level']),
      );

  Map<String, dynamic> toJson() => {'id': id, 'admin_id': adminId, 'name': name, 'status': status, 'level_id': levelId};
}
