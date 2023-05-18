import 'package:image_picker/image_picker.dart';
import 'package:kammun_app/features/products_view/services/products_services.dart';
import 'package:kammun_app/features/products_view/widgets/select_file.dart';

import '../../../core/core_importer.dart';

class AddProductsView extends StatefulWidget {
  final String categoryId;
  final String supplierCode;
  final int barcode;

  const AddProductsView({Key key, @required this.categoryId, this.barcode, this.supplierCode}) : super(key: key);

  @override
  _AddProductsViewState createState() => _AddProductsViewState();
}

class _AddProductsViewState extends State<AddProductsView> {
  File _image;

  int _selectedSubWarehouseValue = -1;
  final picker = ImagePicker();
  List<String> productData = [
    'المستودع',
    'اسم المنتج',
    quantityString,
    unitString,
    priceFactor,
    descriptionString,
    supplierCodeString,
    priceString,
    'الصورة'
  ];

  Future getImageCamera() async {
    final pickedFile =
        await picker.pickImage(source: ImageSource.camera, imageQuality: 100, maxHeight: 600, maxWidth: 500);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  Future getImageGallery() async {
    final pickedFile =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 100, maxHeight: 600, maxWidth: 500);
    setState(() => {if (pickedFile != null) _image = File(pickedFile.path)});
  }

  Widget imagesBody() {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.only(top: 10),
      child: SelectedFileToUpload(image: _image, name: '', close: () => setState(() => _image = null)),
    );
  }

  bool isLoading = false;
  bool isError = false;

  void _addNewProduct({int barcode, BuildContext context}) async {
    setState(() => {isLoading = true, isError = false});
    int productIds = await ProductsServices.addNewProducts(
        subWarehouseId: _selectedSubWarehouseValue,
        name: nameController.text,
        quantity: quantityController.text,
        unit: unitController.text,
        price: int.parse(priceController.text),
        description: descriptionController.text,
        supplierCode: supplierCodeController.text,
        priceFactor: priceFactorController.text,
        categoryId: widget.categoryId,
        minThreshold: '0',
        autoActivation: autoActivationController,
        isActive: switchController ? 1 : 0,
        barcode: barcode);
    if (productIds != null && productIds != 0) {
      snackBar(success: true, message: 'تم إضافة المنتج بنجاح', context: context);
    } else {
      snackBar(success: false, message: 'فشلت عملية إضافة المنتج', context: context);
    }

    if (productIds != null && productIds != 0) {
      bool result = await ProductsServices.setImageToProducts(productId: productIds, image: _image);
      if (result) {
        setState(() => {isLoading = false, isError = false});

        Navigator.of(context).pop();
      } else {
        setState(() => {isLoading = false, isError = true});
        snackBar(success: false, message: 'فشلت عملية إضافة المنتج', context: context);
      }
    } else if (productIds == null) {
      snackBar(success: false, message: '!!!!! فشل في ربط المنتج ولكن تمت إضافته !!!', context: context);
    }
  }

  TextEditingController nameController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  TextEditingController unitController = TextEditingController();
  TextEditingController priceFactorController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController supplierCodeController = TextEditingController();
  TextEditingController priceController = TextEditingController();

  bool switchController = false;

  bool autoActivationController = true;

  @override
  void initState() {
    if (widget.supplierCode != null) supplierCodeController.text = widget.supplierCode;
    if (StaticVariables.productToAddName != 'null') nameController.text = StaticVariables.productToAddName;
    super.initState();
  }

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
                      icon: const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 40),
                    ),
                  ),
                ],
              ),
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
                    Text('يرجى إختيار المستودع التابع لهذه المادة', style: boldStyle),
                    ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 0.0),
                      title: Column(
                        children: StaticVariables.subWarehouses
                            .map((data) => Container(
                                  decoration: const BoxDecoration(color: Colors.white),
                                  child: RadioListTile(
                                    controlAffinity: ListTileControlAffinity.trailing,
                                    activeColor: Theme.of(context).primaryColor,
                                    title: Text(data.name, style: mainStyle),
                                    groupValue: _selectedSubWarehouseValue,
                                    value: data.id,
                                    onChanged: (val) => setState(() => _selectedSubWarehouseValue = data.id),
                                  ),
                                ))
                            .toList(),
                      ),
                    ),
                    ProductEntryField(controller: nameController, title: 'اسم المنتج', hint: 'زيت سولينا'),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ProductEntryField(
                            controller: quantityController,
                            title: quantityString,
                            hint: '100',
                            width: MediaQuery.of(context).size.width / 4),
                        ProductEntryField(
                            controller: unitController,
                            title: unitString,
                            hint: 'لتر',
                            width: MediaQuery.of(context).size.width / 4),
                        ProductEntryField(
                            controller: priceFactorController,
                            title: priceFactor,
                            hint: '1',
                            width: MediaQuery.of(context).size.width / 4),
                      ],
                    ),
                    ProductEntryField(
                        controller: descriptionController,
                        title: descriptionString,
                        hint: 'زيت دوار الشمس الصافي @كلمات مفتاحية'),
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
                        TextButton(child: Icon(Icons.camera, color: kmColors), onPressed: () => getImageCamera()),
                        TextButton(child: Icon(Icons.image, color: kmColors), onPressed: () => getImageGallery()),
                        SizedBox(
                          width: 110,
                          child: Container(
                            margin: const EdgeInsets.all(15.0),
                            padding: const EdgeInsets.all(3.0),
                            decoration: BoxDecoration(
                                borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                                border: Border.all(color: switchController ? kmColors2 : searchGreyColor, width: 2)),
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
                    Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                      Text('السماح بتفعيل المنتاج تلقائيا', style: boldStyle),
                      SizedBox(
                        width: 110,
                        child: Container(
                          margin: const EdgeInsets.all(15.0),
                          padding: const EdgeInsets.all(3.0),
                          decoration: BoxDecoration(
                              borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                              border:
                                  Border.all(color: autoActivationController ? kmColors2 : searchGreyColor, width: 2)),
                          child: Switch(
                            value: autoActivationController,
                            onChanged: (value) => setState(() => autoActivationController = value),
                            activeTrackColor: kmColors2,
                            activeColor: kmColors,
                          ),
                        ),
                      ),
                    ]),
                    _image != null ? imagesBody() : Container(),
                    KammunButton(
                      height: 50,
                      text: save,
                      color: toastList() == 0 ? kmColors2 : searchGreyColor,
                      onTap: () {
                        if (toastList() == 0) {
                          _addNewProduct(barcode: widget.barcode, context: context);
                        } else {
                          Toast.show(
                              'يرجى ادخال البيانات التالية:\n' +
                                  productData.toString().replaceAll(',', '\n').replaceAll('[', '').replaceAll(']', ''),
                              context,
                              duration: Toast.LENGTH_LONG,
                              gravity: Toast.CENTER);
                        }
                      },
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  int toastList() {
    if (_selectedSubWarehouseValue != -1) {
      if (productData.contains('المستودع')) productData.remove('المستودع');
    } else {
      if (!productData.contains('المستودع')) productData.add('المستودع');
    }
    if (nameController.text.isNotEmpty) {
      if (productData.contains('اسم المنتج')) productData.remove('اسم المنتج');
    } else {
      if (!productData.contains('اسم المنتج')) productData.add('اسم المنتج');
    }
    if (quantityController.text.isNotEmpty) {
      if (productData.contains(quantityString)) productData.remove(quantityString);
    } else {
      if (!productData.contains(quantityString)) productData.add(quantityString);
    }
    if (unitController.text.isNotEmpty) {
      if (productData.contains(unitString)) productData.remove(unitString);
    } else {
      if (!productData.contains(unitString)) productData.add(unitString);
    }
    if (priceFactorController.text.isNotEmpty) {
      if (productData.contains(priceFactor)) productData.remove(priceFactor);
    } else {
      if (!productData.contains(priceFactor)) productData.add(priceFactor);
    }
    if (descriptionController.text.isNotEmpty) {
      if (productData.contains(descriptionString)) productData.remove(descriptionString);
    } else {
      if (!productData.contains(descriptionString)) productData.add(descriptionString);
    }
    if (supplierCodeController.text.isNotEmpty) {
      if (productData.contains(supplierCodeString)) productData.remove(supplierCodeString);
    } else {
      if (!productData.contains(supplierCodeString)) productData.add(supplierCodeString);
    }
    if (priceController.text.isNotEmpty) {
      if (productData.contains(priceString)) productData.remove(priceString);
    } else {
      if (!productData.contains(priceString)) productData.add(priceString);
    }
    if (_image != null) {
      if (productData.contains('الصورة')) productData.remove('الصورة');
    } else {
      if (!productData.contains('الصورة')) productData.add('الصورة');
    }
    return productData.length;
  }
}
