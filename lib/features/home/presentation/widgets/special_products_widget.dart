import '../../../../core/core_importer.dart';
import '../../../products/presentation/pages/products_page.dart';
import '../../data/models/special_products_model.dart';
import 'horizontal_products.dart';
import 'view_all_widget.dart';

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
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AutoSizeText(specialProductsModel.title, style: paragraphStyle, maxLines: 1),
                        Text('( ${specialProductsModel.totalNumber} منتج )', style: disableStyle)
                      ],
                    ),
                    if (specialProductsModel.hasNext)
                      ViewAllWidget(
                          width: MediaQuery.of(context).size.width / 3,
                          productsViewTypes: specialProductsModel.productsViewTypes,
                          page: const ProductsPage()),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5),
                child: HorizontalProducts(products: specialProductsModel.products, forInvoice: false),
              ),
            ],
          );
        });
  }
}
