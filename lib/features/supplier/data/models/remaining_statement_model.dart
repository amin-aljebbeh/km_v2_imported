// To parse this JSON data, do
//
//     final empty = emptyFromJson(jsonString);

import 'dart:convert';

import 'package:kammun_app/features/supplier/domain/entities/remaining_statement_entity.dart';

SupplierRemainingModelResponse supplierRemainingModelResponseFromJson(String str) =>
    SupplierRemainingModelResponse.fromJson(json.decode(str));

String supplierAccountModelResponseToJson(SupplierRemainingModelResponse data) => json.encode(data.toJson());

class SupplierRemainingModelResponse {
  SupplierRemainingModelResponse({
    this.success,
    this.data,
    this.date,
  });

  bool success;
  List<SupplierAccountModel> data;
  TransactionDate date;

  factory SupplierRemainingModelResponse.fromJson(Map<String, dynamic> json) => SupplierRemainingModelResponse(
        success: json['success'],
        data: json['data'] == null
            ? null
            : List<SupplierAccountModel>.from(json['data'].map((x) => SupplierAccountModel.fromJson(x))),
        date: json['date'] == null ? null : TransactionDate.fromJson(json['date']),
      );

  Map<String, dynamic> toJson() => {'success': success, 'date': date.toJson()};
}

class SupplierAccountModel extends RemainingStatementEntity {
  const SupplierAccountModel({subWarehouseId, name, remainingMonyForSupplier})
      : super(name: name, subWarehouseId: subWarehouseId, remainingMonyForSupplier: remainingMonyForSupplier);

  factory SupplierAccountModel.fromJson(Map<String, dynamic> json) => SupplierAccountModel(
        subWarehouseId: json['sub_warehouse_id'],
        name: json['name'],
        remainingMonyForSupplier: json['remaining_mony_for_supplier'],
      );

  Map<String, dynamic> toJson() => {
        'sub_warehouse_id': subWarehouseId,
        'name': name,
        'remaining_mony_for_supplier': remainingMonyForSupplier,
      };
}

class TransactionDate {
  TransactionDate({this.fromDate, this.toDate});

  DateTime fromDate;
  DateTime toDate;

  factory TransactionDate.fromJson(Map<String, dynamic> json) => TransactionDate(
        fromDate: json['from_date'] == null ? null : DateTime.parse(json['from_date']),
        toDate: json['to_date'] == null ? null : DateTime.parse(json['to_date']),
      );

  Map<String, dynamic> toJson() => {'from_date': fromDate.toIso8601String(), 'to_date': toDate.toIso8601String()};
}
