import 'package:flutter/material.dart';
import 'package:kammun_app/Services.dart';
import 'package:kammun_app/models/productsCategoriesModel.dart';
import 'package:kammun_app/utils/Loader.dart';
import 'package:kammun_app/utils/utils_importer.dart';
import 'package:kammun_app/views/Wedgit/entry_field.dart';
import 'package:kammun_app/views/Wedgit/kammun_button.dart';
import 'package:kammun_app/views/loading/LoadingServices.dart';
import 'package:kammun_app/views/products_attached_to_warehouse/services/added_products_services.dart';
import 'package:toast/toast.dart';

class AddProductsToSubWarehouse extends StatefulWidget {
  final ProductData productData;

  AddProductsToSubWarehouse({this.productData});

  @override
  _AddProductsToSubWarehouseState createState() =>
      _AddProductsToSubWarehouseState();
}

class _AddProductsToSubWarehouseState extends State<AddProductsToSubWarehouse> {
  List<DropdownMenuItem> listSubWarehouses = new List<DropdownMenuItem>();

  int _selectedValue = -1;

  Widget _entryField(
      {bool canBeEmpty = true,
      TextEditingController controller,
      String hint,
      @required String title,
      String subTitle,
      @required TextInputType fieldType,
      bool isAddress = false,
      double width,
      bool isPhoneNumber = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          title,
          style: TextStyle(
              fontFamily: UtilsImporter().stringUtils.HKGrotesk,
              fontWeight: FontWeight.bold),
        ),
        subTitle == null
            ? Container(width: 0, height: 0)
            : Text(
                subTitle,
              ),
        SizedBox(height: 8),
        EntryField(
          width: width ?? MediaQuery.of(context).size.width,
          isPhoneNumber: isPhoneNumber,
          isAddress: isAddress,
          canBeEmpty: canBeEmpty,
          hint: hint,
          fieldType: fieldType,
          controller: controller,
        ),
        SizedBox(height: 20),
      ],
    );
  }

  bool isLoading = false;
  bool isError = false;

  Future<bool> _addNewProduct() async {
    setState(() {
      isLoading = true;
      isError = false;
    });
    dynamic body = {
      "product_id": widget.productData.id.toString(),
      "sub_warehouse_id": _selectedValue.toString(),
      "price": priceController.text != null ? priceController.text : "0",
      "is_featured": "0",
      "is_active": switchController ? "1" : "0",
      "priority": "100",
      "supplier_code": supplierCodeController.text,
      "min_threshold": "0",
      "increase_percentage": "0",
      "price_factor":
          priceFactorController.text != null ? priceFactorController.text : "1",
      "automatic_activation": "0",
    };

    bool response = await AddedProductsServices.attachProductsToSubWarehouse(
        fullRequestBody: body);
    Services.resultFlushBar(context: context, result: response);
    if (response) {
      setState(() {
        isLoading = false;
        isError = false;
      });
      Navigator.of(context).pop();
    } else {
      setState(() {
        isLoading = false;
        isError = true;
      });
    }
    return response;
  }

  final TextEditingController priceFactorController = TextEditingController();
  final TextEditingController supplierCodeController = TextEditingController();
  final TextEditingController priceController = TextEditingController();

  bool switchController = false;

  @override
  void initState() {
    for (int i = 0; i < LoadingScreenServices.subWarehouses.length; i++) {
      listSubWarehouses.add(DropdownMenuItem(
        child: Text(LoadingScreenServices.subWarehouses[i].name),
        value: LoadingScreenServices.subWarehouses[i].id,
      ));
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 210, 178, 2),
        automaticallyImplyLeading: false,
        // hides leading widget

        flexibleSpace: SafeArea(
          // top: true,
          // left: false,
          // bottom: false,
          // right: false,
          child: Column(
            children: <Widget>[
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Opacity(
                      opacity: 0.0,
                      child: Icon(
                        Icons.home,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5.0),
                      child: Transform.scale(
                        scale: 2,
                        child: InkWell(
                          onTap: () {
                            Navigator.pushNamedAndRemoveUntil(
                              context,
                              '/home',
                              (Route<dynamic> route) => false,
                            );
                          },
                          child: Image.asset(
                            "assets/logobw.png",
                            width: 150,
                            height: 50,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.only(top: 5.0, left: 0),
                        child: IconButton(
                            onPressed: () => Navigator.of(context).pop(true),
                            icon: Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.white,
                              size: 40,
                            ))),
                  ]),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding:
              const EdgeInsets.only(top: 25.0, bottom: 8, left: 8, right: 8),
          child: isLoading
              ? Center(child: Loader())
              : ListView(
                  shrinkWrap: true,
                  children: [
                    Text(
                      "يرجى إختيار المستودع التابع لهذه المادة",
                      style: TextStyle(
                        fontFamily: UtilsImporter().stringUtils.HKGrotesk,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    ListTile(
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 10.0, vertical: 0.0),
                      title: Column(
                        children: LoadingScreenServices.subWarehouses
                            .map((data) => Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                  ),
                                  child: RadioListTile(
                                    controlAffinity:
                                        ListTileControlAffinity.trailing,
                                    activeColor: Theme.of(context).primaryColor,
                                    title: Text(
                                      "${data.name}",
                                      style: TextStyle(
                                        fontFamily: UtilsImporter()
                                            .stringUtils
                                            .HKGrotesk,
                                      ),
                                    ),
                                    groupValue: _selectedValue,
                                    value: data.id,
                                    onChanged: (val) {
                                      setState(() {
                                        _selectedValue = data.id;
                                      });
                                    },
                                  ),
                                ))
                            .toList(),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _entryField(
                            controller: supplierCodeController,
                            title: UtilsImporter().stringUtils.supplierCode,
                            fieldType: TextInputType.name,
                            hint: "123456",
                            width: MediaQuery.of(context).size.width / 3),
                        _entryField(
                            controller: priceController,
                            title: UtilsImporter().stringUtils.price,
                            fieldType: TextInputType.number,
                            hint: "5000",
                            width: MediaQuery.of(context).size.width / 3),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _entryField(
                            controller: priceFactorController,
                            title: UtilsImporter().stringUtils.priceFactor,
                            fieldType: TextInputType.number,
                            hint: "1",
                            width: MediaQuery.of(context).size.width / 4),
                        SizedBox(
                          width: 110,
                          // height: 100,
                          child: Container(
                            margin: const EdgeInsets.all(15.0),
                            padding: const EdgeInsets.all(3.0),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(
                                        10.0) //                 <--- border radius here
                                    ),
                                border: Border.all(
                                    color:
                                        UtilsImporter().colorUtils.primaryColor,
                                    width: 2)),
                            child: Switch(
                              value: switchController,
                              onChanged: (value) {
                                setState(() {
                                  switchController = value;
                                });
                              },
                              activeTrackColor:
                                  UtilsImporter().colorUtils.kmColors2,
                              activeColor: UtilsImporter().colorUtils.kmColors,
                            ),
                          ),
                        ),
                      ],
                    ),
                    KammunButton(
                        text: UtilsImporter().stringUtils.save,
                        height: 50,
                        color: completeData()
                            ? UtilsImporter().colorUtils.kmColors
                            : UtilsImporter().colorUtils.searchGreyColor,
                        onTap: () async {
                          if (completeData()) {
                            bool result = await _addNewProduct();

                            if (result) {
                              int count = 0;
                              Navigator.of(context)
                                  .popUntil((_) => count++ >= 1);
                            }
                            Services.resultFlushBar(
                                context: context, result: result);
                          } else {
                            Toast.show("يرجى إدخال كافة البيانات", context,
                                duration: Toast.LENGTH_LONG,
                                gravity: Toast.CENTER);
                          }
                        }),
                  ],
                ),
        ),
      ),
    );
  }

  bool completeData() {
    return _selectedValue != -1 &&
        priceFactorController.text.isNotEmpty &&
        supplierCodeController.text.isNotEmpty &&
        priceController.text.isNotEmpty;
  }
}
