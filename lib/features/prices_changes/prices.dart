import 'package:kammun_app/features/loading/loading_services.dart';
import 'package:kammun_app/features/prices_changes/services/prices_changes_services.dart';

import '../../core/core_importer.dart';
import 'model/prices_changes_model.dart';

class Prices extends StatefulWidget {
  static const String routeName = '/Prices';
  const Prices({Key key}) : super(key: key);

  @override
  _PricesState createState() => _PricesState();
}

class _PricesState extends State<Prices> {
  final TextEditingController _controller = TextEditingController();
  bool isLoading;
  bool isError;
  String filter;
  PricesChanges productsList;
  int numberOfProducts;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  _loadData() async {
    setState(() {
      isLoading = true;
      isError = false;
    });
    productsList = await PricesChangesServices.loadData();

    if (productsList != null) {
      setState(() {
        isLoading = false;
        isError = false;
        numberOfProducts = productsList.count;
      });
    } else {
      setState(() {
        isLoading = false;
        isError = true;
      });
    }
  }

  @override
  void initState() {
    numberOfProducts = 0;
    setState(() {});
    _controller.addListener(() => setState(() => filter = _controller.text));
    _loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: primaryColor,
        child: Text('$numberOfProducts', style: const TextStyle(fontSize: 20)),
      ),
      backgroundColor: Colors.white,
      appBar: InventorySearchTextField(onReload: () => _loadData(), controller: _controller, context: context),
      body: Column(
        children: <Widget>[
          isLoading
              ? const Center(child: Padding(padding: EdgeInsets.only(top: 30.0), child: Loader()))
              : isError
                  ? Center(
                      child: Expanded(
                        child: Column(
                          children: [
                            AlertMessages(text: errorMessage, messageType: 'internetError', headerText: 'حدث خطأ'),
                            ElevatedButton(child: Text(tryAgain, style: blackBold), onPressed: () => _loadData()),
                          ],
                        ),
                      ),
                    )
                  : productsList.count == 0
                      ? Padding(
                          padding: const EdgeInsets.only(top: 30.0),
                          child: Center(
                            child: Text('لا يوجد منتجات تغير سعرها اليوم',
                                style: TextStyle(
                                    color: Colors.black, fontWeight: FontWeight.bold, fontFamily: fontFamily)),
                          ),
                        )
                      : Expanded(
                          child: ListView.builder(
                            physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
                            primary: false,
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount: productsList == null ? 0 : productsList.productsPriceChange.length,
                            itemBuilder: (BuildContext context, int index) {
                              if (filter == null ||
                                  filter == '' ||
                                  productsList.productsPriceChange[index].name
                                      .toLowerCase()
                                      .contains(filter.toLowerCase())) {
                                String id, supplierCode;
                                int isActive;
                                bool attached;
                                if (productsList.productsPriceChange[index].subWarehouseId != -1) {
                                  id = productsList.productsPriceChange[index].subWarehouseId.toString();
                                } else {
                                  List<int> subWarehousesIds =
                                      LoadingScreenServices.subWarehouses.map((warehouse) => warehouse.id).toList();
                                  List<int> productIds = productsList.productsPriceChange[index].warehouses
                                      .map((warehouse) => int.parse(warehouse.pivot.subWarehouseId))
                                      .toList();
                                  subWarehousesIds.removeWhere((id) => !productIds.contains(id));
                                  if (subWarehousesIds.isNotEmpty) {
                                    id = subWarehousesIds[0].toString();
                                  } else if (productsList.productsPriceChange[index].warehouses.isNotEmpty) {
                                    id = productsList.productsPriceChange[index].warehouses[0].pivot.subWarehouseId;
                                  }
                                }
                                if (productsList.productsPriceChange[index].supplierCode != null) {
                                  supplierCode = productsList.productsPriceChange[index].supplierCode;
                                } else if (productsList.productsPriceChange[index].warehouses.isNotEmpty) {
                                  supplierCode = productsList.productsPriceChange[index].warehouses
                                      .firstWhere((warehouse) => warehouse.pivot.supplierCode != 'null')
                                      .pivot
                                      .supplierCode;
                                }
                                if (productsList.productsPriceChange[index].isActive != 'null') {
                                  isActive = int.parse(productsList.productsPriceChange[index].isActive);
                                } else if (productsList.productsPriceChange[index].warehouses.isNotEmpty) {
                                  isActive =
                                      int.parse(productsList.productsPriceChange[index].warehouses[0].pivot.isActive);
                                }
                                attached = false;
                                if (productsList.productsPriceChange[index].supplierCode != 'null') {
                                  attached = true;
                                } else if (productsList.productsPriceChange[index].warehouses != null) {
                                  if (productsList.productsPriceChange[index].warehouses.isNotEmpty) {
                                    attached = productsList.productsPriceChange[index].warehouses
                                        .map((warehouse) => warehouse.pivot.supplierCode)
                                        .toList()
                                        .where((code) => code != 'null')
                                        .toList()
                                        .isNotEmpty;
                                  }
                                }
                                return InventoryProductsViewCard(
                                  index: 0,
                                  id: id,
                                  attached: attached,
                                  isActive: isActive,
                                  supplierCode: supplierCode,
                                  price: productsList.productsPriceChange[index].price != '0'
                                      ? productsList.productsPriceChange[index].price
                                      : productsList.productsPriceChange[index].warehouses.isNotEmpty
                                          ? productsList.productsPriceChange[index].warehouses[0].pivot.price
                                          : '0',
                                  scaffoldKey: scaffoldKey,
                                  onChangeStatus: (result) {
                                    setState(() {
                                      if (productsList.productsPriceChange[index].isActive == '1') {
                                        productsList.productsPriceChange[index].isActive = '0';
                                      } else {
                                        productsList.productsPriceChange[index].isActive = '1';
                                      }
                                    });
                                  },
                                  onDelete: (result) {
                                    if (result) setState(() => productsList.productsPriceChange.removeAt(index));
                                  },
                                  fromInventory: true,
                                  productData: productsList.productsPriceChange[index],
                                  oldPrice: int.parse(productsList.productsPriceChange[index].price.split('.')[0]) -
                                      int.parse(productsList.productsPriceChange[index].priceChange.split('.')[0]),
                                  onChangePrice: (newValue) =>
                                      setState(() => productsList.productsPriceChange[index].price = newValue),
                                  onChangeUnit: (newValue) =>
                                      setState(() => productsList.productsPriceChange[index].unit = newValue),
                                  onChangeQuantity: (newValue) =>
                                      setState(() => productsList.productsPriceChange[index].quantity = newValue),
                                );
                              }
                              return Container();
                            },
                          ),
                        ),
        ],
      ),
    );
  }
}
