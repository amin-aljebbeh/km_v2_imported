import 'package:flutter/material.dart';
import 'package:kammun_app/core/core_importer.dart';

class OrderProblemProduct extends StatelessWidget {
  final ProductData product;
  final int hero;
  final bool lastProduct;
  const OrderProblemProduct({Key key, this.product, this.hero, this.lastProduct}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      builder: (context, state) {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: KCard(
                radius: 6,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: <Widget>[
                      KCacheImage(
                        tag: product.id,
                        image: product.images.isNotEmpty ? product.images[0].imageFileName : '',
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                product.name,
                                style: TextStyle(
                                    fontWeight: FontWeight.w700, fontFamily: StringUtils.fontFamily, fontSize: 18),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                product.quantity.toString() + ' ' + product.unit.toString(),
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  color: ColorUtils.greyColor,
                                  fontFamily: StringUtils.fontFamily,
                                  fontSize: 17,
                                ),
                              ),
                              const SizedBox(height: 8),
                              SizedBox(
                                width: 300,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '${StringUtils().oCcy.format(int.parse(product.price.split('.')[0]))} ${state.startupState.startModel.company.currency}',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        color: ColorUtils.primaryColor,
                                        fontFamily: StringUtils.fontFamily,
                                        fontSize: 18,
                                        decoration: TextDecoration.lineThrough,
                                        decorationThickness: 35,
                                      ),
                                    ),
                                    Text(
                                      '${StringUtils().oCcy.format(int.parse(product.newPrice.split('.')[0]))} ${state.startupState.startModel.company.currency}',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        color: int.parse(product.price.split('.')[0]) >
                                                int.parse(product.newPrice.split('.')[0])
                                            ? Colors.green
                                            : Colors.red,
                                        fontFamily: StringUtils.fontFamily,
                                        fontSize: 18,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 25),
                    ],
                  ),
                ),
              ),
            ),
            if (lastProduct) const EndOfPageWidget(),
          ],
        );
      },
    );
  }
}
