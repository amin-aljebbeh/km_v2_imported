import 'package:kammun_app/features/products/domain/entities/product_entity.dart';

import '../../../../core/core_importer.dart';
import 'invoice_product.dart';

class HorizontalProducts extends StatelessWidget {
  final List<ProductEntity> products;
  final bool forInvoice;

  const HorizontalProducts({Key key, this.products, this.forInvoice = true}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.width / 2,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        primary: false,
        shrinkWrap: true,
        physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
        itemCount: products.length,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.only(left: 0, right: 5, top: 0),
            child: InvoiceProduct(index: index, product: products[index], forInvoice: forInvoice),
          );
        },
      ),
    );
  }
}
