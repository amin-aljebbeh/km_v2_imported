import 'package:flutter/material.dart';
import 'package:kammun_app/models/models_importer.dart';
import 'package:kammun_app/utils/tools.dart';
import 'package:kammun_app/views/Wedgit/widgets_importer.dart';
import 'package:kammun_app/utils/utils_importer.dart';
import 'package:kammun_app/views/products_view/services/products_services.dart';

class BarcodeProducts extends StatefulWidget {
  final String barcode;
  final Function onIgnore;
  final BarcodeRequestType requestType;

  const BarcodeProducts({Key key, @required this.barcode, this.onIgnore, @required this.requestType})
      : super(key: key);
  @override
  _BarcodeProductsState createState() => _BarcodeProductsState();
}

class _BarcodeProductsState extends State<BarcodeProducts> {
  List<ProductData> productsList = List<ProductData>();
  bool isLoading = false;
  bool isError = false;
  bool displayToActiveProducts = true;
  TextEditingController _controller = new TextEditingController();
  String filter;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  _loadData() async {
    productsList.clear();
    setState(() {
      isLoading = true;
      isError = false;
    });
    try {
      var response;
      if (widget.requestType == BarcodeRequestType.addProduct ||
          widget.requestType == BarcodeRequestType.addBarcode)
        response = await ProductsServices.checkProductBarcode(bareCode: widget.barcode);
      else
        response = await ProductsServices.searchProductByBarcode(bareCode: widget.barcode);
      if (response != null) {
        productsList.addAll(response);
        if (productsList.isEmpty) {
          Navigator.of(context).pop();
          widget.onIgnore();
        }
        setState(() {
          isLoading = false;
        });
        return true;
      } else {
        setState(() {
          isLoading = false;
          isError = true;
        });
        return false;
      }
    } catch (e) {
      Tools.logToConsole("Error While getting Inventory Products");
      Tools.logToConsole(e.toString());
      setState(() {
        isLoading = false;
        isError = true;
      });
      return false;
    }
  }

  @override
  initState() {
    if (this.mounted) {
      super.initState();
    }
    _loadData();

    _controller.addListener(() {
      setState(() {
        filter = _controller.text;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      appBar: InventorySearchTextField(
        onReload: () {
          _loadData();
        },
        controller: _controller,
        context: context,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height * 0.75,
              child: isLoading
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
                                    onPressed: () {
                                      _loadData();
                                    }),
                              ],
                            ),
                          ),
                        )
                      : ListView.builder(
                          physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
                          primary: false,
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: productsList == null ? 0 : productsList.length,
                          itemBuilder: (BuildContext context, int index) {
                            var eachProduct = productsList[index];
                            try {
                              if (filter == null ||
                                  filter == "" ||
                                  eachProduct.description.toLowerCase().contains(filter.toLowerCase())) {
                                return InventoryProductsViewCard(
                                  barcode: widget.barcode,
                                  scaffoldKey: scaffoldKey,
                                  fromInventory: false,
                                  onDelete: (result) {
                                    if (result) {
                                      setState(() {
                                        productsList.removeAt(index);
                                      });
                                    }
                                  },
                                  productData: eachProduct,
                                  onChangeStatus: (result) {
                                    if (result) {
                                      setState(() {
                                        if (productsList[index].isActive == "1") {
                                          productsList[index].isActive = "0";
                                        } else {
                                          productsList[index].isActive = "1";
                                        }
                                      });
                                    }
                                  },
                                );
                              }
                            } catch (e) {}
                            return Container();
                          },
                        ),
            ),
            KammunButton(
              color: ColorUtils.primaryColor,
              onTap: () {
                Navigator.pop(context);
                widget.onIgnore();
              },
              text: 'تجاهل',
              height: 50,
              width: MediaQuery.of(context).size.width * 0.95,
            )
          ],
        ),
      ),
    );
  }
}
