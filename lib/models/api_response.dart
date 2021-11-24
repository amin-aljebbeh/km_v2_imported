import 'dart:convert';

import 'package:kammun_app/models/shopper_model.dart';

GetShopperResponse getShopperResponseFromJson(String str) =>
    GetShopperResponse.fromJson(json.decode(str));

String getShopperResponseToJson(GetShopperResponse data) =>
    json.encode(data.toJson());

class GetShopperResponse {
  GetShopperResponse({
    this.success,
    this.shopper,
  });

  bool success;
  ShopperModel shopper;

  factory GetShopperResponse.fromJson(Map<String, dynamic> json) =>
      GetShopperResponse(
        success: json["success"] == null ? null : json["success"],
        shopper:
            json["data"] == null ? null : ShopperModel.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success == null ? null : success,
        "data": shopper == null ? null : shopper.toJson(),
      };
}
