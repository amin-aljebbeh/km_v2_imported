import 'dart:convert';

import 'delivery_model.dart';

GetDeliveriesResponse deliveriesFromJson(String str) =>
    GetDeliveriesResponse.fromJson(json.decode(str));

String getDeliveriesResponseToJson(GetDeliveriesResponse data) =>
    json.encode(data.toJson());

class GetDeliveriesResponse {
  GetDeliveriesResponse({
    this.success,
    this.data,
  });

  bool success;
  List<DeliveryModel> data;

  factory GetDeliveriesResponse.fromJson(Map<String, dynamic> json) =>
      GetDeliveriesResponse(
        success: json["success"] == null ? null : json["success"],
        data: json["data"] == null
            ? null
            : List<DeliveryModel>.from(
                json["data"].map((x) => DeliveryModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success == null ? null : success,
        "data": data == null
            ? null
            : List<dynamic>.from(data.map((x) => x.toJson())),
      };
}
