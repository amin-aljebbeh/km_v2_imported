// To parse this JSON data, do
//
//     final adminLoginResponse = adminLoginResponseFromJson(jsonString);

import 'dart:convert';

import '../../../admins/data/models/admin_model.dart';
import '../../domain/entities/login_admin_entity.dart';

AdminLoginResponseModel adminLoginResponseFromJson(String str) => AdminLoginResponseModel.fromJson(json.decode(str));

class AdminLoginResponseModel extends AdminLoginResponseEntity {
  AdminLoginResponseModel({success, admin}) : super(success: success, admin: admin);

  factory AdminLoginResponseModel.fromJson(Map<String, dynamic> json) =>
      AdminLoginResponseModel(success: json['success'], admin: AdminModel.fromJson(json['data']));
}
