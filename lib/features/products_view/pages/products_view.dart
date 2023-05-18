import 'package:kammun_app/core/core_importer.dart';
import 'package:kammun_app/features/products_view/pages/add_products.dart';

import 'barcode_screen.dart';

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
  TextEditingController searchController = TextEditingController();

  bool isLoading = false;
  bool firstLoading = false;
  int page = 1;
  List<ProductData> productsList = [];
  bool searchLoading = false;
  bool theEndOfProducts = false;
  String errorMessage = 'لم يتم العثور على المنتج';

  final _random = Random();

  bool badWordMatched = false;

  Future<bool> _loadData(String query, ProductsViewTypes type) async {
    setState(() => badWordMatched = false);
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
          ? FloatingActionButton(
              backgroundColor: kmColors2,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BarCodeScreen(
                      requestType: BarcodeRequestType.addProduct,
                      onIgnore: (barcode) {
                        int param;
                        if (barcode == null) {
                          param = null;
                        } else {
                          param = int.parse(barcode);
                        }
                        Navigator.push(
                          scaffoldKey.currentContext,
                          MaterialPageRoute(
                              builder: (screenContext) =>
                                  AddProductsView(categoryId: widget.categoryId, barcode: param)),
                        );
                      },
                    ),
                  ),
                );
              },
              tooltip: 'Pick Image',
              child: const Icon(Icons.add),
            )
          : null,
      appBar: PreferredSize(
        child: AppBar(
          backgroundColor: const Color.fromARGB(255, 210, 178, 2),
          automaticallyImplyLeading: false, // hides leading widget
          flexibleSpace: SafeArea(
            top: true,
            left: false,
            bottom: false,
            right: false,
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: IconButton(
                        icon: const Icon(Icons.shopping_cart, size: 35, color: Colors.white),
                        onPressed: () => Navigator.of(context)
                            .pushNamedAndRemoveUntil(CartView.routeName, (Route<dynamic> route) => false),
                      ),
                    ),
                    const AppBarKammunImage(),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: InkWell(
                        onTap: () => Navigator.of(context).pop(true),
                        child: const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 40),
                      ),
                    ),
                  ],
                ),
                StoreSearchTextField(
                  scaffoldKey: scaffoldKey,
                  searchController: searchController,
                  onSubmit: () => setState(() => {productsList.clear(), Navigator.of(context).pop()}),
                ),
              ],
            ),
          ),
        ),
        preferredSize: const Size.fromHeight(105.0),
      ),
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
                                      setState(() => productsList[index].barcodes.add(Barcode(barcode: result)));
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
