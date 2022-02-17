import 'package:flutter/material.dart';
import 'package:kammun_app/utils/utils_importer.dart';
import 'model/inventory_model_importer.dart';
import 'services/inventory_services.dart';
import 'dart:io';
import '../../Services.dart';
import '../widget/widgets_importer.dart';
import '../../models/models_importer.dart';

class InventoryFileProduct extends StatefulWidget {
  final File file;
  final String subWarehouseId;

  const InventoryFileProduct({Key key, @required this.subWarehouseId, @required this.file}) : super(key: key);
  @override
  _InventoryFileProductState createState() => _InventoryFileProductState();
}

class _InventoryFileProductState extends State<InventoryFileProduct> {
  InventoryFileProductModel importedProducts = InventoryFileProductModel();
  List<ProductData> showList = List<ProductData>();
  bool sent;
  bool error;
  bool loading;
  int selectedList;

  assignArray() {
    setState(() {
      showList = List<ProductData>();
      switch (selectedList) {
        case 0:
          showList.addAll(importedProducts.nonIntroducedProducts);
          break;
        case 1:
          showList.addAll(importedProducts.toActiveList);
          break;
        case 2:
          showList.addAll(importedProducts.toDeActiveList);
          break;
        case 3:
          showList.addAll(importedProducts.activatedList);
          break;
      }
    });
  }

  loadData() async {
    var response = await InventoryServices.fromFileChangedStatusProducts(
        file: widget.file, subWarehouseId: widget.subWarehouseId);
    setState(() {
      loading = false;
      if (response == null) {
        error = true;
      } else {
        error = false;
        importedProducts = response;
        assignArray();
      }
    });
  }

  @override
  void initState() {
    selectedList = 0;
    loading = false;
    error = false;
    sent = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              Center(
                child: DropdownButton(
                  onChanged: (value) {
                    setState(() {
                      selectedList = value;
                      assignArray();
                    });
                  },
                  items: Services.dropdownStringList(
                      ['الغير المضافة', 'بحاجة تفعيل', 'بحاجة إيقاف تفعيل', 'تم تفعيلها']),
                  value: selectedList,
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.75,
                child: !sent
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: KammunButton(
                            onTap: () {
                              setState(() {
                                sent = true;
                                loading = true;
                              });
                              loadData();
                            },
                            color: ColorUtils.primaryColor,
                            height: 50,
                            text: 'إرسال الملف',
                          ),
                        ),
                      )
                    : error
                        ? Center(
                            child: AlertMessages(
                              text: StringUtils.errorMessage,
                              messageType: "internetError",
                              headerText: "حدث خطأ أثناء رفع الملف",
                            ),
                          )
                        : loading
                            ? Loader()
                            : showList.length == 0
                                ? Center(
                                    child: AlertMessages(
                                      text: StringUtils.errorMessage,
                                      messageType: "green",
                                      headerText: 'لا يوجد منتجات في هذا القسم',
                                    ),
                                  )
                                : ListView.builder(
                                    scrollDirection: Axis.vertical,
                                    itemCount: showList.length,
                                    itemBuilder: (BuildContext context, int index) {
                                      return InventoryProductsViewCard(
                                        productData: showList[index],
                                        price: showList[index].price,
                                        fromInventory: false,
                                        oldPrice: int.parse(showList[index].price.split(".")[0]) -
                                            int.parse(showList[index].priceChange.toString().split(".")[0]),
                                        onChangeStatus: (result) {
                                          if (result) {
                                            setState(() {
                                              showList[index] = showList.removeLast();
                                            });
                                          }
                                        },
                                      );
                                    },
                                  ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
