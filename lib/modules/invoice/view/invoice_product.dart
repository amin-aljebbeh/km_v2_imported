import 'package:flutter/material.dart';
import 'package:kammun_app/core/core_importer.dart';

import '../../product/view/product_detail_view.dart';

class InvoiceProduct extends StatelessWidget {
  final ProductData product;
  final int index;
  final bool forInvoice;
  const InvoiceProduct({Key key, this.product, this.index, this.forInvoice = true}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () {
              if (!forInvoice) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProductDetailView(
                        product: product,
                        initialCount: state.cartState.cartProducts
                            .firstWhere((someProduct) => someProduct.id == product.id,
                                orElse: () => ProductData(productCount: 1))
                            .productCount),
                  ),
                );
              }
            },
            child: KCard(
              radius: 20,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      KCacheImage(
                        tag: product.id,
                        image: product.images.isNotEmpty ? product.images[0].imageFileName : '',
                      ),
                      const SizedBox(height: 10),
                      Text(
                        product.name.split(' ').length <= 2
                            ? product.name
                            : product.name.split(' ')[0] + ' ' + (product.name.split(' ')[1] ?? ' ') + '...',
                        textAlign: TextAlign.center,
                        style: textFieldStyle,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        StringUtils().oCcy.format(int.parse(product.price.split('.')[0])) +
                            ' ' +
                            state.startupState.startModel.company.currency,
                        textAlign: TextAlign.right,
                        style: naveBarStyle,
                      ),
                      const SizedBox(height: 10),
                      forInvoice
                          ? Text('x ' + product.productCount.toString(),
                              textAlign: TextAlign.right, style: naveBarStyle)
                          : Text(
                              product.unit.toString() != 'null'
                                  ? product.quantity.split('.')[0] + ' ' + product.unit.toString()
                                  : product.quantity.split('.')[0],
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  color: ColorUtils.greyColor,
                                  fontFamily: StringUtils.fontFamily,
                                  fontSize: 15),
                            ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
