import 'package:kammun_app/features/products/domain/entities/product_entity.dart';
import 'package:kammun_app/features/products_view/services/products_services.dart';

import '../../../../core/core_importer.dart';
import '../../../sub_warehouse_manager/presentation/redux/sub_warehouse_manager_action.dart';

class UpdateProductInfoWidget extends StatefulWidget {
  final Function(String, bool) onSavePressed;
  final String title;
  final TextInputType inputType;
  final String textHint;
  final String bodyKey;
  final int productId;
  final String initialText;
  final ProductEntity productData;
  final bool isForSubWarehouse;
  final bool isForPriceRate;
  final int increasePercentage;
  final double priceFactor;
  final BuildContext ctx;

  const UpdateProductInfoWidget({
    Key key,
    this.onSavePressed,
    this.initialText = '',
    this.title,
    this.inputType = TextInputType.number,
    @required this.bodyKey,
    @required this.productId,
    this.productData,
    this.isForSubWarehouse = true,
    this.textHint = '.',
    this.isForPriceRate = false,
    this.increasePercentage,
    this.priceFactor,
    this.ctx,
  }) : super(key: key);

  @override
  _UpdateProductInfoWidgetState createState() => _UpdateProductInfoWidgetState();
}

class _UpdateProductInfoWidgetState extends State<UpdateProductInfoWidget> {
  final textController = TextEditingController();

  @override
  void initState() {
    textController.text = widget.initialText;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.75,
            child: TextFieldRow(
              hint: widget.textHint,
              onChange: () {},
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              controller: textController,
              text: widget.title,
              inputType: widget.inputType,
              width: 150,
            ),
          ),
          IconButton(
            icon: Icon(Icons.save, color: kmColors, size: 30),
            onPressed: () async {
              if (textController.text.isNotEmpty) {
                if (widget.isForPriceRate) {
                  StoreProvider.of<AppState>(context)
                      .dispatch(UpdatePriceRateThresholdAction(threshold: textController.text, context: widget.ctx));
                } else {
                  String newValue = textController.text;
                  if (widget.bodyKey == 'price') {
                    double tempValue = double.parse(newValue.split('.')[0]);
                    tempValue *= widget.priceFactor;
                    tempValue += widget.increasePercentage;
                    newValue = tempValue.toString();
                  }
                  bool result = await ProductsServices.updateProductsDetails(
                      bodyKey: widget.bodyKey,
                      value: newValue,
                      isForSubWarehouse: widget.isForSubWarehouse,
                      subWarehouseId: widget.productData.subWarehouseId.toString(),
                      productId: widget.productId.toString());
                  if (result) {
                    widget.onSavePressed(newValue, result);
                    if (Services.hasRole(context, supplierRole) && widget.bodyKey == 'price') {
                      newValue = (int.parse(newValue.split('.')[0]) - widget.increasePercentage ?? 0).toString();
                    }

                    setState(() => textController.text = newValue);
                  }
                  if (result) {
                    snackBar(success: result, message: 'تم التعديل بنجاح', context: context);
                  } else {
                    snackBar(success: result, message: 'فشلت عملية التعديل يرجى المحاولة مجدداً', context: context);
                  }
                }
              } else {
                Toast.show('الحقل فارغ !', context, duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
              }
            },
          ),
        ],
      ),
    );
  }
}
