// To parse this JSON data, do
//
//     final activityHours = activityHoursFromJson(jsonString);

import 'dart:convert';

ActivityHours activityHoursFromJson(String str) => ActivityHours.fromJson(json.decode(str));

String activityHoursToJson(ActivityHours data) => json.encode(data.toJson());

class ActivityHours {
  ActivityHours({this.success, this.data, this.date});

  bool success;
  List<ActivityHoursModel> data;
  ActivityDate date;

  factory ActivityHours.fromJson(Map<String, dynamic> json) => ActivityHours(
        success: json['success'],
        data: List<ActivityHoursModel>.from(json['data'].map((x) => ActivityHoursModel.fromJson(x))),
        date: ActivityDate.fromJson(json['date']),
      );

  Map<String, dynamic> toJson() => {
        'success': success,
        'data': List<dynamic>.from(data.map((x) => x.toJson())),
        'date': date.toJson(),
      };
}

class ActivityHoursModel {
  ActivityHoursModel({
    this.id,
    this.shopperId,
    this.numberMinutes,
    this.startWorkAt,
    this.endAt,
  });

  int id;
  int shopperId;
  int numberMinutes;
  DateTime startWorkAt;
  DateTime endAt;

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

class ActivityDate {
  ActivityDate({this.fromDate, this.toDate});

  DateTime fromDate;
  DateTime toDate;

  factory ActivityDate.fromJson(Map<String, dynamic> json) => ActivityDate(
        fromDate: DateTime.parse(json['from_date']),
        toDate: DateTime.parse(json['to_date']),
      );

  Map<String, dynamic> toJson() => {'from_date': fromDate.toIso8601String(), 'to_date': toDate.toIso8601String()};
}
