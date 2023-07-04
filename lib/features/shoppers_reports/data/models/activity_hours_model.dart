// To parse this JSON data, do
//
//     final activityHours = activityHoursFromJson(jsonString);

import 'dart:convert';

import '../../domain/entities/activity_hours_entity.dart';

ActivityHours activityHoursFromJson(String str) => ActivityHours.fromJson(json.decode(str));

String activityHoursToJson(ActivityHours data) => json.encode(data.toJson());

class ActivityHours {
  ActivityHours({this.success, this.data});

  bool success;
  List<ActivityHoursModel> data;

  factory ActivityHours.fromJson(Map<String, dynamic> json) => ActivityHours(
        success: json['success'],
        data: List<ActivityHoursModel>.from(json['data'].map((x) => ActivityHoursModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        'success': success,
        'data': List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class ActivityHoursModel extends ActivityHoursEntity {
  ActivityHoursModel({id, shopperId, numberMinutes, startWorkAt, endAt})
      : super(id: id, shopperId: shopperId, numberMinutes: numberMinutes, startWorkAt: startWorkAt, endAt: endAt);

  factory ActivityHoursModel.fromJson(Map<String, dynamic> json) => ActivityHoursModel(
        id: json['id'],
        shopperId: json['shopper_id'],
        numberMinutes: json['number_minuts'],
        startWorkAt: DateTime.parse(json['start_work_at']),
        endAt: DateTime.parse(json['end_at']),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'shopper_id': shopperId,
        'number_minuts': numberMinutes,
        'start_work_at': startWorkAt.toIso8601String(),
        'end_at': endAt.toIso8601String(),
      };
}
