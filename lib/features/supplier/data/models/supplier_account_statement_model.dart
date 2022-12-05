// To parse this JSON data, do
//
//     final supplierAccountStatement = supplierAccountStatementFromJson(jsonString);

import 'dart:convert';

import '../../domain/entities/supplier_account_statement_entity.dart';

SupplierAccountStatementModel supplierAccountStatementFromJson(String str) =>
    SupplierAccountStatementModel.fromJson(json.decode(str));

class SupplierAccountStatementModel {
  SupplierAccountStatementModel({this.success, this.data});

  bool success;
  AccountStatementModel data;

  factory SupplierAccountStatementModel.fromJson(Map<String, dynamic> json) =>
      SupplierAccountStatementModel(success: json['success'], data: AccountStatementModel.fromJson(json['data']));
}

class AccountStatementModel extends AccountStatementEntity {
  const AccountStatementModel({accountStatement}) : super(accountStatement: accountStatement);
  factory AccountStatementModel.fromJson(Map<String, dynamic> json) => AccountStatementModel(
      accountStatement:
          List<List<String>>.from(json['account_statment'].map((x) => List<String>.from(x.map((x) => x)))));
}
