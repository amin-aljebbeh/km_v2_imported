import 'dart:convert';

import 'shopper_model.dart';

GetShoppersResponseModel shoppersFromJson(String str) => GetShoppersResponseModel.fromJson(json.decode(str));

class GetShoppersResponseModel {
  GetShoppersResponseModel({
    this.success,
    this.data,
  });

  bool success;
  List<ShopperModel> data;

  factory GetShoppersResponseModel.fromJson(Map<String, dynamic> json) => GetShoppersResponseModel(
        success: json["success"],
        data: json["data"] == null ? null : List<ShopperModel>.from(json["data"].map((x) => ShopperModel.fromJson(x))),
      );
}
