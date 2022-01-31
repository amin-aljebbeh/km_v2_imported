import 'package:flutter/material.dart';
import 'package:kammun_app/views/products_view/services/products_services.dart';
import 'package:kammun_app/utils/utils_importer.dart';

import '../../Services.dart';

class SwitchProductStatusWidget extends StatefulWidget {
  final double height;
  final double width;
  final int preState;
  final int subWarehouseId;
  final String productId;
  final Function(int newStat, bool result) onChange;
  final bool isForSubWarehouse;

  const SwitchProductStatusWidget({
    Key key,
    @required this.preState,
    @required this.subWarehouseId,
    @required this.productId,
    @required this.onChange,
    @required this.height,
    @required this.width,
    this.isForSubWarehouse,
  }) : super(key: key);

  @override
  _SwitchProductStatusWidgetState createState() => _SwitchProductStatusWidgetState();
}

class _SwitchProductStatusWidgetState extends State<SwitchProductStatusWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      width: widget.width,
      margin: const EdgeInsets.all(15.0),
      padding: const EdgeInsets.all(3.0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10.0) //                 <--- border radius here
              ),
          border: Border.all(
              color: widget.preState == 1 ? ColorUtils.kmColors : ColorUtils.searchGreyColor, width: 2)),
      child: Center(
        child: Switch(
          value: widget.preState == 1 ? true : false,
          onChanged: (value) async {
            var result;
            result = await ProductsServices.updateProductsDetails(
              bodyKey: "is_active",
              value: value ? "1" : "0",
              subWarehouseId: widget.subWarehouseId.toString(),
              isForSubWarehouse: widget.isForSubWarehouse,
              productId: widget.productId,
            );

            Services.resultFlushBar(context: context, result: result);
            if (result) {
              setState(() {
                int newStat;
                if (widget.preState == 1) {
                  newStat = 0;
                } else {
                  newStat = 1;
                }
                widget.onChange(newStat, result);
              });
            }
          },
          activeTrackColor: ColorUtils.kmColors2,
          activeColor: ColorUtils.kmColors,
        ),
      ),
    );
  }
}
