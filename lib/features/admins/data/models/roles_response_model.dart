import 'package:kammun_app/features/admins/data/models/role_model.dart';

import '../../../../core/core_importer.dart';

RolesResponseModel rolesResponseModelFromJson(String str) => RolesResponseModel.fromJson(json.decode(str));

String rolesResponseModelToJson(RolesResponseModel data) => json.encode(data.toJson());

class RolesResponseModel {
  RolesResponseModel({this.success, this.roles});

  bool success;
  List<RoleModel> roles;

  factory RolesResponseModel.fromJson(Map<String, dynamic> json) => RolesResponseModel(
      success: json['success'], roles: List<RoleModel>.from(json['data'].map((x) => RoleModel.fromJson(x))));

  Map<String, dynamic> toJson() => {'success': success, 'data': List<dynamic>.from(roles.map((x) => x.toJson()))};
}
