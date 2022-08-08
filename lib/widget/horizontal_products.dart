import '../core/core_importer.dart';

class HorizontalProducts extends StatelessWidget {
  final List<ProductData> products;
  final bool forInvoice;

  const HorizontalProducts({Key key, this.products, this.forInvoice = true}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 220,
          width: MediaQuery.of(context).size.width,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            primary: false,
            shrinkWrap: true,
            physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
            itemCount: products.length,
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: const EdgeInsets.only(left: 0, right: 10, top: 0),
                child: InvoiceProduct(index: index, product: products[index], forInvoice: forInvoice),
              );
            },
          ),
        ),
      ],
    );
  }
}
