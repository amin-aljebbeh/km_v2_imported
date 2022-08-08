import 'package:flutter/material.dart';
import 'package:kammun_app/modules/products/redux/products_action.dart';

import '../../../core/core_importer.dart';
import '../../product/view/products_view_card.dart';

class ProductsView extends StatefulWidget {
  final String categoryId;
  final String queryString;
  final String barcode;
  final ProductsViewTypes productsViewType;

  const ProductsView({Key key, this.categoryId, this.queryString = '', this.barcode, this.productsViewType})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => ProductsViewState();
}

class ProductsViewState extends State<ProductsView> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController searchController = TextEditingController();
  final _random = Random();
  bool badWordMatched = false;

  @override
  initState() {
    super.initState();
    if (widget.productsViewType == ProductsViewTypes.search) {
      searchController.text = widget.queryString;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      StoreProvider.of<AppState>(context).dispatch(NoError());
      StoreProvider.of<AppState>(context).dispatch(FirstProductPage());
      if (!badWord.contains(widget.queryString)) {
        String query;
        switch (widget.productsViewType) {
          case ProductsViewTypes.search:
            query = widget.queryString;
            break;
          case ProductsViewTypes.category:
            query = widget.categoryId;
            break;
          case ProductsViewTypes.barcode:
            query = widget.barcode;
            break;
          case ProductsViewTypes.favorite:
            query = '';
            break;
          case ProductsViewTypes.alert:
            query = '';
            break;
          case ProductsViewTypes.featuredProducts:
            query = widget.queryString;
            break;
        }
        StoreProvider.of<AppState>(context)
            .dispatch(GetProducts(productsViewTypes: widget.productsViewType, query: query));
      } else {
        setState(() => badWordMatched = true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      builder: (context, state) {
        return TemporaryLoading(
          child: Scaffold(
            key: scaffoldKey,
            drawer: const KDrawer(),
            appBar: KAppBar(
                searchController: searchController,
                scaffoldKey: scaffoldKey,
                isFromStore: state.productsState.productsType == ProductsViewTypes.favorite),
            backgroundColor: Theme.of(context).primaryColorLight,
            body: SafeArea(
              child: badWordMatched
                  ? Center(child: funnyImages[_random.nextInt(funnyImages.length)])
                  : state.productsState.products.isEmpty
                      ? state.loadingState.isLoading
                          ? const FacebookLoader()
                          : Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(child: Text('لا يوجد منتجات', style: paragraphStyle)),
                            )
                      : state.errorState.isError
                          ? Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(child: Text(state.errorState.errorMessage, style: paragraphStyle)),
                            )
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Expanded(
                                  child: NotificationListener<ScrollEndNotification>(
                                    onNotification: (ScrollEndNotification scrollInfo) {
                                      if (!state.loadingState.isLoading &&
                                          scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent &&
                                          state.productsState.hasNext &&
                                          widget.productsViewType != ProductsViewTypes.barcode) {
                                        StoreProvider.of<AppState>(context).dispatch(NextProductsPage());
                                        String query;
                                        switch (widget.productsViewType) {
                                          case ProductsViewTypes.search:
                                            query = widget.queryString;
                                            break;
                                          case ProductsViewTypes.category:
                                            query = widget.categoryId;
                                            break;
                                          case ProductsViewTypes.barcode:
                                            query = widget.barcode;
                                            break;
                                          case ProductsViewTypes.favorite:
                                            query = '';
                                            break;
                                          case ProductsViewTypes.alert:
                                            query = '';
                                            break;
                                          case ProductsViewTypes.featuredProducts:
                                            query = widget.queryString;
                                            break;
                                        }
                                        StoreProvider.of<AppState>(context).dispatch(
                                            GetProducts(query: query, productsViewTypes: widget.productsViewType));
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
                                        return ProductsViewCard(
                                          product: eachProduct,
                                          index: index,
                                          lastProduct: (!state.productsState.hasNext ||
                                                  state.productsState.productsType == ProductsViewTypes.barcode) &&
                                              index == state.productsState.products.length - 1,
                                        );
                                      },
                                    ),
                                  ),
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 50,
                                  color: Colors.transparent,
                                  child: Center(
                                    child: !state.productsState.hasNext ||
                                            widget.productsViewType == ProductsViewTypes.barcode
                                        ? Text('تم جلب جميع المنتجات', style: paragraphStyle)
                                        : Container(),
                                  ),
                                ),
                              ],
                            ),
            ),
          ),
          condition: state.productsState.products.isNotEmpty && widget.productsViewType != ProductsViewTypes.favorite,
        );
      },
    );
  }
}
