// To parse this JSON data, do
//
//     final adminBalanceResponseModel = adminBalanceResponseModelFromJson(jsonString);

import 'dart:convert';

import 'package:kammun_app/features/transactions/domain/entities/admin_balance_entity.dart';

AdminBalanceResponseModel adminBalanceResponseModelFromJson(String str) =>
    AdminBalanceResponseModel.fromJson(json.decode(str));

String adminBalanceResponseModelToJson(AdminBalanceResponseModel data) => json.encode(data.toJson());

class AdminBalanceResponseModel {
  AdminBalanceResponseModel({
    this.success,
    this.adminBalance,
  });

  bool success;
  AdminBalanceModel adminBalance;

  factory AdminBalanceResponseModel.fromJson(Map<String, dynamic> json) =>
      AdminBalanceResponseModel(success: json['success'], adminBalance: AdminBalanceModel.fromJson(json['data']));

  Map<String, dynamic> toJson() => {'success': success, 'data': adminBalance.toJson()};
}

class AdminBalanceModel extends AdminBalanceEntity {
  AdminBalanceModel({companyDues, totalShopperProfits})
      : super(companyDues: companyDues, totalShopperProfits: totalShopperProfits);

  factory AdminBalanceModel.fromJson(Map<String, dynamic> json) =>
      AdminBalanceModel(companyDues: json['company_dues'], totalShopperProfits: json['total_shopper_profits']);

  Map<String, dynamic> toJson() => {'company_dues': companyDues, 'total_shopper_profits': totalShopperProfits};
}
