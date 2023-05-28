import 'package:kammun_app/core/core_importer.dart';

import '../../../transactions/presentation/redux/transactions_action.dart';
import '../../domain/entities/shopper_entity.dart';
import '../redux/shoppers_action.dart';

class ShopperWidget extends StatefulWidget {
  final ShopperEntity shopper;

  const ShopperWidget({Key key, @required this.shopper}) : super(key: key);

  @override
  State<StatefulWidget> createState() => ShopperWidgetState();
}

class ShopperWidgetState extends State<ShopperWidget> {
  bool loading;

  @override
  void initState() {
    loading = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      distinct: true,
      builder: (context, state) {
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
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: KCacheImage(tag: widget.shopper.id, image: ''),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(widget.shopper.name,
                              style: mainStyle.copyWith(fontWeight: FontWeight.w700, fontSize: 18)),
                          Wrap(
                            children: [
                              if (Services.hasPermission(context, advancedTransactionPermission))
                                InkWell(
                                  onTap: () {
                                    StoreProvider.of<AppState>(context)
                                        .dispatch(GetShopperReportAction(shopperId: widget.shopper.id));
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                TransactionsPage(adminId: widget.shopper.adminId, isShopper: true)));
                                  },
                                  child: Icon(Icons.featured_play_list, color: primaryColor),
                                )
                            ],
                          )
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
                                bool result = await GeneralApis.changeShopperStatusService(
                                    shopperId: widget.shopper.id.toString(),
                                    newStatus: widget.shopper.status == 1 ? '0' : '1');
                                setState(() {
                                  loading = false;
                                  if (result) {
                                    widget.shopper.status = active;
                                    StoreProvider.of<AppState>(context)
                                        .dispatch(ShopperChanged(shopper: widget.shopper));
                                    if (result) {
                                      snackBar(
                                          success: result, message: 'تم تغيير حالة الكابتن بنجاح', context: context);
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
      },
    );
  }
}
