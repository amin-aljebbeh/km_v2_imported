import '../../features/products_view/services/products_services.dart';
import '../core_importer.dart';

class PrimeProductWidget extends StatefulWidget {
  final OrderProduct product;
  const PrimeProductWidget({Key key, this.product}) : super(key: key);

  @override
  _PrimeProductWidgetState createState() => _PrimeProductWidgetState();
}

class _PrimeProductWidgetState extends State<PrimeProductWidget> {
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    return loading
        ? CircularProgressIndicator(color: kmColors)
        : InkWell(
            onTap: () async {
              setState(() => loading = true);
              bool result = await ProductsServices.updateProductsDetails(
                  productId: widget.product.id.toString(),
                  bodyKey: 'is_prime_item',
                  isForSubWarehouse: false,
                  value: (widget.product.isPrimeItem == 1 ? 0 : 1).toString());
              setState(() => loading = false);
              if (result) {
                setState(() => widget.product.isPrimeItem = widget.product.isPrimeItem == 1 ? 0 : 1);
              }
            },
            child: Icon(Icons.label_important_rounded,
                color: widget.product.isPrimeItem == 1 ? kmColors : searchGreyColor),
          );
  }
}
