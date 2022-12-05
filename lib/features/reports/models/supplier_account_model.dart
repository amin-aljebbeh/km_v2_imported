// To parse this JSON data, do
//
//     final empty = emptyFromJson(jsonString);

import 'dart:convert';

SupplierAccountModelResponse supplierAccountModelResponseFromJson(String str) =>
    SupplierAccountModelResponse.fromJson(json.decode(str));

String supplierAccountModelResponseToJson(SupplierAccountModelResponse data) => json.encode(data.toJson());

class SupplierAccountModelResponse {
  SupplierAccountModelResponse({
    this.success,
    this.data,
    this.date,
  });

  bool success;
  List<SupplierAccountModel> data;
  TransactionDate date;

  factory SupplierAccountModelResponse.fromJson(Map<String, dynamic> json) => SupplierAccountModelResponse(
        success: json["success"],
        data: json["data"] == null
            ? null
            : List<SupplierAccountModel>.from(json["data"].map((x) => SupplierAccountModel.fromJson(x))),
        date: json["date"] == null ? null : TransactionDate.fromJson(json["date"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "date": date.toJson(),
      };
}

class SupplierAccountModel {
  SupplierAccountModel({
    this.subWarehouseId,
    this.name,
    this.remainingMonyForSupplier,
  });

  int subWarehouseId;
  String name;
  String remainingMonyForSupplier;

  factory SupplierAccountModel.fromJson(Map<String, dynamic> json) => SupplierAccountModel(
        subWarehouseId: json["sub_warehouse_id"],
        name: json["name"],
        remainingMonyForSupplier: json["remaining_mony_for_supplier"],
      );

  Map<String, dynamic> toJson() => {
        "sub_warehouse_id": subWarehouseId,
        "name": name,
        "remaining_mony_for_supplier": remainingMonyForSupplier,
      };
}

class TransactionDate {
  TransactionDate({
    this.fromDate,
    this.toDate,
  });

  DateTime fromDate;
  DateTime toDate;

  factory TransactionDate.fromJson(Map<String, dynamic> json) => TransactionDate(
        fromDate: json["from_date"] == null ? null : DateTime.parse(json["from_date"]),
        toDate: json["to_date"] == null ? null : DateTime.parse(json["to_date"]),
      );

  Map<String, dynamic> toJson() => {
        "from_date": fromDate.toIso8601String(),
        "to_date": toDate.toIso8601String(),
      };
}
