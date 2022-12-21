import 'package:kammun_app/features/products_attached_to_warehouse/services/added_products_services.dart';

import '../../../core/core_importer.dart';

class AddProductsToSubWarehouse extends StatefulWidget {
  final ProductData product;
  final int barcode;

  const AddProductsToSubWarehouse({Key key, this.product, this.barcode}) : super(key: key);

  @override
  _AddProductsToSubWarehouseState createState() => _AddProductsToSubWarehouseState();
}

class _AddProductsToSubWarehouseState extends State<AddProductsToSubWarehouse> {
  int _selectedValue = -1;

  bool isLoading = false;
  bool isError = false;

  Future<bool> attachProduct(int barcode, BuildContext context) async {
    setState(() {
      isLoading = true;
      isError = false;
    });
    dynamic body = {
      'product_id': widget.product.id.toString(),
      'sub_warehouse_id': _selectedValue.toString(),
      'price': priceController.text ?? '0',
      'is_featured': '0',
      'is_active': switchController ? '1' : '0',
      'priority': '100',
      'supplier_code': supplierCodeController.text,
      'min_threshold': '0',
      'increase_percentage': '0',
      'price_factor': priceFactorController.text ?? '1',
      'automatic_activation': '0',
      'barcode': barcode,
    };

    bool response = await AddedProductsServices.attachProductsToSubWarehouseService(fullRequestBody: body);
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 210, 178, 2),
        automaticallyImplyLeading: false,
        flexibleSpace: SafeArea(
          child: Column(
            children: <Widget>[
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Opacity(opacity: 0.0, child: Icon(Icons.home, color: Colors.white, size: 40)),
                    Padding(
                      padding: const EdgeInsets.only(top: 5.0),
                      child: Transform.scale(
                        scale: 2,
                        child: InkWell(
                          onTap: () => Navigator.pushNamedAndRemoveUntil(
                              context, StoreView.routeName, (Route<dynamic> route) => false),
                          child: Image.asset('assets/logobw.png', width: 150, height: 50),
                        ),
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.only(top: 5.0, left: 0),
                        child: IconButton(
                            onPressed: () => Navigator.of(context).pop(true),
                            icon: const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 40))),
                  ]),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 25.0, bottom: 8, left: 8, right: 8),
          child: isLoading
              ? const Center(child: Loader())
              : ListView(
                  shrinkWrap: true,
                  children: [
                    Text(
                      'يرجى إختيار المستودع التابع لهذه المادة',
                      style: TextStyle(fontFamily: fontFamily, fontWeight: FontWeight.bold),
                    ),
                    ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 0.0),
                      title: Column(
                        children: LoadingScreenServices.subWarehouses
                            .map((data) => Container(
                                  decoration: const BoxDecoration(color: Colors.white),
                                  child: RadioListTile(
                                    controlAffinity: ListTileControlAffinity.trailing,
                                    activeColor: Theme.of(context).primaryColor,
                                    title: Text(data.name, style: TextStyle(fontFamily: fontFamily)),
                                    groupValue: _selectedValue,
                                    value: data.id,
                                    onChanged: (val) => setState(() => _selectedValue = data.id),
                                  ),
                                ))
                            .toList(),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ProductEntryField(
                            controller: supplierCodeController,
                            title: supplierCodeString,
                            hint: '123456',
                            width: MediaQuery.of(context).size.width / 3),
                        ProductEntryField(
                            controller: priceController,
                            title: priceString,
                            hint: '5000',
                            width: MediaQuery.of(context).size.width / 3),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ProductEntryField(
                            controller: priceFactorController,
                            title: priceFactor,
                            hint: '1',
                            width: MediaQuery.of(context).size.width / 4),
                        SizedBox(
                          width: 110,
                          child: Container(
                            margin: const EdgeInsets.all(15.0),
                            padding: const EdgeInsets.all(3.0),
                            decoration: BoxDecoration(
                                borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                                border: Border.all(color: primaryColor, width: 2)),
                            child: Switch(
                              value: switchController,
                              onChanged: (value) => setState(() => switchController = value),
                              activeTrackColor: kmColors2,
                              activeColor: kmColors,
                            ),
                          ),
                        ),
                      ],
                    ),
                    KammunButton(
                      text: save,
                      height: 50,
                      color: completeData() ? kmColors : searchGreyColor,
                      onTap: () async {
                        if (completeData()) {
                          bool result = await attachProduct(widget.barcode, context);
                          if (result) {
                            int count = 0;
                            Navigator.of(context).popUntil((_) => count++ >= 1);
                            snackBar(success: result, message: 'تم ربط المنتج بالمستودع بنجاح', context: context);
                          } else {
                            snackBar(
                                success: result,
                                message: 'فشلت عملية ربط المنتج بالمستودع يرجى المحاولة مجدداً',
                                context: context);
                          }
                        } else {
                          Toast.show('يرجى إدخال كافة البيانات', context,
                              duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
                        }
                      },
                    ),
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
