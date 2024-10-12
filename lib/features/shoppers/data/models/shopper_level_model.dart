import 'package:kammun_app/features/general_information/data/models/sub_warehouse_model.dart';
import 'package:kammun_app/features/general_information/data/models/supported_city_model.dart';

import '../../../../core/core_importer.dart';
import '../../domain/entities/shopper_level_entity.dart';

class LevelModelResponse {
  LevelModelResponse({
    this.success,
    this.data,
  });

  bool success;
  ShopperLevelModel data;

  factory LevelModelResponse.fromJson(Map<String, dynamic> json) => LevelModelResponse(
        success: json["success"],
        data: json["data"] == null ? null : ShopperLevelModel.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": data.toJson(),
      };
}

LevelsResponse levelsFromJson(String str) => LevelsResponse.fromJson(json.decode(str));

class LevelsResponse {
  LevelsResponse({this.success, this.levels});

  bool success;
  List<ShopperLevelModel> levels;

  factory LevelsResponse.fromJson(Map<String, dynamic> json) => LevelsResponse(
        success: json['success'],
        levels: json['data'] == null
            ? null
            : List<ShopperLevelModel>.from(json['data'].map((x) => ShopperLevelModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        'success': success,
        'data': levels == null ? null : List<dynamic>.from(levels.map((x) => x.toJson())),
      };
}

class ShopperLevelModel extends ShopperLevelEntity {
  ShopperLevelModel({id, subWarehouses, supportedCities, pricePerKilo})
      : super(id: id, subWarehouses: subWarehouses, supportedCities: supportedCities, pricePerKilo: pricePerKilo);

  factory ShopperLevelModel.fromJson(Map<String, dynamic> json) => ShopperLevelModel(
        id: json['id'],
        pricePerKilo: json['price_per_kilo'],
        subWarehouses: json['sub_warehouses'] == null
            ? []
            : List<SubWarehouseModel>.from(json['sub_warehouses'].map((x) => SubWarehouseModel.fromJson(x))),
        supportedCities: json['supported_cities'] == null
            ? null
            : List<SupportedCityModel>.from(json['supported_cities'].map((x) => SupportedCityModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {'id': id};
}
