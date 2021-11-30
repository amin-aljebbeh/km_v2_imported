import 'dart:convert';

import 'package:kammun_app/models/order_model.dart';

GetWarehousesModel getWarehousesFromJson(String str) =>
    GetWarehousesModel.fromJson(json.decode(str));

String getWarehousesToJson(GetWarehousesModel data) =>
    json.encode(data.toJson());

class GetWarehousesModel {
  GetWarehousesModel({
    this.success,
    this.data,
  });

  bool success;
  List<Warehouse> data;

  factory GetWarehousesModel.fromJson(Map<String, dynamic> json) =>
      GetWarehousesModel(
        success: json["success"] == null ? null : json["success"],
        data: json["data"] == null
            ? null
            : List<Warehouse>.from(
                json["data"].map((x) => Warehouse.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success == null ? null : success,
        "data": data == null
            ? null
            : List<dynamic>.from(data.map((x) => x.toJson())),
      };
}
