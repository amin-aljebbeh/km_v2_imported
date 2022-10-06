import '../../../core/core_importer.dart';

ChangeOrderStatusModel changeOrderStatusModelFromJson(String str) => ChangeOrderStatusModel.fromJson(json.decode(str));

String changeOrderStatusModelToJson(ChangeOrderStatusModel data) => json.encode(data.toJson());

class ChangeOrderStatusModel {
  ChangeOrderStatusModel({this.success, this.data, this.order});

  bool success;
  String data;
  OrdersOriginalData order;

  factory ChangeOrderStatusModel.fromJson(Map<String, dynamic> json) => ChangeOrderStatusModel(
      success: json['success'], data: json['data'], order: OrdersOriginalData.fromJson(json['order']));

  Map<String, dynamic> toJson() => {'success': success, 'data': data, 'order': order.toJson()};
}
