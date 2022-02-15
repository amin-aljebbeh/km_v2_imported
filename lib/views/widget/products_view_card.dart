import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:kammun_app/models/productsCategoriesModel.dart';
import 'package:kammun_app/utils/utils_importer.dart';
import 'package:kammun_app/views/loading/LoadingServices.dart';
import 'package:kammun_app/views/product_detail_view/product_detail_view.dart';

import '../../Services.dart';
import 'widgets_importer.dart';

class ProductsViewCard extends StatefulWidget {
  final int index;
  final ProductData product;

  ProductsViewCard({this.index, this.product});

  @override
  State<StatefulWidget> createState() {
    return ProductsViewCardState();
  }
}

class ProductsViewCardState extends State<ProductsViewCard> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (widget.product.isActive == '1') {
          Services.userVisitProduct(widget.product.id.toString());

          Navigator.push(
            context,
            new MaterialPageRoute(
              builder: (context) => new ProductDetailView(
                product: widget.product,
                isFromFavoriteScreen: false,
              ),
            ),
          );
        } else {
          showMyDialog(
              dialogButtons: [
                DialogButton(
                    text: StringUtils.close,
                    onTap: () {
                      Navigator.of(context).pop();
                    }),
                DialogButton(
                  text: StringUtils.tellMe,
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
              title: 'نفذ المنتح من المستودعات',
              context: context,
              text:
                  '${widget.product.name} غير متوفر في المستودعات\nإذا كنت ترغب باستلام إشعار عند توفره مرة أخرى اضغط على ${StringUtils.tellMe}.');
        }
      },
      child: Container(
        color: Theme.of(context).primaryColorLight,
        child: Padding(
          padding: EdgeInsets.only(left: 0, right: 0, top: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Container(
                    width: 100.0,
                    height: 100.0,
                    decoration: new BoxDecoration(borderRadius: new BorderRadius.all(Radius.circular(20.0))),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) {
                              return FullScreenImage(
                                imageUrl: widget.product.images.length != 0
                                    ? LoadingScreenServices.imagePrefixUrl + widget.product.images[0].imageFileName
                                    : "",
                                tag: "generate_a_unique_tag",
                              );
                            },
                          ),
                        );
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Hero(
                          tag: widget.index + 100,
                          child: FadeInImage.assetNetwork(
                            fadeInCurve: Curves.fastOutSlowIn,
                            placeholder: "assets/kmIcon.png",
                            fit: BoxFit.contain,
                            image: widget.product.images.length > 0
                                ? LoadingScreenServices.imagePrefixUrl + widget.product.images[0].imageFileName
                                : "",
                            width: MediaQuery.of(context).size.width,
                            height: 120,
                          ),
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
                                    widget.product.name,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontFamily: StringUtils.fontFamilyHKGrotesk,
                                        fontSize: 18),
                                  ),
                                ],
                              ),
                              SizedBox(height: 6),
                              Text(
                                widget.product.unit.toString() != "null"
                                    ? widget.product.quantity + " " + widget.product.unit.toString()
                                    : widget.product.quantity,
                                style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    color: ColorUtils.greyColor,
                                    fontFamily: StringUtils.fontFamilyHKGrotesk,
                                    fontSize: 17),
                              ),
                              SizedBox(height: 8),
                              Text(
                                StringUtils()
                                        .oCcy
                                        .format(int.parse(widget.product.price.split(".")[0]))
                                        .toString() +
                                    " ${LoadingScreenServices.companyInformation.currency}",
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: ColorUtils.primaryColor,
                                    fontFamily: StringUtils.fontFamilyHKGrotesk,
                                    fontSize: 18),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  widget.product.isActive == '0'
                      ? Badge(
                          borderRadius: BorderRadius.zero,
                          shape: BadgeShape.square,
                          badgeColor: ColorUtils.primaryColor,
                          badgeContent: Column(
                            children: [
                              Text(
                                'أخبرني',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontFamily: StringUtils.fontFamilyHKGrotesk,
                                ),
                              ),
                            ],
                          ),
                        )
                      : Container(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
