import 'dart:convert';

import 'package:kammun_app/features/home/domain/entities/banner_entity.dart';

BannerResponse bannerResponseFromJson(String str) => BannerResponse.fromJson(json.decode(str));

String bannerResponseToJson(BannerResponse data) => json.encode(data.toJson());

class BannerResponse {
  bool success;
  List<BannerModel> banners;

  BannerResponse({this.success, this.banners});

  factory BannerResponse.fromJson(Map<String, dynamic> json) => BannerResponse(
        success: json["success"],
        banners: List<BannerModel>.from(json["data"].map((x) => BannerModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {"success": success, "data": List<dynamic>.from(banners.map((x) => x.toJson()))};
}

class BannerModel extends BannerEntity {
  const BannerModel({id, title, description, imageFileName, expirationDate, warehouseId, bannerLink})
      : super(
            bannerLink: bannerLink,
            description: description,
            expirationDate: expirationDate,
            id: id,
            imageFileName: imageFileName,
            title: title,
            warehouseId: warehouseId);

  factory BannerModel.fromJson(Map<String, dynamic> json) => BannerModel(
        id: json['id'],
        title: json['title'],
        description: json['description'],
        imageFileName: json['image_file_name'],
        expirationDate: DateTime.parse(json['expiration_date']),
        warehouseId: json['warehouse_id'],
        bannerLink: json['banner_link'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'image_file_name': imageFileName,
        'expiration_date': expirationDate.toIso8601String(),
        'warehouse_id': warehouseId,
      };
}
