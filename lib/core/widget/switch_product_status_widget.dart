import 'package:kammun_app/features/products/domain/entities/product_entity.dart';
import 'package:kammun_app/features/products_view/services/products_services.dart';

import '../../core/core_importer.dart';

class SwitchProductStatusWidget extends StatefulWidget {
  final double height;
  final double width;
  int preState;
  final int subWarehouseId;
  final String productId;
  final Function(int newStat, bool result) onChange;
  final bool isForSubWarehouse;

  final ProductEntity product;

  SwitchProductStatusWidget({
    Key key,
    @required this.preState,
    @required this.subWarehouseId,
    @required this.productId,
    @required this.onChange,
    @required this.height,
    @required this.width,
    this.isForSubWarehouse,
    this.product,
  }) : super(key: key);

  @override
  _SwitchProductStatusWidgetState createState() =>
      _SwitchProductStatusWidgetState();
}

class _SwitchProductStatusWidgetState extends State<SwitchProductStatusWidget> {
  bool loading;
  bool isActive;

  @override
  void initState() {
    loading = false;
    isActive = widget.preState == 1 ? true : false;
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
                    color: widget.preState == 1 ? kmColors : searchGreyColor,
                    width: 2)),
            child: Center(
              child: Switch(
                value: widget.preState == 1,
                onChanged: (value) async {
                  setState(() => loading = true);

                  try {
                    bool result = await ProductsServices.updateProductsDetails(
                      bodyKey: 'is_active',
                      value: value ? '1' : '0',
                      subWarehouseId: widget.isForSubWarehouse &&
                              widget.subWarehouseId != -1
                          ? widget.subWarehouseId.toString()
                          : null,
                      isForSubWarehouse: widget.isForSubWarehouse,
                      productId: widget.productId,
                    );

                    setState(() {
                      loading = false;
                      widget.preState = value ? 1 : 0; // تحديث قيمة preState
                    });

                    widget.onChange(
                        widget.preState, result); // إبلاغ الوالد دائماً

                    snackBar(
                        success: result,
                        message: result
                            ? 'تم تحديث المنتج بنجاح'
                            : 'فشلت عملية تحديث المنتج يرجى المحاولة مجدداً',
                        context: context);
                  } catch (error) {
                    setState(() => loading = false);
                    snackBar(
                        success: false,
                        message: 'حدث خطأ أثناء تحديث المنتج',
                        context: context);
                  }
                },
                activeTrackColor: kmColors2,
                activeColor: kmColors,
              ),
            ),
          );
  }
}
