import 'package:adv_image_cache/adv_image_cache.dart';
import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:kammun_app/utils/utils_importer.dart';
import 'package:kammun_app/views/loading/LoadingServices.dart';

class FavoriteProductsViewCard extends StatefulWidget {
  final String img;
  final String productName;
  final String quantity;
  final int price;
  final int index;
  final int active;

  FavoriteProductsViewCard(
      {this.img,
      this.productName,
      this.quantity,
      this.price,
      this.index,
      this.active});

  @override
  State<StatefulWidget> createState() {
    return FavoriteProductsViewCardState();
  }
}

class FavoriteProductsViewCardState extends State<FavoriteProductsViewCard> {
  bool addedToCart = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColorLight,
      child: Padding(
        padding: EdgeInsets.only(left: 0, right: 0, top: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              //mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  width: 100.0,
                  height: 100.0,
                  decoration: new BoxDecoration(
                      borderRadius:
                          new BorderRadius.all(Radius.circular(20.0))),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Hero(
                          tag: widget.index + 100,
                          child: Image(
                            image: AdvImageCache(
                              widget.img,
                              useMemCache: true,
                              diskCacheExpire: Duration(days: 400),
                            ),
                          )
                          //           FadeInImage.assetNetwork(
                          //   fadeInCurve: Curves.fastOutSlowIn,
                          //   placeholder: "assets/kmIcon.png",
                          //   fit: BoxFit.contain,
                          //   image: widget.img,
                          //   width: MediaQuery.of(context).size.width,
                          //   height: 120,
                          // ),
                          )),
                ),
                SizedBox(width: 10),
                Expanded(
                    child: Container(
                  child: Wrap(
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                    fontFamily:
                                        UtilsImporter().stringUtils.HKGrotesk,
                                    fontSize: 18),
                              ),
                            ],
                          ),
                          SizedBox(height: 6),
                          Text(
                            widget.quantity,
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                color: UtilsImporter().colorUtils.greyColor,
                                fontFamily:
                                    UtilsImporter().stringUtils.HKGrotesk,
                                fontSize: 17),
                          ),
                          SizedBox(height: 8),
                          Text(
                              UtilsImporter()
                                      .stringUtils
                                      .oCcy
                                      .format(widget.price)
                                      .toString() +
                                  " ${LoadingScreenServices.companyInformation.currency}",
                              style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color:
                                      UtilsImporter().colorUtils.primaryColor,
                                  fontFamily:
                                      UtilsImporter().stringUtils.HKGrotesk,
                                  fontSize: 18)),
                        ],
                      ),
                    ],
                  ),
                )),
                widget.active == 0
                    ? Badge(
                        borderRadius: BorderRadius.zero,
                        shape: BadgeShape.square,
                        badgeColor: UtilsImporter().colorUtils.primaryColor,
                        badgeContent: Padding(
                          padding: const EdgeInsets.only(
                            right: 10.0,
                          ),
                          child: Column(
                            children: [
                              Text(
                                'نفذ من',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,

                                    //fontWeight: FontWeight.w500,
                                    fontFamily:
                                        UtilsImporter().stringUtils.HKGrotesk),
                              ),
                              Text(
                                'المستودعات',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    //   fontWeight: FontWeight.w500,
                                    fontFamily:
                                        UtilsImporter().stringUtils.HKGrotesk),
                              ),
                            ],
                          ),
                        ),
                      )
                    : Container(),
              ],
            ),
          ],
        ),
        // SizedBox(height: 4),
        //  Divider()
      ),
    );
  }
}
