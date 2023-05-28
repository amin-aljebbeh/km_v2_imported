import 'package:kammun_app/features/orders_feature/domain/entities/show_data_entity.dart';

import 'key_value_info_model.dart';

class ShowDataModel extends ShowDataEntity {
  ShowDataModel({invoiceInfo, paymentInfo}) : super(invoiceInfo: invoiceInfo, paymentInfo: paymentInfo);

  factory ShowDataModel.fromJson(Map<String, dynamic> json) => ShowDataModel(
        invoiceInfo: List<KeyValueInfoModel>.from(json['invoice_info'].map((x) => KeyValueInfoModel.fromJson(x))),
        paymentInfo: List<KeyValueInfoModel>.from(json['payment_info'].map((x) => KeyValueInfoModel.fromJson(x))),
      );
}
