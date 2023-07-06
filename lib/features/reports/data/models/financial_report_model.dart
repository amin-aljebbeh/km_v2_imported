// To parse this JSON data, do
//
//     final financialReport = financialReportFromJson(jsonString);الأرباح والمستحقات المالية

import 'dart:convert';

import '../../domain/entities/financial_report_entity.dart';
import 'report_data_model.dart';

FinancialReportModel financialReportFromJson(String str) => FinancialReportModel.fromJson(json.decode(str));

class FinancialReportModel extends FinancialReportEntity {
  FinancialReportModel({success, data}) : super(success: success, data: data);

  factory FinancialReportModel.fromJson(Map<String, dynamic> json) =>
      FinancialReportModel(success: json['success'], data: ReportDataModel.fromJson(json['data']));
}
