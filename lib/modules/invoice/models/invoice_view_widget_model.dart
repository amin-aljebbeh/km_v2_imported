import '../../../core/common_models/key_value_info_model.dart';

class InvoiceViewWidgetModel {
  final List<KeyValueModel> invoiceInfo;
  final List<KeyValueModel> paymentInfo;

  InvoiceViewWidgetModel({this.invoiceInfo, this.paymentInfo});
}
