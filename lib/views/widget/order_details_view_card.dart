import 'package:flutter/material.dart';
import 'package:kammun_app/utils/utils_importer.dart';
import 'package:kammun_app/views/loading/LoadingServices.dart';

class OrderDetailViewCard extends StatefulWidget {
  final String img;
  final String productName;
  final String quantity;
  final int price;
  final int index;
  final String unit;
  final String productCount;

  OrderDetailViewCard(
      {this.img, this.productName, this.quantity, this.price, this.index, this.unit, this.productCount});

  @override
  State<StatefulWidget> createState() {
    return OrderDetailViewCardState();
  }
}

class OrderDetailViewCardState extends State<OrderDetailViewCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColorLight,
      child: Padding(
        padding: EdgeInsets.only(left: 0, right: 0, top: 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                new Container(
                  width: 100.0,
                  height: 100.0,
                  decoration: new BoxDecoration(borderRadius: new BorderRadius.all(Radius.circular(20.0))),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Hero(
                      tag: widget.index + 100,
                      child: FadeInImage(
                        fadeInCurve: Curves.fastOutSlowIn,
                        placeholder: AssetImage("assets/kmIcon.png"),
                        fit: BoxFit.contain,
                        image: widget.img.length > 0 ? NetworkImage(widget.img) : AssetImage("assets/kmIcon.png"),
                        width: MediaQuery.of(context).size.width,
                        height: 120,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                    child: Container(
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
                                    fontWeight: FontWeight.w700,
                                    fontFamily: StringUtils.fontFamilyHKGrotesk,
                                    fontSize: 18),
                              ),
                            ],
                          ),
                          SizedBox(height: 6),
                          Text(
                            widget.quantity + " " + widget.unit,
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                color: ColorUtils.greyColor,
                                fontFamily: StringUtils.fontFamilyHKGrotesk,
                                fontSize: 17),
                          ),
                          SizedBox(height: 8),
                          Text(
                              StringUtils().oCcy.format(widget.price).toString() +
                                  " ${LoadingScreenServices.companyInformation.currency}",
                              style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: ColorUtils.primaryColor,
                                  fontFamily: StringUtils.fontFamilyHKGrotesk,
                                  fontSize: 18)),
                        ],
                      ),
                    ],
                  ),
                )),
                Container(
                  margin: const EdgeInsets.all(15.0),
                  padding: const EdgeInsets.all(3.0),
                  decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.all(Radius.circular(10.0) //                 <--- border radius here
                              ),
                      border: Border.all(color: ColorUtils.primaryColor, width: 2)),
                  child: Center(
                      child: Text(
                    widget.productCount,
                    style: TextStyle(fontSize: 25),
                  )),
                )
              ],
            ),
            SizedBox(height: 4),
            Divider()
          ],
        ),
      ),
    );
  }
}
