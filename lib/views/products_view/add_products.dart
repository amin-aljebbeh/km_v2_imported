import 'dart:io';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kammun_app/views/Wedgit/widgets_importer.dart';
import 'package:kammun_app/views/loading/LoadingServices.dart';
import 'package:kammun_app/views/products_view/select_file.dart';
import 'package:kammun_app/views/products_view/services/products_services.dart';
import 'package:kammun_app/utils/utils_importer.dart';

import '../../Services.dart';
import 'barcode_screen.dart';

class AddProductsView extends StatefulWidget {
  final String categoryId;

  AddProductsView({@required this.categoryId});

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
    'الكمية',
    'الوحدة',
    'معدل الضرب',
    'الوصف',
    'رمز المادة',
    'السعر',
    'الصورة'
  ];

  Future getImageCamera() async {
    final pickedFile =
        await picker.getImage(source: ImageSource.camera, imageQuality: 100, maxHeight: 600, maxWidth: 500);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future getImageGallery() async {
    final pickedFile =
        await picker.getImage(source: ImageSource.gallery, imageQuality: 100, maxHeight: 600, maxWidth: 500);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Widget imagesBody() {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.only(top: 10),
      child: SelectedFileToUpload(
        image: _image,
        name: '',
        close: () {
          setState(() {
            _image = null;
          });
        },
      ),
    );
  }

  bool isLoading = false;
  bool isError = false;

  void _addNewProduct({String barcode = '', BuildContext context}) async {
    setState(() {
      isLoading = true;
      isError = false;
    });
    int productIds = await ProductsServices.addNewProducts(
      subWarehouseId: _selectedSubWarehouseValue.toString(),
      name: nameController.text,
      quantity: quantityController.text,
      unit: unitController.text,
      price: priceController.text,
      description: descriptionController.text,
      supplierCode: supplierCodeController.text,
      priceFactor: priceFactorController.text,
      categoryId: widget.categoryId,
      minThreshold: "0",
      autoActivation: autoActivationController,
      isActive: switchController ? "1" : "0",
      barcode: barcode,
    );
    Services.resultFlushBar(context: context, result: productIds != null && productIds != 0);

    if (productIds != null && productIds != 0) {
      bool result = await ProductsServices.setImageToProducts(productId: productIds, image: _image);
      if (result) {
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
        Flushbar(
          backgroundColor: Colors.red[900],
          messageText: Text(
            "فشل في إضافة المنتج",
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontFamily: StringUtils.fontFamilyHKGrotesk),
          ),
          boxShadows: [
            BoxShadow(
              color: Colors.red,
              offset: Offset(0.0, 2.0),
              blurRadius: 3.0,
            )
          ],
          icon: Icon(
            Icons.close,
            size: 28.0,
            color: Colors.white,
          ),
          duration: Duration(seconds: 1),
        )..show(context);
      }
    } else if (productIds == null) {
      Flushbar(
        backgroundColor: Colors.red[900],
        messageText: Text(
          "!!!!! فشل في ربط المنتج ولكن تمت إضافته !!!",
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontFamily: StringUtils.fontFamilyHKGrotesk),
        ),
        boxShadows: [
          BoxShadow(
            color: Colors.purple,
            offset: Offset(0.0, 2.0),
            blurRadius: 3.0,
          )
        ],
        icon: Icon(
          Icons.close,
          size: 28.0,
          color: Colors.white,
        ),
        duration: Duration(seconds: 10),
        // leftBarIndicatorColor: ColorUtils.kmColors,
      )..show(context);
    }
  }

  final TextEditingController nameController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController unitController = TextEditingController();
  final TextEditingController priceFactorController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController supplierCodeController = TextEditingController();
  final TextEditingController priceController = TextEditingController();

  bool switchController = false;

  bool autoActivationController = true;

  @override
  void initState() {
    nameController.text = null;
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
                      ),
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
              ? Center(child: Loader())
              : ListView(
                  shrinkWrap: true,
                  children: [
                    Text(
                      "يرجى إختيار المستودع التابع لهذه المادة",
                      style: TextStyle(
                        fontFamily: StringUtils.fontFamilyHKGrotesk,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    ListTile(
                      contentPadding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 0.0),
                      title: Column(
                        children: LoadingScreenServices.subWarehouses
                            .map((data) => Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                  ),
                                  child: RadioListTile(
                                    controlAffinity: ListTileControlAffinity.trailing,
                                    activeColor: Theme.of(context).primaryColor,
                                    title: Text(
                                      "${data.name}",
                                      style: TextStyle(
                                        fontFamily: StringUtils.fontFamilyHKGrotesk,
                                      ),
                                    ),
                                    groupValue: _selectedSubWarehouseValue,
                                    value: data.id,
                                    onChanged: (val) {
                                      setState(() {
                                        _selectedSubWarehouseValue = data.id;
                                      });
                                    },
                                  ),
                                ))
                            .toList(),
                      ),
                    ),
                    ProductEntryField(
                        controller: nameController,
                        title: "اسم المنتج",
                        fieldType: TextInputType.name,
                        hint: "زيت سولينا"),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ProductEntryField(
                            controller: quantityController,
                            title: "الكمية",
                            fieldType: TextInputType.number,
                            hint: "100",
                            width: MediaQuery.of(context).size.width / 4),
                        ProductEntryField(
                            controller: unitController,
                            title: "الوحدة",
                            fieldType: TextInputType.name,
                            hint: "لتر",
                            width: MediaQuery.of(context).size.width / 4),
                        ProductEntryField(
                            controller: priceFactorController,
                            title: "معدل الضرب",
                            fieldType: TextInputType.text,
                            hint: "1",
                            width: MediaQuery.of(context).size.width / 4),
                      ],
                    ),
                    ProductEntryField(
                        controller: descriptionController,
                        title: "الوصف",
                        fieldType: TextInputType.multiline,
                        hint: "زيت دوار الشمس الصافي @كلمات مفتاحية"),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ProductEntryField(
                            controller: supplierCodeController,
                            title: "رمز المادة ",
                            fieldType: TextInputType.name,
                            hint: "123456",
                            width: MediaQuery.of(context).size.width / 3),
                        ProductEntryField(
                            controller: priceController,
                            title: "السعر",
                            fieldType: TextInputType.number,
                            hint: "5000",
                            width: MediaQuery.of(context).size.width / 3),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        FlatButton(
                          child: Icon(
                            Icons.camera,
                            color: ColorUtils.kmColors,
                          ),
                          onPressed: () {
                            getImageCamera();
                          },
                        ),
                        FlatButton(
                          child: Icon(
                            Icons.image,
                            color: ColorUtils.kmColors,
                          ),
                          onPressed: () {
                            getImageGallery();
                          },
                        ),
                        SizedBox(
                          width: 110,
                          // height: 100,
                          child: Container(
                            margin: const EdgeInsets.all(15.0),
                            padding: const EdgeInsets.all(3.0),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                    Radius.circular(10.0) //                 <--- border radius here
                                    ),
                                border: Border.all(
                                    color: switchController ? ColorUtils.kmColors2 : ColorUtils.searchGreyColor,
                                    width: 2)),
                            child: Switch(
                              value: switchController,
                              onChanged: (value) {
                                setState(() {
                                  switchController = value;
                                });
                              },
                              activeTrackColor: ColorUtils.kmColors2,
                              activeColor: ColorUtils.kmColors,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                      Text(
                        "السماح بتفعيل المنتاج تلقائيا",
                        style: TextStyle(fontFamily: StringUtils.fontFamilyHKGrotesk, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        width: 110,
                        // height: 100,
                        child: Container(
                          margin: const EdgeInsets.all(15.0),
                          padding: const EdgeInsets.all(3.0),
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0) //                 <--- border radius here
                                      ),
                              border: Border.all(
                                  color:
                                      autoActivationController ? ColorUtils.kmColors2 : ColorUtils.searchGreyColor,
                                  width: 2)),
                          child: Switch(
                            value: autoActivationController,
                            onChanged: (value) {
                              setState(() {
                                autoActivationController = value;
                              });
                            },
                            activeTrackColor: ColorUtils.kmColors2,
                            activeColor: ColorUtils.kmColors,
                          ),
                        ),
                      ),
                    ]),
                    _image != null ? imagesBody() : Container(),
                    KammunButton(
                      height: 50,
                      text: StringUtils.save,
                      color: toastList() == 0 ? ColorUtils.kmColors2 : ColorUtils.searchGreyColor,
                      onTap: () {
                        if (toastList() == 0) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BarCodeScreen(
                                requestType: BarcodeRequestType.addProduct,
                                onIgnore: (barcode) {
                                  _addNewProduct(barcode: barcode, context: context);
                                },
                              ),
                            ),
                          );
                        } else {
                          Toast.show(
                              "يرجى ادخال البيانات التالية:\n" +
                                  productData
                                      .toString()
                                      .replaceAll(',', '\n')
                                      .replaceAll('[', '')
                                      .replaceAll(']', ''),
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
      if (productData.contains('الكمية')) productData.remove('الكمية');
    } else {
      if (!productData.contains('الكمية')) productData.add('الكمية');
    }
    if (unitController.text.isNotEmpty) {
      if (productData.contains('الوحدة')) productData.remove('الوحدة');
    } else {
      if (!productData.contains('الوحدة')) productData.add('الوحدة');
    }
    if (priceFactorController.text.isNotEmpty) {
      if (productData.contains('معدل الضرب')) productData.remove('معدل الضرب');
    } else {
      if (!productData.contains('معدل الضرب')) productData.add('معدل الضرب');
    }
    if (descriptionController.text.isNotEmpty) {
      if (productData.contains('الوصف')) productData.remove('الوصف');
    } else {
      if (!productData.contains('الوصف')) productData.add('الوصف');
    }
    if (supplierCodeController.text.isNotEmpty) {
      if (productData.contains('رمز المادة')) productData.remove('رمز المادة');
    } else {
      if (!productData.contains('رمز المادة')) productData.add('رمز المادة');
    }
    if (priceController.text.isNotEmpty) {
      if (productData.contains('السعر')) productData.remove('السعر');
    } else {
      if (!productData.contains('السعر')) productData.add('السعر');
    }
    if (_image != null) {
      if (productData.contains('الصورة')) productData.remove('الصورة');
    } else {
      if (!productData.contains('الصورة')) productData.add('الصورة');
    }
    return productData.length;
  }

  bool controller() {
    return priceController.text.isEmpty;
  }
}
