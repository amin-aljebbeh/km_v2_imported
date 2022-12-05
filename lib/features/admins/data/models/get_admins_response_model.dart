import 'package:kammun_app/features/admins/data/models/admin_model.dart';

import '../../../../core/core_importer.dart';

GetAdminsResponseModel getAdminsResponseModelFromJson(String str) => GetAdminsResponseModel.fromJson(json.decode(str));

String getAdminsResponseModelToJson(GetAdminsResponseModel data) => json.encode(data.toJson());

class GetAdminsResponseModel {
  GetAdminsResponseModel({this.success, this.admins});

  bool success;
  List<AdminModel> admins;

  factory GetAdminsResponseModel.fromJson(Map<String, dynamic> json) => GetAdminsResponseModel(
      success: json['success'], admins: List<AdminModel>.from(json['data'].map((x) => AdminModel.fromJson(x))));

  Map<String, dynamic> toJson() => {'success': success, 'data': List<dynamic>.from(admins.map((x) => x.toJson()))};
}
