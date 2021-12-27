import 'package:kammun_app/Services.dart';
import 'package:kammun_app/views/loading/LoadingServices.dart';

import 'start_model.dart';

class OrderAccountingRow {
  int subWarehouseId;
  String subWarehouseName;
  double customerPay;
  double payToSubWarehouse;

  OrderAccountingRow(
    this.subWarehouseId,
    this.subWarehouseName,
    this.customerPay,
    this.payToSubWarehouse,
  );
}
