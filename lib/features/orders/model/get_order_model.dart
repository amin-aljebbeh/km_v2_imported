import 'package:kammun_app/core/models/models_importer.dart';

GetOrderResponse getOrderResponseFromJson(String str) => GetOrderResponse.fromJson(json.decode(str));

String getOrderResponseToJson(GetOrderResponse data) => json.encode(data.toJson());

class GetOrderResponse {
  GetOrderResponse({this.success, this.order, this.showData});

  bool success;
  OrdersOriginalData order;
  ShowData showData;

  factory GetOrderResponse.fromJson(Map<String, dynamic> json) => GetOrderResponse(
      success: json['success'],
      order: OrdersOriginalData.fromJson(json['order']),
      showData: ShowData.fromJson(json['data']));

  Map<String, dynamic> toJson() => {'success': success, 'order': order.toJson(), 'data': showData.toJson()};
}

class ShowData {
  ShowData({this.invoiceInfo, this.paymentInfo});

  List<KeyValueModel> invoiceInfo;
  List<KeyValueModel> paymentInfo;

  factory ShowData.fromJson(Map<String, dynamic> json) => ShowData(
        invoiceInfo: List<KeyValueModel>.from(json['invoice_info'].map((x) => KeyValueModel.fromJson(x))),
        paymentInfo: List<KeyValueModel>.from(json['payment_info'].map((x) => KeyValueModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        'invoice_info': List<dynamic>.from(invoiceInfo.map((x) => x.toJson())),
        'payment_info': List<dynamic>.from(paymentInfo.map((x) => x.toJson())),
      };
}
