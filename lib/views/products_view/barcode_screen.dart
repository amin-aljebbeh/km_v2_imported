import 'package:flutter/material.dart';
import 'package:kammun_app/utils/utils_importer.dart';
import 'package:kammun_app/views/widget/widgets_importer.dart';
import 'package:qr_mobile_vision/qr_camera.dart';
import 'products_view.dart';

class BarCodeScreen extends StatefulWidget {
  const BarCodeScreen({Key key}) : super(key: key);

  @override
  _BarCodeScreenState createState() => _BarCodeScreenState();
}

class _BarCodeScreenState extends State<BarCodeScreen> with SingleTickerProviderStateMixin {
  String barcode;
  @override
  void dispose() {
    super.dispose();
  }

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorUtils.kmColors2,
        flexibleSpace: const SafeArea(
          top: true,
          child: Padding(
            padding: EdgeInsets.only(right: 120),
            child: AppBarKammunImage(),
          ),
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height,
              child: QrCamera(
                onError: (context, error) => Text(
                  error.toString(),
                  style: const TextStyle(color: Colors.red),
                ),
                qrCodeCallback: (code) {
                  setState(() async {
                    barcode = code;
                    Navigator.of(context).pop();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductsView(
                          barcode: barcode,
                          categoryId: "0",
                        ),
                      ),
                    );
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
                                child: Icon(
                                  Icons.arrow_back_ios,
                                  color: ColorUtils.kmColors2,
                                ),
                              ),
                              RotationTransition(
                                turns: const AlwaysStoppedAnimation(225 / 360),
                                child: Icon(
                                  Icons.arrow_back_ios,
                                  color: ColorUtils.kmColors2,
                                ),
                              ),
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
                                child: Icon(
                                  Icons.arrow_back_ios,
                                  color: ColorUtils.kmColors2,
                                ),
                              ),
                              RotationTransition(
                                turns: const AlwaysStoppedAnimation(135 / 360),
                                child: Icon(
                                  Icons.arrow_back_ios,
                                  color: ColorUtils.kmColors2,
                                ),
                              ),
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
          ],
        ),
      ),
    );
  }
}
