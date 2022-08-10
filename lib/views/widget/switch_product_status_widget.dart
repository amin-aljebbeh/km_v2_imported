import 'package:kammun_app/views/products_view/services/products_services.dart';

import '../../core/core_importer.dart';

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
  bool loading;

  @override
  void initState() {
    loading = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? const Loader()
        : Container(
            height: widget.height,
            width: widget.width,
            padding: const EdgeInsets.all(3.0),
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                border: Border.all(
                    color: widget.preState == 1 ? ColorUtils.kmColors : ColorUtils.searchGreyColor, width: 2)),
            child: Center(
              child: Switch(
                value: widget.preState == 1 ? true : false,
                onChanged: (value) async {
                  if (widget.isForSubWarehouse && widget.subWarehouseId != -1 && widget.productId != 'null') {
                    setState(() => loading = true);
                    bool result;
                    result = await ProductsServices.updateProductsDetails(
                      bodyKey: "is_active",
                      value: value ? "1" : "0",
                      subWarehouseId: widget.subWarehouseId.toString(),
                      isForSubWarehouse: widget.isForSubWarehouse,
                      productId: widget.productId,
                    );
                    setState(() => loading = false);
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
                  } else {
                    int newStat;
                    if (widget.preState == 1) {
                      newStat = 0;
                    } else {
                      newStat = 1;
                    }
                    widget.onChange(newStat, true);
                  }
                },
                activeTrackColor: ColorUtils.kmColors2,
                activeColor: ColorUtils.kmColors,
              ),
            ),
          );
  }
}
