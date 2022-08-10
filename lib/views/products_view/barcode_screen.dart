import 'package:kammun_app/views/products_view/barcode_products.dart';
import 'package:qr_mobile_vision/qr_camera.dart';

import '../../core/core_importer.dart';
import 'products_view.dart';

class BarCodeScreen extends StatefulWidget {
  final BarcodeRequestType requestType;
  final Function(String) onIgnore;
  final ProductData productData;

  const BarCodeScreen({Key key, @required this.requestType, this.onIgnore, this.productData}) : super(key: key);

  @override
  _BarCodeScreenState createState() => _BarCodeScreenState();
}

class _BarCodeScreenState extends State<BarCodeScreen> with SingleTickerProviderStateMixin {
  String barcode;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorUtils.kmColors,
        flexibleSpace:
            const SafeArea(top: true, child: Padding(padding: EdgeInsets.only(right: 120), child: AppBarKammunImage())),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height,
              child: QrCamera(
                onError: (context, error) => Text(error.toString(), style: const TextStyle(color: Colors.red)),
                qrCodeCallback: (code) {
                  setState(() async {
                    barcode = code;
                    if (barcode != null) {
                      switch (widget.requestType) {
                        case BarcodeRequestType.search:
                          Navigator.of(context).pop();
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => ProductsView(barcode: barcode, categoryId: "0")));
                          break;
                        case BarcodeRequestType.addBarcode:
                        case BarcodeRequestType.addProduct:
                        case BarcodeRequestType.attachProduct:
                          Navigator.of(context).pop();
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => BarcodeProducts(
                                      onIgnore: () => widget.onIgnore(barcode),
                                      requestType: widget.requestType,
                                      barcode: barcode)));
                          break;
                      }
                    }
                  });
                },
              ),
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
                                  child: Icon(Icons.arrow_back_ios, color: ColorUtils.kmColors)),
                              RotationTransition(
                                  turns: const AlwaysStoppedAnimation(225 / 360),
                                  child: Icon(Icons.arrow_back_ios, color: ColorUtils.kmColors)),
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
                                  child: Icon(Icons.arrow_back_ios, color: ColorUtils.kmColors)),
                              RotationTransition(
                                  turns: const AlwaysStoppedAnimation(135 / 360),
                                  child: Icon(Icons.arrow_back_ios, color: ColorUtils.kmColors)),
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
            if (widget.requestType == BarcodeRequestType.addProduct ||
                widget.requestType == BarcodeRequestType.attachProduct)
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(height: 1),
                    KammunButton(
                      height: 50,
                      color: ColorUtils.primaryColor,
                      onTap: () {
                        Navigator.of(context).pop();
                        widget.onIgnore(null);
                      },
                      text: 'الإضافة بدون كود',
                    ),
                  ],
                ),
              ),
            SizedBox(
              height: 100,
              width: MediaQuery.of(context).size.width,
              child: Card(
                child: Center(
                  child: (widget.requestType == BarcodeRequestType.addProduct)
                      ? Text(StringUtils.add, style: decisionButtonStyle)
                      : (widget.requestType == BarcodeRequestType.search)
                          ? Text(StringUtils.search, style: decisionButtonStyle)
                          : Column(
                              children: [
                                Text(widget.productData.name, style: decisionButtonStyle),
                                Text(
                                  widget.productData.quantity +
                                      ' ' +
                                      (widget.productData.unit != 'null' ? widget.productData.unit : ''),
                                  style: decisionButtonStyle,
                                ),
                              ],
                            ),
                ),
                color: ColorUtils.kmColors,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
