import 'package:kammun_app/features/products/domain/entities/product_entity.dart';

import '../../../../core/core_importer.dart';
import '../../../products_view/services/products_services.dart';


class FeaturedProductWidget extends StatefulWidget {
  final ProductEntity product;
  const FeaturedProductWidget({Key key, this.product}) : super(key: key);

  @override
  _FeaturedProductWidgetState createState() => _FeaturedProductWidgetState();
}

class _FeaturedProductWidgetState extends State<FeaturedProductWidget> {
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    return loading
        ? CircularProgressIndicator(color: kmColors)
        : InkWell(
            onTap: () async {
              setState(() => loading = true);
              bool result = await ProductsServices.updateProductsDetails(
                  productId: widget.product.productId.toString(),
                  bodyKey: 'is_featured',
                  isForSubWarehouse: true,
                  subWarehouseId: widget.product.subWarehouseId.toString(),
                  value: (widget.product.isFeatured == 1 ? 0 : 1).toString());
              setState(() => loading = false);
              if (result) {
                setState(() => widget.product.isFeatured = widget.product.isFeatured == 1 ? 0 : 1);
              }
            },
            child: Icon(Icons.stars_rounded,
                color: widget.product.isFeatured == 1 ? kmColors : searchGreyColor),
          );
  }
}
