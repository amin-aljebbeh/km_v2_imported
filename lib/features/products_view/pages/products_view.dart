import 'package:kammun_app/core/core_importer.dart';
import 'package:kammun_app/features/products/domain/entities/product_entity.dart';
import 'package:kammun_app/features/products_view/widgets/add_product_widget.dart';
import 'package:kammun_app/features/products_view/widgets/products_view_app_bar.dart';

import '../../products/domain/entities/barcode_entity.dart';

class ProductsView extends StatefulWidget {
  final String categoryId;
  final String queryString;
  final String barcode;

  const ProductsView({Key key, @required this.categoryId, this.queryString, this.barcode}) : super(key: key);

  @override
  State<StatefulWidget> createState() => ProductsViewState();
}

class ProductsViewState extends State<ProductsView> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController searchController = TextEditingController();

  bool isLoading = false;
  bool firstLoading = false;
  int page = 1;
  List<ProductEntity> productsList = [];
  bool searchLoading = false;
  bool theEndOfProducts = false;
  String errorMessage = 'لم يتم العثور على المنتج';

  final _random = Random();

  bool badWordMatched = false;

  Future<bool> _loadData(String query, ProductsViewTypes type) async {
    if (badWordMatched) setState(() => badWordMatched = false);
    String url = '';
    if (badWord.contains(query)) setState(() => badWordMatched = true);
    if (!badWordMatched) {
      switch (type) {
        case ProductsViewTypes.search:
          url = searchProducts + '$query?page=' + page.toString();
          break;
        case ProductsViewTypes.category:
          url = getCategory + '$query?page=$page';
          break;
        case ProductsViewTypes.barcode:
          url = searchProductByBarcode + query;
          break;
      }

      if (!theEndOfProducts) {
        try {
          var response = await ApiProvider.sendRequest(url: url, method: HttpMethods.get);
          if (response.statusCode == successCode) {
            if (!response.data['success'] && response.data['reason'] == 'No results') {
              setState(() {
                searchLoading = false;
                if (firstLoading == true) firstLoading = false;
                isLoading = false;
                if (productsList.isNotEmpty) theEndOfProducts = true;
              });
            } else {
              dynamic products;
              switch (type) {
                case ProductsViewTypes.search:
                case ProductsViewTypes.category:
                  products = categoryProductFromJson(jsonEncode(response.data));
                  productsList.addAll(products.data.data);
                  break;
                case ProductsViewTypes.barcode:
                  products = syncCartFromJson(jsonEncode(response.data['data']));
                  setState(() {
                    productsList.clear();
                    productsList = syncCartFromJson(jsonEncode(response.data['data']));
                  });
                  break;
              }

              if (mounted) {
                setState(() {
                  if (type != ProductsViewTypes.barcode && page - 1 == products.data.lastPage) theEndOfProducts = true;
                  searchLoading = false;

                  if (firstLoading == true) firstLoading = false;
                  isLoading = false;
                });
              }
            }
            return response.statusCode == 200;
          } else {
            setState(() {
              errorMessage = 'حدث خطأ أثناء محاولة جلب البيانات \n يرجى التحقق من إتصالك بالأنترنت';
              isLoading = false;
              searchLoading = false;
              firstLoading = false;
            });
          }
        } catch (e) {
          /**/
        }
      } else {
        return false;
      }
      return false;
    } else {}
    return false;
  }

  @override
  initState() {
    if (mounted) super.initState();
    if (widget.barcode != null) {
      _loadData(widget.barcode, ProductsViewTypes.barcode);
    } else if (widget.queryString != null) {
      _loadData(widget.queryString, ProductsViewTypes.search);
      searchController.text = widget.queryString;
    } else {
      _loadData(widget.categoryId, ProductsViewTypes.category);
    }
    setState(() => firstLoading = true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      floatingActionButton: widget.queryString == null &&
              widget.barcode == null &&
              (Services.hasRole(context, adminRole) || Services.hasRole(context, productsControllerRole))
          ? AddProductWidget(scaffoldKey: scaffoldKey, categoryId: widget.categoryId)
          : null,
      appBar: ProductsViewAppBar(
          scaffoldKey: scaffoldKey,
          searchController: searchController,
          onSubmit: () => setState(() => {productsList.clear(), Navigator.of(context).pop()})),
      backgroundColor: Theme.of(context).primaryColorLight,
      body: SafeArea(
        child: badWordMatched
            ? Center(child: funnyImages[_random.nextInt(funnyImages.length)])
            : productsList.isEmpty
                ? (searchLoading || firstLoading)
                    ? const FacebookLoader()
                    : Padding(
                        padding: const EdgeInsets.all(8.0), child: Center(child: Text(errorMessage, style: mainStyle)))
                : Padding(
                    padding: const EdgeInsets.only(left: 15, top: 10, right: 15, bottom: 0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                          child: NotificationListener<ScrollNotification>(
                            onNotification: (ScrollNotification scrollInfo) {
                              if (!isLoading && scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
                                setState(() => {page++, isLoading = true});
                                searchController.text != ''
                                    ? _loadData(searchController.text, ProductsViewTypes.search)
                                    : _loadData(widget.categoryId, ProductsViewTypes.category);
                              }
                              return;
                            },
                            child: ListView.builder(
                              physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
                              primary: false,
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemCount: productsList == null ? 0 : productsList.length,
                              itemBuilder: (BuildContext context, int index) {
                                var eachProduct = productsList[index];
                                return ProductsViewCard(
                                  product: eachProduct,
                                  onChangeSubWarehouse: (id) {
                                    eachProduct.subWarehouseId = int.parse(id);
                                    productsList[index].subWarehouseId = int.parse(id);
                                  },
                                  index: index,
                                  scaffoldKey: scaffoldKey,
                                  onAddBarcode: (result) {
                                    if (result != 'error') {
                                      setState(() => productsList[index].barcodes.add(BarcodeEntity(barcode: result)));
                                    }
                                  },
                                  onChangePrice: (newValue) => setState(() => productsList[index].price = newValue),
                                  onChangeUnit: (newValue) => setState(() => productsList[index].unit = newValue),
                                  onChangeQuantity: (newValue) =>
                                      setState(() => productsList[index].quantity = newValue),
                                );
                              },
                            ),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: isLoading ? 50.0 : 0,
                          color: Colors.transparent,
                          child: Center(
                            child: widget.barcode == null
                                ? theEndOfProducts
                                    ? Text('تم جلب جميع المنتجات', style: boldStyle)
                                    : const Loader()
                                : Container(),
                          ),
                        ),
                      ],
                    ),
                  ),
      ),
    );
  }
}
