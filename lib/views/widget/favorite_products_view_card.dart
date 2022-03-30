import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:kammun_app/utils/utils_importer.dart';
import 'package:kammun_app/views/Widget/widgets_importer.dart';
import 'package:kammun_app/views/loading/LoadingServices.dart';

class FavoriteProductsViewCard extends StatefulWidget {
  final String img;
  final String productName;
  final String quantity;
  final int price;
  final int index;
  final int active;

  const FavoriteProductsViewCard({Key key, this.img, this.productName, this.quantity, this.price, this.index, this.active}) : super(key: key);

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
        padding: const EdgeInsets.only(left: 0, right: 0, top: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              //mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                KCacheImage(
                  tag: widget.index + 100,
                  image: widget.img,
                ),
                const SizedBox(width: 10),
                Expanded(
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
                                      fontFamily: StringUtils.fontFamilyHKGrotesk,
                                      fontSize: 18),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              widget.quantity,
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  color: ColorUtils.greyColor,
                                  fontFamily: StringUtils.fontFamilyHKGrotesk,
                                  fontSize: 17),
                            ),
                            const SizedBox(height: 8),
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
                    )),
                widget.active == 0
                    ? Badge(
                        borderRadius: BorderRadius.zero,
                        shape: BadgeShape.square,
                        badgeColor: ColorUtils.primaryColor,
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
                                    fontFamily: StringUtils.fontFamilyHKGrotesk),
                              ),
                              Text(
                                'المستودعات',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    //   fontWeight: FontWeight.w500,
                                    fontFamily: StringUtils.fontFamilyHKGrotesk),
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
