import 'package:flutter/material.dart';
import 'package:kammun_app/views/Wedgit/widgets_importer.dart';
import 'package:kammun_app/views/prices_changes/services/prices_changes_services.dart';
import 'model/prices_changes_model.dart';
import 'package:kammun_app/utils/utils_importer.dart';

class Prices extends StatefulWidget {
  @override
  _PricesState createState() => _PricesState();
}

class _PricesState extends State<Prices> {
  TextEditingController _controller = new TextEditingController();
  bool isLoading;
  bool isError;
  String filter;
  PricesChanges productsList;
  int numberOfProducts;
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
    _controller.addListener(() {
      setState(() {
        filter = _controller.text;
      });
    });
    _loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: ColorUtils.primaryColor,
        child: Text(
          "$numberOfProducts",
          style: TextStyle(fontSize: 20),
        ),
      ),
      backgroundColor: Colors.white,
      appBar: InventorySearchTextField(
        onReload: () {
          _loadData();
        },
        controller: _controller,
        context: context,
      ),
      body: Column(
        children: <Widget>[
          isLoading
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 30.0),
                    child: Loader(),
                  ),
                )
              : isError
                  ? Center(
                      child: Expanded(
                        child: Column(
                          children: [
                            AlertMessages(
                              text: StringUtils.errorMessage,
                              messageType: "internetError",
                              headerText: "حدث خطأ",
                            ),
                            RaisedButton(
                              child: Text(StringUtils.tryAgain, style: blackBold),
                              onPressed: () => _loadData(),
                            ),
                          ],
                        ),
                      ),
                    )
                  : productsList.count == 0
                      ? Padding(
                          padding: const EdgeInsets.only(top: 30.0),
                          child: Center(
                            child: Text("لايجود منتجات تغير سعرها اليوم",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: StringUtils.fontFamilyHKGrotesk)),
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
                              var eachProduct = productsList.productsPriceChange[index];
                              if (filter == null ||
                                  filter == "" ||
                                  eachProduct.name.toLowerCase().contains(filter.toLowerCase())) {
                                return InventoryProductsViewCard(
                                  onChangeStatus: (result) {
                                    if (productsList.productsPriceChange[index].isActive == "1") {
                                      productsList.productsPriceChange[index].isActive = "0";
                                    } else {
                                      productsList.productsPriceChange[index].isActive = "1";
                                    }
                                  },
                                  onDelete: (result) {
                                    if (result) {
                                      setState(() {
                                        productsList.productsPriceChange.removeAt(index);
                                      });
                                    }
                                  },
                                  fromInventory: true,
                                  productData: eachProduct,
                                  oldPrice: int.parse(eachProduct.price.split(".")[0]) -
                                      int.parse(eachProduct.priceChange.toString().split(".")[0]),
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
