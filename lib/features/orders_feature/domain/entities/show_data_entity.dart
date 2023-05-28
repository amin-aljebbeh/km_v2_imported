import 'package:kammun_app/features/orders_feature/domain/entities/key_value_info_entity.dart';

class ShowDataEntity {
  final List<KeyValueInfoEntity> invoiceInfo;
  final List<KeyValueInfoEntity> paymentInfo;

  ShowDataEntity({this.invoiceInfo, this.paymentInfo});
}
