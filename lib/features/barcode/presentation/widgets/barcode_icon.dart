import 'package:kammun_app/features/barcode/presentation/pages/barcode_scanner_page.dart';

import '../../../../core/core_importer.dart';
import '../../../products/domain/entities/product_entity.dart';
import '../redux/barcode_action.dart';

class BarcodeIcon extends StatelessWidget {
  final BarcodeRequestType requestType;
  final int productId;
  final Function onPressed;
  final Color color;
  final GlobalKey<ScaffoldState> scaffoldKey;
  final Function(String) onAddBarcode;
  final ProductEntity product;

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
        if (onPressed != null) onPressed();
        StoreProvider.of<AppState>(context).dispatch(SetBarcodeType(barcodeRequestType: requestType));
        StoreProvider.of<AppState>(context).dispatch(SetonIgnore(onIgnore: (barcode) async {
          StoreProvider.of<AppState>(context).dispatch(SetBarcodeToProductAction(
              productId: productId,
              barcode: int.parse(barcode),
              context: context,
              onSuccess: (barcode) => onAddBarcode(barcode)));
        }));
        Navigator.push(scaffoldKey.currentContext,
            MaterialPageRoute(builder: (screenContext) => BarcodeScannerPage(product: product)));
      },
    );
  }
}
