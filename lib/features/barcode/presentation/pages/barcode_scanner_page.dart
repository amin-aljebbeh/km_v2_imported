import 'package:qr_mobile_vision/qr_camera.dart';

import '../../../../core/core_importer.dart';
import '../../../inventory/presentation/redux/inventory_action.dart';
import '../../../products/domain/entities/product_entity.dart';
import '../../../products/presentation/pages/products_page.dart';
import '../../../products/presentation/redux/products_action.dart';
import '../redux/barcode_action.dart';

class BarcodeScannerPage extends StatefulWidget {
  final ProductEntity product;

  const BarcodeScannerPage({Key key, this.product}) : super(key: key);

  @override
  _BarcodeScannerPageState createState() => _BarcodeScannerPageState();
}

class _BarcodeScannerPageState extends State<BarcodeScannerPage> {
  String barcode;
  bool done = false;

  @override
  Widget build(BuildContext context) {
    var store = StoreProvider.of<AppState>(context);
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      distinct: true,
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: kmColors,
            flexibleSpace: const SafeArea(
                top: true, child: Padding(padding: EdgeInsets.only(right: 120), child: AppBarKammunImage())),
          ),
          body: SafeArea(
            child: Stack(
              children: [
                QrCamera(
                  onError: (context, error) =>
                      Center(child: Text(error.toString(), style: mainStyle.copyWith(color: Colors.red))),
                  qrCodeCallback: (code) {
                    barcode = code;
                    if (barcode != null && !done) {
                      done = true;
                      store.dispatch(SetBarcodeString(barcodeString: barcode));
                      switch (state.barcodeState.barcodeRequestType) {
                        case BarcodeRequestType.search:
                          Navigator.of(context).pop();
                          store.dispatch(InitProducts());
                          store.dispatch(SetProductsViewTypes(productsViewTypes: ProductsViewTypes.barcode));
                          store.dispatch(GetProductsAction());
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const ProductsPage()));
                          break;
                        case BarcodeRequestType.addBarcode:
                        case BarcodeRequestType.addProduct:
                        case BarcodeRequestType.attachProduct:
                          Navigator.of(context).pop();
                          store.dispatch(GoToInventoryPage(context: context, inventoryType: InventoryTypes.barcode));
                          break;
                      }
                    }
                  },
                  notStartedBuilder: (context) => const Loader(),
                  offscreenBuilder: (context) => const Loader(),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height * 0.35,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(color: Colors.black.withOpacity(0.5)),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.35,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(color: Colors.black.withOpacity(0.5)),
                    ),
                  ],
                ),
                Positioned(
                  top: MediaQuery.of(context).size.height * 0.35,
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height * 0.2017,
                        width: MediaQuery.of(context).size.width * 0.2,
                        decoration: BoxDecoration(color: Colors.black.withOpacity(0.5)),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.2017,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.6,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  RotationTransition(
                                      turns: const AlwaysStoppedAnimation(-45 / 360),
                                      child: Icon(Icons.arrow_back_ios, color: kmColors)),
                                  RotationTransition(
                                      turns: const AlwaysStoppedAnimation(225 / 360),
                                      child: Icon(Icons.arrow_back_ios, color: kmColors)),
                                ],
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.6,
                              height: 0.1,
                              decoration: BoxDecoration(border: Border.all(color: Colors.red, width: 0.5)),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.6,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  RotationTransition(
                                      turns: const AlwaysStoppedAnimation(45 / 360),
                                      child: Icon(Icons.arrow_back_ios, color: kmColors)),
                                  RotationTransition(
                                      turns: const AlwaysStoppedAnimation(135 / 360),
                                      child: Icon(Icons.arrow_back_ios, color: kmColors)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.2017,
                        width: MediaQuery.of(context).size.width * 0.2,
                        decoration: BoxDecoration(color: Colors.black.withOpacity(0.5)),
                      ),
                    ],
                  ),
                ),
                if (state.barcodeState.barcodeRequestType == BarcodeRequestType.addProduct ||
                    state.barcodeState.barcodeRequestType == BarcodeRequestType.attachProduct)
                  Positioned(
                    bottom: 15,
                    right: MediaQuery.of(context).size.width * 0.05,
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: KammunButton(
                      height: 50,
                      color: primaryColor,
                      onTap: () {
                        Navigator.of(context).pop();
                        state.barcodeState.onIgnore(null);
                      },
                      text: 'الإضافة بدون كود',
                    ),
                  ),
                SizedBox(
                  height: 100,
                  width: MediaQuery.of(context).size.width,
                  child: Card(
                    child: Center(
                      child: (state.barcodeState.barcodeRequestType == BarcodeRequestType.addProduct)
                          ? Text(add, style: decisionButtonStyle)
                          : (state.barcodeState.barcodeRequestType == BarcodeRequestType.search)
                              ? Text(search, style: decisionButtonStyle)
                              : Column(
                                  children: [
                                    Text(widget.product.name, style: decisionButtonStyle),
                                    Text(
                                      widget.product.quantity +
                                          ' ' +
                                          (widget.product.unit != 'null' ? widget.product.unit : ''),
                                      style: decisionButtonStyle,
                                    ),
                                  ],
                                ),
                    ),
                    color: kmColors,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
