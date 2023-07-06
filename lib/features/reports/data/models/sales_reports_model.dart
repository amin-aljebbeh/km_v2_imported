// To parse this JSON data, do
//
//     final getDailyStatistics = getDailyStatisticsFromJson(jsonString);   تقرير المبيعات,إحصائيات المبيعات

import 'dart:convert';

import '../../domain/entities/get_daily_statistics_entity.dart';
import 'general_statistics_model.dart';
import 'warehouse_statistics_model.dart';

DailyStatisticsModel getDailyStatisticsFromJson(String str) => DailyStatisticsModel.fromJson(json.decode(str));

String getDailyStatisticsToJson(DailyStatisticsModel data) => json.encode(data.toJson());

class DailyStatisticsModel extends DailyStatisticsEntity {
  DailyStatisticsModel({success, generalStatistics, warehouses})
      : super(success: success, warehouses: warehouses, generalStatistics: generalStatistics);

  factory DailyStatisticsModel.fromJson(Map<String, dynamic> json) => DailyStatisticsModel(
        success: json['success'],
        generalStatistics: GeneralStatisticsModel.fromJson(json['general_statistics']),
        warehouses: json['data'] == null
            ? null
            : List<WarehouseStatisticsModel>.from(json['data'].map((x) => WarehouseStatisticsModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {'success': success};
}
