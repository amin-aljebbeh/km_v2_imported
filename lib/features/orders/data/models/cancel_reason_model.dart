import 'dart:convert';

import '../../domain/entities/cancel_reason_entity.dart';

CancelReasonResponseModel cancelReasonResponseFromJson(String str) =>
    CancelReasonResponseModel.fromJson(json.decode(str));

class CancelReasonResponseModel extends CancelReasonResponseEntity {
  const CancelReasonResponseModel({bool status, List<CancelReasonModel> reasons, String message, bool success})
      : super(status: status, reasons: reasons, message: message, success: success);

  factory CancelReasonResponseModel.fromJson(Map<String, dynamic> json) => CancelReasonResponseModel(
        status: json["status"],
        reasons: List<CancelReasonModel>.from(json["data"].map((x) => CancelReasonModel.fromJson(x))),
        message: json["message"],
        success: json["success"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": List<dynamic>.from(reasons.map((x) => (x as CancelReasonModel).toJson())),
        "message": message,
        "success": success,
      };
}

class CancelReasonModel extends CancelReasonEntity {
  const CancelReasonModel({int id, String name}) : super(id: id, name: name);

  factory CancelReasonModel.fromJson(Map<String, dynamic> json) =>
      CancelReasonModel(id: json["id"], name: json["name"]);

  Map<String, dynamic> toJson() => {"id": id, "name": name};
}
