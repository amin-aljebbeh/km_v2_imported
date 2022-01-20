import 'package:flutter/material.dart';
import 'package:kammun_app/utils/utils_importer.dart';

import 'widgets_importer.dart';

class ProductCheckWidget extends StatefulWidget {
  final bool preferLeftSide;
  final String productCount;
  final String productName;
  final int index;
  final Function(int) onCheckbox;

  const ProductCheckWidget({
    Key key,
    @required this.preferLeftSide,
    @required this.productCount,
    @required this.productName,
    @required this.index,
    @required this.onCheckbox,
  }) : super(key: key);

  @override
  _ProductCheckWidgetState createState() => _ProductCheckWidgetState();
}

class _ProductCheckWidgetState extends State<ProductCheckWidget> {
  @override
  Widget build(BuildContext context) {
    return widget.preferLeftSide
        ? Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(3.0),
                  decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.all(Radius.circular(10.0) //                 <--- border radius here
                              ),
                      border: Border.all(color: ColorUtils.primaryColor, width: 2)),
                  child: Center(
                    child: Text(
                      widget.productCount,
                      style: mainStyle.copyWith(fontSize: 30),
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                IconButton(
                    icon: Icon(
                      Icons.library_add_check_outlined,
                      color: Colors.green,
                    ),
                    onPressed: () {
                      if (widget.productCount != "1") {
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
                            title: "تحقق من الكمية",
                            text: "هل أنت متأكد انك وجدت ${widget.productCount} قطعة من ${widget.productName}",
                            dialogButtons: decisionButtons,
                            context: context);
                        // _showDialog();
                      } else {
                        widget.onCheckbox(widget.index);
                      }
                    }),
              ],
            ),
          )
        : Container();
  }
}
