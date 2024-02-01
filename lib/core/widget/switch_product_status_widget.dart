import 'package:kammun_app/features/products_view/services/products_services.dart';

import '../../core/core_importer.dart';
import '../../features/products/domain/entities/product_entity.dart';

class SwitchProductStatusWidget extends StatefulWidget {
  final double height;
  final double width;
  final int preState;
  final int subWarehouseId;
  final String productId;
  final ProductEntity product;

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
    this.isForSubWarehouse, this.product,
  }) : super(key: key);

  @override
  _SwitchProductStatusWidgetState createState() => _SwitchProductStatusWidgetState();
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
          border: Border.all(color: isActive ? kmColors : searchGreyColor, width: 2)),
      child: Center(
        child: Switch(
          value: isActive,
          onChanged: (value) async {
            setState(() {
              isActive = value;
            });

            if (widget.isForSubWarehouse && widget.subWarehouseId != -1 && widget.productId != 'null') {
              setState(() => loading = true);
              bool result;
              result = await ProductsServices.updateProductsDetails(
                bodyKey: 'is_active',
                value: isActive ? '1' : '0',
                subWarehouseId: widget.product.subWarehouseId.toString(),
                isForSubWarehouse: widget.isForSubWarehouse,
                productId: widget.product.pivot.productId,
              );
              setState(() => loading = false);
              if (result) {
                setState(() {
                  widget.product.isActive = isActive ? '1' : "0";
                });

                snackBar(success: result, message: 'تم تحديث المنتج بنجاح', context: context);
              } else {
                snackBar(
                    success: result, message: 'فشلت عملية تحديث المنتج يرجى المحاولة مجدداً', context: context);
              }
            }
          },
          activeTrackColor: kmColors2,
          activeColor: kmColors,
        ),
      ),
    );
  }
}
