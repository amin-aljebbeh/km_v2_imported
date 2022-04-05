// ignore_for_file: prefer_const_constructors

import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:kammun_app/models/products_categories_model.dart';
import 'package:kammun_app/utils/utils_importer.dart';
import 'package:kammun_app/views/loading/loading_services.dart';
import 'package:kammun_app/views/product_detail_view/product_detail_view.dart';

import '../../service.dart';
import 'widgets_importer.dart';

class ProductsViewCard extends StatefulWidget {
  final int index;
  final ProductData product;

  const ProductsViewCard({Key key, this.index, this.product}) : super(key: key);

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
            MaterialPageRoute(
              builder: (context) => ProductDetailView(
                product: widget.product,
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
          padding: const EdgeInsets.only(left: 0, right: 0, top: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Container(
                    width: 100.0,
                    height: 100.0,
                    decoration: BoxDecoration(borderRadius: BorderRadius.all(const Radius.circular(20.0))),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) {
                              return FullScreenImage(
                                imageUrl: widget.product.images.isNotEmpty
                                    ? LoadingScreenServices.imagePrefixUrl + widget.product.images[0].imageFileName
                                    : "",
                                tag: "generate_a_unique_tag",
                              );
                            },
                          ),
                        );
                      },
                      child: KCacheImage(
                          tag: widget.index + 100,
                          image: widget.product.images.isNotEmpty
                              ? LoadingScreenServices.imagePrefixUrl + widget.product.images[0].imageFileName
                              : ""),
                    ),
                  ),
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
                                  widget.product.name,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontFamily: StringUtils.fontFamilyHKGrotesk,
                                      fontSize: 18),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
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
                            const SizedBox(height: 8),
                            Text(
                              StringUtils().oCcy.format(int.parse(widget.product.price.split(".")[0])).toString() +
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
