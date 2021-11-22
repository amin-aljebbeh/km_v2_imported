// To parse this JSON data, do
//
//     final adminLoginResponse = adminLoginResponseFromJson(jsonString);

import 'dart:convert';
import 'admin_model.dart';

AdminLoginResponse adminLoginResponseFromJson(String str) =>
    AdminLoginResponse.fromJson(json.decode(str));

String adminLoginResponseToJson(AdminLoginResponse data) =>
    json.encode(data.toJson());

class AdminLoginResponse {
  AdminLoginResponse({
    this.success,
    this.data,
  });

  bool success;
  AdminModel data;

  factory AdminLoginResponse.fromJson(Map<String, dynamic> json) =>
      AdminLoginResponse(
        success: json["success"] == null ? null : json["success"],
        data: json["data"] == null ? null : AdminModel.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success == null ? null : success,
        "data": data == null ? null : data.toJson(),
      };
}
