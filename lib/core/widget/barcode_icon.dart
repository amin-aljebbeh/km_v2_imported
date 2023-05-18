import 'package:kammun_app/features/products_view/pages/barcode_screen.dart';
import 'package:kammun_app/features/products_view/services/products_services.dart';

import '../core_importer.dart';

class BarcodeIcon extends StatelessWidget {
  final BarcodeRequestType requestType;
  final int productId;
  final Function onPressed;
  final Color color;
  final GlobalKey<ScaffoldState> scaffoldKey;
  final Function(String) onAddBarcode;
  final ProductData product;

  const BarcodeIcon({
    Key key,
    @required this.requestType,
    this.productId,
    this.onPressed,
    this.color,
    this.scaffoldKey,
    this.onAddBarcode,
    this.product,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(KIcons.barcode_2, size: 30, color: color),
      onPressed: () {
        bool result;
        String resultBarcode;
        if (onPressed != null) onPressed();
        Navigator.push(
          scaffoldKey.currentContext,
          MaterialPageRoute(
            builder: (screenContext) => BarCodeScreen(
              product: product,
              requestType: requestType,
              onIgnore: (barcode) async {
                resultBarcode =
                    await ProductsServices.setBarcodeToProduct(bareCode: int.parse(barcode), productId: productId);
                result = (resultBarcode != 'error');
                if (result) {
                  snackBar(success: result, message: 'تم إرسال الرمز بنجاح', context: context);
                } else {
                  snackBar(success: result, message: 'فشلت عملية إرسال الرمز يرجى المحاولة مجدداً', context: context);
                }
                onAddBarcode(resultBarcode);
              },
            ),
          ),
        );
      },
    );
  }
}
