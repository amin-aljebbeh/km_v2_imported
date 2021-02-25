import 'dart:io';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kammun_app/utils/Loader.dart';
import 'package:kammun_app/utils/kammun_button.dart';
import 'package:kammun_app/utils/tools.dart';
import 'package:kammun_app/utils/utils_importer.dart';
import 'package:kammun_app/views/products_view/select_file.dart';
import 'package:kammun_app/views/products_view/services/products_services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

class AddProductsView extends StatefulWidget {
  final String categoryId;
  AddProductsView({@required this.categoryId});
  @override
  _AddProductsViewState createState() => _AddProductsViewState();
}

class _AddProductsViewState extends State<AddProductsView> {
  File _image;
  // File _uploadedFile;

  final picker = ImagePicker();

  Future getImageCamera() async {
    final pickedFile = await picker.getImage(
        source: ImageSource.camera,
        imageQuality: 80,
        maxHeight: 350,
        maxWidth: 300);
    // File uploadedFile = await testCompressAndGetFile(File(pickedFile.path));
    Tools.logToConsole("Image Path");
    // Tools.logToConsole(File(pickedFile.path));
    // Tools.logToConsole("Compressed Image Path");
    // Tools.logToConsole(uploadedFile);
    // Tools.logToConsole(uploadedFile.path);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        // _uploadedFile = uploadedFile;
      } else {
        print('No image selected.');
      }
    });
  }

  Future getImageGalery() async {
    final pickedFile = await picker.getImage(
        source: ImageSource.gallery,
        imageQuality: 80,
        maxHeight: 350,
        maxWidth: 300);
    // File uploadedFile = await testCompressAndGetFile(File(pickedFile.path));
    Tools.logToConsole("Image Path");
    // Tools.logToConsole(File(pickedFile.path));
    // Tools.logToConsole("Compressed Image Path");
    // Tools.logToConsole(uploadedFile);
    // Tools.logToConsole(uploadedFile.path);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        // _uploadedFile = uploadedFile;
      } else {
        print('No image selected.');
      }
    });
  }

  // Future<File> testCompressAndGetFile(File file) async {
  //   try {
  //     FlutterImageCompress.validator.ignoreCheckExtName = true;
  //     print("testCompressAndGetFile");
  //     final targetPath = file.absolute.path + "/compressedImage.jpg";
  //     final result = await FlutterImageCompress.compressAndGetFile(
  //       file.absolute.path,
  //       targetPath,
  //       quality: 90,
  //       minWidth: 1024,
  //       minHeight: 1024,
  //       rotate: 50,
  //     );
  //     Tools.logToConsole("Printing Compressed Path");
  //     print(file.path);
  //     return result;
  //   } catch (e) {
  //     Tools.logToConsole("Error in  Compressed");
  //     Tools.logToConsole(e.toString());
  //     return null;
  //   }
  // }

  Widget imagesBody() {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.only(top: 10),
      child: SelectedFileToUpload(
        image: _image,
        name: 'Product Image}',
        close: () {
          setState(() {
            _image = null;
            // _uploadedFile = null;
          });
        },
      ),
    );
  }

  Widget _entryField(
      {bool canBeEmpty = true,
      TextEditingController controller,
      String hint,
      @required String title,
      String subTitle,
      @required TextInputType fieldType,
      double height,
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
        Container(
            alignment: Alignment.centerLeft,
            width: width ?? MediaQuery.of(context).size.width,
            //height: height ?? 54.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.0),
              color: Colors.white,
              border: Border.all(width: 1.0, color: Colors.green[700]),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.16),
                    offset: Offset(0, 3.0),
                    blurRadius: 6.0),
              ],
            ),
            child: TextFormField(
              onChanged: (value) {
                setState(() {});
              },
              validator: (value) {
                RegExp regExp = new RegExp("^(?:9)?[0-9]{3}(?:-)[0-9]{9}\$");

                if (value.isEmpty && !canBeEmpty)
                  return "This field can not be empty";
                if (isPhoneNumber && !regExp.hasMatch(controller.text))
                  return "Please make sure you enter a 9-digit number (e.g. 5503394244)";
                else
                  return null;
              },
              controller: controller,
              keyboardType: fieldType,
              maxLines: isAddress ? null : 1,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: hint,
                hintStyle: TextStyle(
                  fontFamily: UtilsImporter().stringUtils.HKGrotesk,
                ),
                fillColor: Colors.white,
                filled: true,
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    borderSide: BorderSide(
                      color: Colors.white,
                      width: 3.0,
                    )),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4.0),
                    borderSide: BorderSide(
                      color: Color(0xFF999999),
                      width: 1.0,
                    )),
                /*errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4.0),
                    borderSide: BorderSide(
                      color: Colors.red,
                      width: 1.0,
                    )),*/
              ),
            )),
        SizedBox(height: 20),
      ],
    );
  }

  bool isLoading = false;
  bool isError = false;
  void _addNewProduct() async {
    setState(() {
      isLoading = true;
      isError = false;
    });
    int productIds = await ProductsServices.addNewProducts(
        name: nameController.text,
        quantity: quantityController.text,
        unit: unitController.text,
        price: priceController.text,
        description: descriptionController.text,
        supplierCode: supplierCodeController.text,
        priceFactor: priceController.text,
        categoryId: widget.categoryId,
        minThreshold: "0",
        isActive: switchController ? "1" : "0");

    if (productIds != 0) {
      bool result = await ProductsServices.setImageToProducts(
          productId: productIds, image: _image);
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
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontFamily: UtilsImporter().stringUtils.HKGrotesk),
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
          // leftBarIndicatorColor: UtilsImporter().colorUtils.kmColors,
        )..show(context);
      }
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
                    _entryField(
                        controller: nameController,
                        title: "اسم المنتج",
                        fieldType: TextInputType.name,
                        hint: "زيت سولينا"),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _entryField(
                            controller: quantityController,
                            title: "الكمية",
                            fieldType: TextInputType.number,
                            hint: "100",
                            width: MediaQuery.of(context).size.width / 4),
                        _entryField(
                            controller: unitController,
                            title: "الوحدة",
                            fieldType: TextInputType.name,
                            hint: "لتر",
                            width: MediaQuery.of(context).size.width / 4),
                        _entryField(
                            controller: priceFactorController,
                            title: "معدل الضرب",
                            fieldType: TextInputType.number,
                            hint: "1",
                            width: MediaQuery.of(context).size.width / 4),
                      ],
                    ),
                    _entryField(
                        controller: descriptionController,
                        title: "الوصف",
                        fieldType: TextInputType.name,
                        hint: "زيت دوار الشمس الصافي @كلمات مفتاحية"),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _entryField(
                            controller: supplierCodeController,
                            title: "رمز المادة ",
                            fieldType: TextInputType.name,
                            hint: "123456",
                            width: MediaQuery.of(context).size.width / 3),
                        _entryField(
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
                            color: UtilsImporter().colorUtils.kmColors,
                          ),
                          onPressed: () {
                            getImageCamera();
                          },
                        ),
                        FlatButton(
                          child: Icon(
                            Icons.image,
                            color: UtilsImporter().colorUtils.kmColors,
                          ),
                          onPressed: () {
                            getImageGalery();
                          },
                        ),
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
                                        UtilsImporter().colorUtils.primarycolor,
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
                    _image != null ? imagesBody() : Container(),
                    KammunButton(
                      text: "حفظ",
                      onPress: () {
                        _addNewProduct();
                      },
                    )
                  ],
                ),
        ),
      ),
    );
  }
}
