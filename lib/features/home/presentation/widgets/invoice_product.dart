import 'package:kammun_app/features/products/domain/entities/product_entity.dart';

import '../../../../core/core_importer.dart';
import '../../../product_details/presentation/pages/product_detail_view.dart';

class InvoiceProduct extends StatefulWidget {
  final ProductEntity product;
  final int index;
  final bool forInvoice;
  const InvoiceProduct({Key key, this.product, this.index, this.forInvoice = true}) : super(key: key);

  @override
  _InvoiceProductState createState() => _InvoiceProductState();
}

class _InvoiceProductState extends State<InvoiceProduct> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () => goToProduct(context: context, state: state),
            child: KCard(
              radius: const BorderRadius.all(Radius.circular(20)),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      KCacheImage(
                          tag: widget.product.productId,
                          image: widget.product.images.isNotEmpty ? widget.product.images[0].imageFileName : ''),
                      Text(
                        widget.product.name.split(' ').length <= 2
                            ? widget.product.name
                            : widget.product.name.split(' ')[0] +
                                ' ' +
                                (widget.product.name.split(' ')[1] ?? ' ') +
                                '...',
                        textAlign: TextAlign.center,
                        style: textFieldStyle,
                      ),
                      Text(
                              widget.product.unit.toString() != 'null'
                                  ? widget.product.quantity.split('.')[0] + ' ' + widget.product.unit
                                  : widget.product.quantity.split('.')[0],
                              style: invoiceProductStyle),
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

  goToProduct({BuildContext context, AppState state}) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => ProductDetailView(product: widget.product)));
  }
}
