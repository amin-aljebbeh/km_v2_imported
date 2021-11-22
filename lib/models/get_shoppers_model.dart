import 'dart:convert';

import 'shopper_model.dart';

GetShoppersResponseModel shoppersFromJson(String str) =>
    GetShoppersResponseModel.fromJson(json.decode(str));

String shoppersToJson(GetShoppersResponseModel data) =>
    json.encode(data.toJson());

class GetShoppersResponseModel {
  GetShoppersResponseModel({
    this.success,
    this.data,
  });

  bool success;
  List<ShopperModel> data;

  factory GetShoppersResponseModel.fromJson(Map<String, dynamic> json) =>
      GetShoppersResponseModel(
        success: json["success"] == null ? null : json["success"],
        data: json["data"] == null
            ? null
            : List<ShopperModel>.from(
                json["data"].map((x) => ShopperModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success == null ? null : success,
        "data": data == null
            ? null
            : List<dynamic>.from(data.map((x) => x.toJson())),
      };
}
