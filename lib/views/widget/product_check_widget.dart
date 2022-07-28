import 'package:flutter/material.dart';
import 'package:kammun_app/models/start_models/order_product_model.dart';
import 'package:kammun_app/utils/utils_importer.dart';

import '../../service.dart';
import 'widgets_importer.dart';

class ProductCheckWidget extends StatefulWidget {
  final bool preferLeftSide;
  final String productCount;
  final String productName;
  final int index;
  final Function(int) onCheckbox;

  final OrderProducts productData;

  const ProductCheckWidget({
    Key key,
    @required this.preferLeftSide,
    @required this.productCount,
    @required this.productName,
    @required this.index,
    @required this.onCheckbox,
    @required this.productData,
  }) : super(key: key);

  @override
  _ProductCheckWidgetState createState() => _ProductCheckWidgetState();
}

class _ProductCheckWidgetState extends State<ProductCheckWidget> {
  @override
  Widget build(BuildContext context) {
    return widget.preferLeftSide
        ? Row(
            children: [
              if (Services.isOperationManager() || widget.productData.pivot.deletedAt != 'null')
                RotatedBox(
                  quarterTurns: 1,
                  child: SwitchProductStatusWidget(
                    isForSubWarehouse: true,
                    height: 20,
                    width: 65,
                    preState: widget.productData.isActive,
                    subWarehouseId: widget.productData.subWarehouseId,
                    productId: widget.productData.pivot.productId,
                    onChange: (int active, bool result) {
                      setState(() {
                        if (result) widget.productData.isActive = active;
                      });
                    },
                  ),
                ),
              Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(3.0),
                    decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10.0) //                 <--- border radius here
                                ),
                        border: Border.all(color: ColorUtils.primaryColor, width: 2)),
                    child: Center(
                      child: Text(
                        widget.productCount,
                        style: mainStyle.copyWith(fontSize: 30),
                      ),
                    ),
                  ),
                  IconButton(
                      icon: const Icon(
                        Icons.library_add_check_outlined,
                        color: Colors.green,
                      ),
                      onPressed: () {
                        if (widget.productCount != '1') {
                          List<DialogButton> decisionButtons = [
                            DialogButton(
                              text: 'نعم',
                              onTap: () {
                                Navigator.of(context).pop();

                                widget.onCheckbox(widget.index);
                              },
                            ),
                            DialogButton(
                              text: 'لا',
                              onTap: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ];
                          showMyDialog(
                              title: 'تحقق من الكمية',
                              text: 'هل أنت متأكد انك وجدت ${widget.productCount} قطعة من ${widget.productName}',
                              dialogButtons: decisionButtons);
                        } else {
                          widget.onCheckbox(widget.index);
                        }
                      }),
                ],
              ),
            ],
          )
        : Container();
  }
}
