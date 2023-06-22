import 'package:kammun_app/core/core_importer.dart';
import 'package:kammun_app/features/barcode/data/models/barcode_model.dart';
import 'package:kammun_app/features/products/presentation/widgets/add_product_widget.dart';
import 'package:kammun_app/features/products/presentation/widgets/product_widget.dart';
import 'package:kammun_app/features/products/presentation/widgets/products_view_app_bar.dart';

import '../redux/products_action.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => ProductsPageState();
}

class ProductsPageState extends State<ProductsPage> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var store = StoreProvider.of<AppState>(context);
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      distinct: true,
      builder: (context, state) {
        return WillPopScope(
          onWillPop: () async {
            store.dispatch(InitProducts());
            return true;
          },
          child: Scaffold(
            key: scaffoldKey,
            floatingActionButton: state.productsState.searchString == 'null' &&
                    state.barcodeState.barcodeRequestType != BarcodeRequestType.addBarcode &&
                    (Services.hasRole(context, adminRole) || Services.hasRole(context, productsControllerRole))
                ? AddProductWidget(scaffoldKey: scaffoldKey, categoryId: state.productsState.categoryId)
                : null,
            appBar: ProductsViewAppBar(
                scaffoldKey: scaffoldKey,
                searchController: searchController,
                onSubmit: () => Navigator.of(context).pop()),
            backgroundColor: Theme.of(context).primaryColorLight,
            body: SafeArea(
              child: state.productsState.badWordMatched
                  ? Center(child: funnyImages[0])
                  : state.productsState.products.isEmpty
                      ? ((state.loadingState.loading.isNotEmpty && state.productsState.products.isEmpty))
                          ? const FacebookLoader()
                          : Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(child: Text(state.errorState.errorMessage, style: mainStyle)))
                      : Padding(
                          padding: const EdgeInsets.only(left: 15, top: 10, right: 15, bottom: 0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Expanded(
                                child: NotificationListener<ScrollEndNotification>(
                                  onNotification: (ScrollEndNotification scrollInfo) {
                                    if (state.loadingState.loading.isEmpty &&
                                        state.productsState.hasNextProducts &&
                                        scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
                                      store.dispatch(SetProductsPage(page: state.productsState.productsPage + 1));
                                      store.dispatch(GetProductsAction());
                                    }
                                    return;
                                  },
                                  child: ListView.builder(
                                    physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
                                    primary: false,
                                    scrollDirection: Axis.vertical,
                                    shrinkWrap: true,
                                    itemCount: state.productsState.products.length,
                                    itemBuilder: (BuildContext context, int index) {
                                      var eachProduct = state.productsState.products[index];
                                      return ProductWidget(
                                        product: eachProduct,
                                        onChangeSubWarehouse: (id) {
                                          eachProduct.subWarehouseId = int.parse(id);
                                          state.productsState.products[index].subWarehouseId = int.parse(id);
                                        },
                                        index: index,
                                        scaffoldKey: scaffoldKey,
                                        onAddBarcode: (result) {
                                          if (result != 'error') {
                                            setState(() => state.productsState.products[index].barcodes
                                                .add(BarcodeModel(barcode: result)));
                                          }
                                        },
                                        onChangePrice: (newValue) =>
                                            setState(() => state.productsState.products[index].price = newValue),
                                        onChangeUnit: (newValue) =>
                                            setState(() => state.productsState.products[index].unit = newValue),
                                        onChangeQuantity: (newValue) =>
                                            setState(() => state.productsState.products[index].quantity = newValue),
                                      );
                                    },
                                  ),
                                ),
                              ),
                              if (state.loadingState.loading.isNotEmpty || !state.productsState.hasNextProducts)
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 50,
                                  color: Colors.transparent,
                                  child: Center(
                                    child: !state.productsState.hasNextProducts
                                        ? Text('تم جلب جميع المنتجات', style: boldStyle)
                                        : state.loadingState.loading.isNotEmpty
                                            ? const Loader()
                                            : const SizedBox(),
                                  ),
                                ),
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
