import '../../../../core/core_importer.dart';
import '../../domain/entities/change_order_status_response_entity.dart';

ChangeOrderStatusResponseModel changeStatusModelFromJson(String str) =>
    ChangeOrderStatusResponseModel.fromJson(json.decode(str));

class ChangeOrderStatusResponseModel extends ChangeOrderStatusResponseEntity {
  ChangeOrderStatusResponseModel({bool success, String data}) : super(success: success, data: data);

  factory ChangeOrderStatusResponseModel.fromJson(Map<String, dynamic> json) =>
      ChangeOrderStatusResponseModel(success: json['success'], data: json['data']);
}
