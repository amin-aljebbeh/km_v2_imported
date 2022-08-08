import 'package:flutter/material.dart';
import 'package:kammun_app/modules/products/view/products_view.dart';

import '../../../core/core_importer.dart';
import '../model/special_products_model.dart';

class SpecialProductsWidget extends StatelessWidget {
  final SpecialProductsModel specialProductsModel;

  const SpecialProductsWidget({Key key, this.specialProductsModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
        converter: (store) => store.state,
        distinct: true,
        builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      alignment: WrapAlignment.spaceBetween,
                      children: [
                        Image.asset('assets/kmIcon.png', height: MediaQuery.of(context).size.height / 20),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AutoSizeText(specialProductsModel.title, style: paragraphStyle, maxLines: 1),
                            Text(
                                '( ${int.parse(specialProductsModel.totalNumber) - specialProductsModel.nonActiveNumber} منتج )',
                                style: disableStyle)
                          ],
                        ),
                      ],
                    ),
                    if (specialProductsModel.hasNext)
                      KOutlinedButton(
                          text: 'عرض الكل',
                          color: ColorUtils.kmColors2,
                          height: 40,
                          width: 100,
                          onTap: () {
                            Navigator.push(
                                navigatorKey.currentContext,
                                MaterialPageRoute(
                                    builder: (context) => ProductsView(
                                        productsViewType: ProductsViewTypes.featuredProducts,
                                        queryString: specialProductsModel.url)));
                          }),
                  ],
                ),
              ),
              HorizontalProducts(products: specialProductsModel.products, forInvoice: false),
            ],
          );
        });
  }
}
