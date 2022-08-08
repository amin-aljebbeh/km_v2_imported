import 'package:flutter/material.dart';
import 'package:kammun_app/core/core_importer.dart';

class OrderDetailViewCard extends StatefulWidget {
  final String img;
  final String productName;
  final String quantity;
  final int price;
  final int productId;
  final String unit;
  final String productCount;

  const OrderDetailViewCard(
      {Key key, this.img, this.productName, this.quantity, this.price, this.productId, this.unit, this.productCount})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return OrderDetailViewCardState();
  }
}

class OrderDetailViewCardState extends State<OrderDetailViewCard> {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      builder: (context, state) {
        return Container(
          color: Theme.of(context).primaryColorLight,
          child: Padding(
            padding: const EdgeInsets.only(left: 0, right: 0, top: 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    KCacheImage(image: widget.img, tag: widget.productId),
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
                                    widget.productName,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w700, fontFamily: StringUtils.fontFamily, fontSize: 18),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Text(
                                widget.quantity + ' ' + widget.unit,
                                style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    color: ColorUtils.greyColor,
                                    fontFamily: StringUtils.fontFamily,
                                    fontSize: 17),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                  StringUtils().oCcy.format(widget.price).toString() +
                                      state.startupState.startModel.company.currency,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      color: ColorUtils.primaryColor,
                                      fontFamily: StringUtils.fontFamily,
                                      fontSize: 18)),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.all(15.0),
                      padding: const EdgeInsets.all(3.0),
                      decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                          border: Border.all(color: ColorUtils.primaryColor, width: 2)),
                      child: Center(child: Text(widget.productCount, style: const TextStyle(fontSize: 25))),
                    )
                  ],
                ),
                const SizedBox(height: 4),
                const Divider()
              ],
            ),
          ),
        );
      },
    );
  }
}
