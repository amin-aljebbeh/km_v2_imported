import '../../../../core/core_importer.dart';
import '../../../products/presentation/pages/products_page.dart';
import '../../../products/presentation/redux/products_action.dart';

class ViewAllWidget extends StatelessWidget {
  final Widget page;
  final Function onTap;
  final double width;
  final ProductsViewTypes productsViewTypes;

  const ViewAllWidget({Key key, this.page, this.onTap, this.width, this.productsViewTypes}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var store = StoreProvider.of<AppState>(context);
    return StoreConnector<AppState, AppState>(
        converter: (store) => store.state,
        distinct: true,
        builder: (context, state) {
          return KammunButton(
            color: kmColors2,
            onTap: () {
              if (onTap != null) onTap();
              StoreProvider.of<AppState>(context).dispatch(InitProducts());
              store.dispatch(SetProductsViewTypes(productsViewTypes: productsViewTypes));
              store.dispatch(GetProductsAction());
              Navigator.push(context, MaterialPageRoute(builder: (context) => const ProductsPage()));
            },
            width: width,
            text: 'عرض الكل',
          );
        });
  }
}
