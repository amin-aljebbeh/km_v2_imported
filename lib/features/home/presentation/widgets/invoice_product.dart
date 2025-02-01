import 'package:kammun_app/features/products/domain/entities/product_entity.dart';

import '../../../../core/core_importer.dart';
import '../../../product_details/presentation/pages/product_detail_view.dart';

class InvoiceProduct extends StatelessWidget {
  final ProductEntity product;
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
          child: KCard(onTap: () => Navigator.push(
                context, MaterialPageRoute(builder: (context) => ProductDetailView(product: product))),
            radius: const BorderRadius.all(Radius.circular(20)),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    KCacheImage(
                        tag: product.productId,
                        image: product.images.isNotEmpty ? product.images[0].imageFileName : ''),
                    Text(
                      product.name.split(' ').length <= 2
                          ? product.name
                          : product.name.split(' ')[0] +
                          ' ' +
                          (product.name.split(' ')[1] ?? ' ') +
                          '...',
                      textAlign: TextAlign.center,
                      style: textFieldStyle,
                    ),
                    Text(
                        product.unit.toString() != 'null'
                            ? product.quantity.split('.')[0] + ' ' + product.unit
                            : product.quantity.split('.')[0],
                        style: invoiceProductStyle),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}