import 'package:kammun_app/core/core_importer.dart';
import 'package:kammun_app/features/loading/loading_services.dart';

class ShopperWidget extends StatefulWidget {
  final ShopperModel shopper;

  const ShopperWidget({Key key, @required this.shopper}) : super(key: key);

  @override
  State<StatefulWidget> createState() => ShopperWidgetState();
}

class ShopperWidgetState extends State<ShopperWidget> {
  String subWarehouseName = '';
  String id;
  String supplierCode;
  int isActive;
  String price;
  bool attached;
  bool loading;

  @override
  void initState() {
    loading = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColorLight,
      child: Padding(
        padding: const EdgeInsets.only(left: 0, right: 0, top: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Divider(thickness: 0.8, color: Colors.grey[800]),
            Row(
              children: <Widget>[
                KCacheImage(tag: widget.shopper.id, image: ''),
                const SizedBox(width: 10),
                Expanded(
                  child: Wrap(
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Wrap(
                            children: <Widget>[
                              Text(
                                widget.shopper.name,
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontFamily: fontFamily,
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: loading
                      ? const Loader()
                      : SwitchProductStatusWidget(
                          productId: 'null',
                          subWarehouseId: -1,
                          isForSubWarehouse: false,
                          preState: widget.shopper.status,
                          onChange: (int active, bool widgetResult) async {
                            setState(() => loading = true);
                            bool result = await Services.changeShopperStatusService(
                                shopperId: widget.shopper.id.toString(),
                                newStatus: widget.shopper.status == 1 ? '0' : '1');
                            setState(() {
                              loading = false;
                              if (result) {
                                LoadingScreenServices.allShoppers
                                    .firstWhere((shopper) => shopper.id == widget.shopper.id)
                                    .status = active;
                                widget.shopper.status = active;
                                if (result) {
                                  snackBar(success: result, message: 'تم تغيير حالة الكابتن بنجاح', context: context);
                                } else {
                                  snackBar(
                                      success: result,
                                      message: 'فشلت عملية تغيير حالة الاتصال يرجى المحاولة مجدداً',
                                      context: context);
                                }
                              }
                            });
                          },
                          height: 58,
                          width: 69,
                        ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
