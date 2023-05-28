import '../../../../core/core_importer.dart';

class LockOrderResponseEntity {
  bool success;
  String data;
  List<OrderProduct> products;

  LockOrderResponseEntity({this.success, this.data, this.products});
}
