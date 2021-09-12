import 'package:flutter/material.dart';
import 'package:kammun_app/models/start_model.dart';
import 'package:kammun_app/utils/utils_importer.dart';
import 'package:kammun_app/views/loading/LoadingServices.dart';
import 'package:kammun_app/views/login/models/login_admin_model.dart';

class OrderAccounting extends StatefulWidget {
  final List<OrderProducts> ordersAry;
  const OrderAccounting({Key key, @required this.ordersAry}) : super(key: key);

  @override
  _OrderAccountingState createState() => _OrderAccountingState();
}

class _OrderAccountingState extends State<OrderAccounting> {
  List<SubWarehouse> _ls = LoadingScreenServices.swbWarehouses;
  List<Widget> subWarehouseTotal = [];

  _sumSubWarehouse(int subwarehouseId) {
    int sum = 0;

    for (int i = 0; i < widget.ordersAry.length; i++) {
      if (widget.ordersAry[i].subWarehouseId == subwarehouseId) {
        sum = sum +
            (int.parse(widget.ordersAry[i].pivot.purchasePrice) *
                int.parse(widget.ordersAry[i].pivot.quantity));
      }
    }
    return UtilsImporter().stringUtils.oCcy.format(sum);
  }

  _calculate() {
    setState(() {
      subWarehouseTotal.clear();
      for (int i = 0; i < _ls.length; i++) {
        subWarehouseTotal.add(
          Table(
            border: TableBorder.all(
                color: Theme.of(context).primaryColor,
                style: BorderStyle.solid,
                width: 1),
            children: [
              TableRow(children: [
                Container(
                  margin: EdgeInsets.all(10),
                  child: Text(
                    _ls[i].name,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: UtilsImporter().stringUtils.HKGrotesk,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(10),
                  child: Text(
                    _sumSubWarehouse(_ls[i].id).toString(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: UtilsImporter().stringUtils.HKGrotesk,
                    ),
                  ),
                )
              ]),
            ],
          ),
        );
      }
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _calculate();

    return Scaffold(
        body: SafeArea(
      child: ListView(
        shrinkWrap: true,
        children: subWarehouseTotal,
      ),
    ));
  }
}
