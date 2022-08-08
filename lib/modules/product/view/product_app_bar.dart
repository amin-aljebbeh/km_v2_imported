import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';

import '../../../core/core_importer.dart';
import '../service/product_service.dart';

class ProductAppBar extends StatelessWidget {
  final List<ProductImage> productImages;
  const ProductAppBar({Key key, this.productImages}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
        converter: (store) => store.state,
        distinct: true,
        builder: (context, state) {
          return SliverAppBar(
            automaticallyImplyLeading: false,
            iconTheme: const IconThemeData(color: Colors.transparent),
            expandedHeight: MediaQuery.of(context).size.height / 3,
            floating: false,
            pinned: true,
            leading: const PopArrow(color: Colors.black),
            actions: const <Widget>[
              Padding(padding: EdgeInsets.only(top: 15.0, left: 20), child: CartIcon(color: Colors.black))
            ],
            backgroundColor: Colors.white,
            flexibleSpace: Container(
              alignment: Alignment.bottomCenter,
              child: productImages.isNotEmpty
                  ? Padding(
                      padding: const EdgeInsets.only(top: 40, left: 5, right: 5, bottom: 10),
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        decoration: const BoxDecoration(
                            color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(20.0))),
                        child: Carousel(
                          onImageTap: (index) => Navigator.push(context, MaterialPageRoute(builder: (_) {
                            return FullScreenImage(
                              imageUrl: state.startupState.startModel.company.imageBaseUrl +
                                  productImages[index].imageFileName,
                              tag: 'generate_a_unique_tag',
                            );
                          })),
                          dotColor: ColorUtils.kmColors,
                          dotIncreasedColor: ColorUtils.kmColors,
                          dotBgColor: Colors.transparent,
                          borderRadius: true,
                          boxFit: BoxFit.cover,
                          images: ProductService.getProductImages(images: productImages),
                          autoplay: true,
                          animationCurve: Curves.fastLinearToSlowEaseIn,
                          animationDuration: const Duration(milliseconds: 1000),
                          dotSize: 6.0,
                          indicatorBgPadding: 8.0,
                        ),
                      ),
                    )
                  : Image.asset('assets/logobw.png'),
            ),
          );
        });
  }
}
