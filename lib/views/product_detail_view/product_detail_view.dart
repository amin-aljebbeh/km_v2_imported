import 'dart:async';
import 'dart:io';
import 'package:adv_image_cache/adv_image_cache.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kammun_app/utils/Loader.dart';
import 'package:kammun_app/utils/Styles.dart';
import 'package:kammun_app/utils/kammun_button.dart';
import 'package:kammun_app/utils/tools.dart';
import 'package:kammun_app/models/productsCategoriesModel.dart';
import 'package:kammun_app/utils/updatePriceWidget.dart';
import 'package:kammun_app/utils/utils_importer.dart';
import 'package:kammun_app/views/Wedgit/decision_button.dart';
import 'package:kammun_app/views/cart/services/cart_services.dart';
import 'package:kammun_app/views/loading/Loading.dart';
import 'package:kammun_app/views/loading/LoadingServices.dart';
import 'package:kammun_app/views/login/login_view.dart';
import 'package:kammun_app/views/prices_changes/services/prices_changes_services.dart';
import 'package:kammun_app/views/products_view/select_file.dart';
import 'package:kammun_app/views/products_view/services/products_services.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Services.dart';
import 'package:full_screen_image/full_screen_image.dart';

class ProductDetailView extends StatefulWidget {
  ProductData products;
  bool isFromFavoriteScreen;

  ProductDetailView({this.products, @required this.isFromFavoriteScreen});

  @override
  State<StatefulWidget> createState() {
    return ProductDetailViewState();
  }
}

class ProductDetailViewState extends State<ProductDetailView>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Animation _animation;
  bool done = false;

  final _controller = ScrollController(initialScrollOffset: 0.0);
  final _height = 100.0;

  int numberOfOrders = 1;
  int price = 0;
  bool productOnFavorites = false;

  @override
  void initState() {
    super.initState();

    // selectedValueCategoryValue = LoadingScreenServices.fullCategoryList.firstWhere((element) => element.value == widget.products.categoryId));

    // selectedValueCategoryValue = LoadingScreenServices.fullCategoryList
    //     .firstWhere((element) =>
    //         element.value.toString() == widget.products.categoryId.toString())
    //     .value
    //     .toString();
    Timer(Duration(milliseconds: 100), () => _animateToIndex(2.5));

    _animationController = new AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _animation = Tween(begin: 1.5, end: 0.0).animate(_animationController);

    //  CurvedAnimation(parent: _animationController, curve: Curves.easeIn);
    _animationController.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  _animateToIndex(i) async {
    await _controller.animateTo(
      _height * i,
      duration: Duration(milliseconds: 1500),
      curve: Curves.easeInOut,
    );
    setState(() {
      done = true;
    });
  }

  // curve: Curves.linear, duration: Duration(milliseconds: 500));

  File _image;

  // File _uploadedFile;

  final picker = ImagePicker();

  bool isLoading = false;
  bool isError = false;

  Future getImageCamera() async {
    final pickedFile = await picker.getImage(
        source: ImageSource.camera,
        imageQuality: 100,
        maxHeight: 600,
        maxWidth: 500);
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

  Future getImageGallery() async {
    final pickedFile = await picker.getImage(
        source: ImageSource.gallery,
        imageQuality: 100,
        maxHeight: 600,
        maxWidth: 500);
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

  _getImage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        FlatButton(
          child: Icon(
            Icons.camera,
            color: UtilsImporter().colorUtils.kmColors,
            size: 40,
          ),
          onPressed: () {
            getImageCamera();
          },
        ),
        FlatButton(
          child: Icon(
            Icons.image,
            color: UtilsImporter().colorUtils.kmColors,
            size: 40,
          ),
          onPressed: () {
            getImageGallery();
          },
        ),
      ],
    );
  }

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

  String selectedValueCategoryValue;

  @override
  Widget build(BuildContext context) {
    // Tools.logToConsole("------ the image length --------");
    // Tools.logToConsole(widget.products.images.length);
    return SafeArea(
      top: true,
      left: false,
      right: false,
      bottom: true,
      child: Scaffold(
        //backgroundColor: UtilsImporter().colorUtils.primarycolor,
        backgroundColor: Theme.of(context).primaryColorLight,
        body: NestedScrollView(
          controller: _controller,
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                automaticallyImplyLeading: false,
                leading: IconButton(
                  iconSize: 35,
                  icon: const Icon(Icons.home),
                  tooltip: 'Back to Store Page',
                  onPressed: () => Navigator.of(context)
                      .pushNamedAndRemoveUntil(
                          '/home', (Route<dynamic> route) => false),
                ),
                actions: <Widget>[
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    icon: Icon(
                      Icons.arrow_forward_ios,
                      size: 35,
                    ),
                  ),
                ],
                backgroundColor: UtilsImporter().colorUtils.primarycolor,
                expandedHeight: 300.0,
                floating: false,
                pinned: true,
                title: Container(
                  alignment: Alignment.bottomCenter,
                  //padding: EdgeInsets.only(top: 15),
                  //   width: MediaQuery.of(context).size.width * 0.65,
                  child: done
                      ? AutoSizeText(
                          widget.products.name,
                          maxLines: 1,
                          style: mainStyle,
                        )
                      : Container(),
                ),
                flexibleSpace: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: FlexibleSpaceBar(
                    centerTitle: true,
                    background: !done
                        ? FullScreenWidget(
                            backgroundColor: Colors.white,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: FadeTransition(
                                opacity: _animation,
                                child: widget.products.images.length > 0
                                    ? Image(
                                        image: AdvImageCache(
                                          LoadingScreenServices.imagePrefixUrl +
                                              widget.products.images[0]
                                                  .imageFileName,
                                          useMemCache: true,
                                          diskCacheExpire: Duration(days: 400),
                                        ),
                                        width:
                                            MediaQuery.of(context).size.width /
                                                2,
                                        height: 120,
                                        fit: BoxFit.contain,
                                      )
                                    : Image.asset(
                                        "assets/logobw.png",
                                      ),
                              ),
                            ),
                          )
                        : widget.products.images.length > 0
                            ? FullScreenWidget(
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(16),
                                    child: Image(
                                      image: AdvImageCache(
                                        LoadingScreenServices.imagePrefixUrl +
                                            widget.products.images[0]
                                                .imageFileName,
                                        useMemCache: true,
                                        diskCacheExpire: Duration(days: 400),
                                      ),
                                      width:
                                          MediaQuery.of(context).size.width / 2,
                                      height: 120,
                                      fit: BoxFit.contain,
                                    )),
                              )
                            : Image.asset(
                                "assets/logobw.png",
                              ),
                  ),
                ),
              ),
            ];
          },
          body: SafeArea(
            top: false,
            child: Padding(
                padding: EdgeInsets.only(left: 20, right: 20, top: 25),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(20.0),
                          topLeft: Radius.circular(20.0))),
                  child: ListView(
                    // mainAxisAlignment: MainAxisAlignment.start,
                    shrinkWrap: true,
                    children: <Widget>[
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            widget.products.name,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: UtilsImporter().colorUtils.primarycolor,
                              fontFamily: UtilsImporter().stringUtils.HKGrotesk,
                              fontSize: 25,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Text("الكمية:", style: paragraphStyle),
                                SizedBox(width: 5),
                                Text(
                                  widget.products.unit.toString() != "null"
                                      ? widget.products.quantity.toString() +
                                          " " +
                                          widget.products.unit.toString()
                                      : widget.products.quantity.toString(),
                                  style: informationStyle,
                                ),
                              ],
                            ),
                            SizedBox(height: 5),
                            Row(
                              // crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Text("السعر: ", style: paragraphStyle),
                                SizedBox(width: 5),
                                Text(
                                    "${UtilsImporter().stringUtils.oCcy.format(int.parse(widget.products.price.toString().split(".")[0]))} ${LoadingScreenServices.companyInformation.currency}",
                                    style: informationStyle),
                              ],
                            ),
                            SizedBox(height: 5),
                            Row(
                              children: [
                                Text(
                                  "الوصف:",
                                  style: paragraphStyle,
                                ),
                                SizedBox(width: 5),
                                widget.products.description != null
                                    ? Text(
                                        widget.products.description != null
                                            ? widget.products.description
                                                .split("@")[0]
                                            : "",
                                        style: informationStyle,
                                      )
                                    : Container(),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 8.0, right: 8.0),
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  if (numberOfOrders > 1) {
                                    numberOfOrders = numberOfOrders - 1;
                                  }
                                });
                              },
                              child: Image.asset(
                                "assets/remove.png",
                                width: 60,
                                height: 60,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(numberOfOrders.toString(),
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                    fontFamily:
                                        UtilsImporter().stringUtils.HKGrotesk,
                                    fontSize: 35)),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 8.0, right: 8.0),
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  numberOfOrders = numberOfOrders + 1;
                                });
                              },
                              child: Image.asset(
                                "assets/add.png",
                                width: 60,
                                height: 60,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 30),
                      int.parse(widget.products.isActive) == 0
                          ? Container(
                              height: 50,
                              width: MediaQuery.of(context).size.width,
                              padding: const EdgeInsets.all(3.0),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(
                                          10.0) //                 <--- border radius here
                                      ),
                                  border: Border.all(
                                      color: UtilsImporter()
                                          .colorUtils
                                          .primarycolor,
                                      width: 4)),
                              child: Center(
                                  child: Text(
                                "المنتج نفذ من المستودعات",
                                style: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                    fontFamily:
                                        UtilsImporter().stringUtils.HKGrotesk),
                              )),
                            )
                          : Container(),
                      DecisionButton(
                        text:
                            'الإضافة لسلة المشتريات  ( ${UtilsImporter().stringUtils.oCcy.format(numberOfOrders * int.parse(widget.products.price.toString().split(".")[0]))})',
                        height: 50,
                        color: Theme.of(context).primaryColor,
                        onTap: () async {
                          String productsId = "";
                          String productsQuantity = "";
                          if (LoadingScreen.userToken.length > 5) {
                            Navigator.of(context).pop(true);

                            Tools.logToConsole(
                                "========= product price ========");

                            Tools.logToConsole(widget.products.price);
                            widget.products.productCount = numberOfOrders;

                            CartServices.addProductToCart(widget.products);
                            Flushbar(
                              backgroundColor: Colors.green,
                              messageText: Text(
                                "تم إضافة ${widget.products.name} لسلة المشتريات",
                                style: flushBarStyle,
                              ),
                              boxShadows: [
                                BoxShadow(
                                  color:
                                      UtilsImporter().colorUtils.primarycolor,
                                  offset: Offset(0.0, 2.0),
                                  blurRadius: 3.0,
                                )
                              ],
                              icon: Icon(
                                Icons.assignment_turned_in,
                                size: 28.0,
                                color: Colors.white,
                              ),
                              duration: Duration(seconds: 3),
                              leftBarIndicatorColor:
                                  UtilsImporter().colorUtils.kmColors,
                            )..show(context);

                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            for (int i = 0;
                                i < CartServices.cartProducts.length;
                                i++) {
                              productsId +=
                                  CartServices.cartProducts[i].id.toString() +
                                      ";";
                              productsQuantity += CartServices
                                      .cartProducts[i].productCount
                                      .toString() +
                                  ";";
                            }
                            prefs.setString("userCart",
                                productsId + "@" + productsQuantity);
                          } else {
                            Navigator.of(context)
                                .pushNamed(LoginScreen.routeName);
                          }
                        },
                      ),
                      (widget.products.supplierCode != null &&
                                  LoadingScreenServices.subSupplierCodeHint
                                      .hasMatch(
                                          widget.products.supplierCode)) ||
                              Services.isAdmin()
                          ? Column(
                              children: [
                                SizedBox(height: 30),
                                UpdatePriceWidget(
                                  title: "تعديل السعر",
                                  inputType: TextInputType.number,
                                  bodyKey: "price",
                                  productId: widget.products.id,
                                  productData: widget.products,
                                  textHint: widget.products.price,
                                  initialText: widget.products.price,
                                ),
                                SizedBox(height: 30),
                                UpdatePriceWidget(
                                  title: "تعديل رمز المادة",
                                  inputType: TextInputType.text,
                                  textHint: widget.products.supplierCode,
                                  initialText: widget.products.supplierCode,
                                  bodyKey: "supplier_code",
                                  productId: widget.products.id,
                                  productData: widget.products,
                                ),
                                SizedBox(height: 30),
                                UpdatePriceWidget(
                                  title: "معدل الضرب",
                                  inputType: TextInputType.number,
                                  bodyKey: "price_factor",
                                  productId: widget.products.id,
                                  productData: widget.products,
                                  textHint: widget.products.priceFactor,
                                  initialText: widget.products.priceFactor,
                                ),
                                SizedBox(height: 30),
                                UpdatePriceWidget(
                                  title: "تعديل الاسم",
                                  textHint: widget.products.name,
                                  inputType: TextInputType.text,
                                  bodyKey: "name",
                                  productId: widget.products.id,
                                  initialText: widget.products.name,
                                  isForSubWarehouse: false,
                                  productData: widget.products,
                                ),
                                SizedBox(height: 30),
                                UpdatePriceWidget(
                                  title: "تعديل الوحدة",
                                  inputType: TextInputType.text,
                                  bodyKey: "unit",
                                  productId: widget.products.id,
                                  isForSubWarehouse: false,
                                  productData: widget.products,
                                  textHint: widget.products.unit,
                                  initialText: widget.products.unit,
                                ),
                                SizedBox(height: 30),
                                UpdatePriceWidget(
                                  title: "تعديل الكمية",
                                  isForSubWarehouse: false,
                                  inputType: TextInputType.text,
                                  productData: widget.products,
                                  textHint: widget.products.quantity,
                                  bodyKey: "quantity",
                                  productId: widget.products.id,
                                  initialText: widget.products.quantity,
                                ),
                                SizedBox(height: 30),
                                UpdatePriceWidget(
                                  title: "تعديل الوصف",
                                  textHint: "الوصف الجديد",
                                  inputType: TextInputType.text,
                                  bodyKey: "description",
                                  productId: widget.products.id,
                                  isForSubWarehouse: false,
                                  productData: widget.products,
                                  initialText: widget.products.description,
                                ),
                                SizedBox(height: 30),
                                UpdatePriceWidget(
                                  title: "تعديل الأولوية",
                                  textHint: widget.products.priority.toString(),
                                  inputType: TextInputType.text,
                                  bodyKey: "priority",
                                  productId: widget.products.id,
                                  isForSubWarehouse: true,
                                  productData: widget.products,
                                  initialText:
                                      widget.products.priority.toString(),
                                ),
                                SizedBox(height: 30),
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  padding: EdgeInsets.only(left: 5, right: 5),
                                  decoration: BoxDecoration(
                                    color: UtilsImporter().colorUtils.greycolor,
                                    borderRadius: BorderRadius.circular(6),
                                    border: Border.all(
                                        width: 5,
                                        color: UtilsImporter()
                                            .colorUtils
                                            .greycolor),
                                  ),
                                  child: Center(
                                    child: new SearchableDropdown(
                                      isCaseSensitiveSearch: false,
                                      underline: Container(),
                                      isExpanded: false,
                                      items: LoadingScreenServices
                                          .fullCategoryList,
                                      iconEnabledColor: Colors.white,
                                      value: selectedValueCategoryValue,
                                      hint: new Text(
                                        'اختيار الصنف التابع له المنتج',
                                        style: decisionButtonStyle,
                                      ),
                                      searchHint: new Text(
                                        'إختيار الصنف',
                                        style: new TextStyle(
                                            fontSize: 20,
                                            fontFamily: UtilsImporter()
                                                .stringUtils
                                                .HKGrotesk),
                                      ),
                                      onChanged: (value) {
                                        setState(() {
                                          selectedValueCategoryValue =
                                              value.toString().split(";")[1];
                                          Tools.logToConsole(
                                              selectedValueCategoryValue);
                                        });
                                      },
                                    ),
                                  ),
                                ),
                                widget.products.images.length > 0
                                    ? DecisionButton(
                                        height: 50,
                                        color: Theme.of(context).primaryColor,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Text(
                                              "حذف الصورة",
                                              overflow: TextOverflow.clip,
                                              style: decisionButtonStyle,
                                            ),
                                            Icon(
                                              Icons.delete,
                                              color: Colors.white,
                                              size: 30,
                                            ),
                                          ],
                                        ),
                                        onTap: () async {
                                          bool response =
                                              await PricesChangesSerives
                                                  .deleteImage(
                                                      imageId:
                                                          widget.products.id);
                                          if (response) {
                                            Flushbar(
                                              backgroundColor: Colors.green,
                                              // titleText: Text("تمت الإضافة بنجاح"),
                                              messageText: Text(
                                                "تم حذف الصورة بنجاح",
                                                style: flushBarStyle,
                                              ),

                                              boxShadows: [
                                                BoxShadow(
                                                  color: UtilsImporter()
                                                      .colorUtils
                                                      .primarycolor,
                                                  offset: Offset(0.0, 2.0),
                                                  blurRadius: 3.0,
                                                )
                                              ],
                                              icon: Icon(
                                                Icons.assignment_turned_in,
                                                size: 28.0,
                                                color: Colors.white,
                                              ),
                                              duration: Duration(seconds: 2),
                                              leftBarIndicatorColor:
                                                  UtilsImporter()
                                                      .colorUtils
                                                      .kmColors,
                                            )..show(context);
                                          } else {
                                            Flushbar(
                                              backgroundColor: Colors.red[900],
                                              messageText: Text(
                                                "فشل بعملية حذف الصورة",
                                                style: flushBarStyle,
                                              ),
                                              boxShadows: [
                                                BoxShadow(
                                                  color: Colors.red,
                                                  offset: Offset(0.0, 2.0),
                                                  blurRadius: 3.0,
                                                )
                                              ],
                                              icon: Icon(
                                                Icons.error,
                                                size: 28.0,
                                                color: Colors.white,
                                              ),
                                              duration: Duration(seconds: 3),
                                              // leftBarIndicatorColor: UtilsImporter().colorUtils.kmColors,
                                            )..show(context);
                                          }
                                        },
                                      )
                                    : Container(),
                                DecisionButton(
                                  height: 50,
                                  text: "الإضافة لصنف جديد",
                                  color: Theme.of(context).primaryColor,
                                  onTap: () => _saveCategoryButton(
                                      categoryId: selectedValueCategoryValue,
                                      context: context,
                                      productId: widget.products.id),
                                ),
                                _getImage(),
                                _image != null ? imagesBody() : Container(),
                                isLoading
                                    ? Loader()
                                    : _image != null
                                        ? KammunButton(
                                            text: "حفظ الصورة",
                                            onPress: () async {
                                              setState(() {
                                                isLoading = true;
                                              });
                                              bool result =
                                                  await ProductsServices
                                                      .setImageToProducts(
                                                          productId: widget
                                                              .products.id,
                                                          image: _image);
                                              if (result) {
                                                setState(() {
                                                  isLoading = false;
                                                });
                                                Flushbar(
                                                  backgroundColor:
                                                      Colors.green[900],
                                                  messageText: Text(
                                                    "تم إضافة صورة بنجاح",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontFamily:
                                                            UtilsImporter()
                                                                .stringUtils
                                                                .HKGrotesk),
                                                  ),
                                                  boxShadows: [
                                                    BoxShadow(
                                                      color: Colors.green,
                                                      offset: Offset(0.0, 2.0),
                                                      blurRadius: 3.0,
                                                    )
                                                  ],
                                                  icon: Icon(
                                                    Icons.assignment_turned_in,
                                                    size: 28.0,
                                                    color: Colors.white,
                                                  ),
                                                  duration:
                                                      Duration(seconds: 1),
                                                  // leftBarIndicatorColor: UtilsImporter().colorUtils.kmColors,
                                                )..show(context);
                                              } else {
                                                setState(() {
                                                  isLoading = false;
                                                });
                                                Flushbar(
                                                  backgroundColor:
                                                      Colors.red[900],
                                                  messageText: Text(
                                                    "فشل في إضافة المنتج",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontFamily:
                                                            UtilsImporter()
                                                                .stringUtils
                                                                .HKGrotesk),
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
                                                  duration:
                                                      Duration(seconds: 1),
                                                  // leftBarIndicatorColor: UtilsImporter().colorUtils.kmColors,
                                                )..show(context);
                                              }
                                            },
                                          )
                                        : Container(),
                                SizedBox(height: 30),
                              ],
                            )
                          : Container(),
                    ],
                  ),
                )

                // Builder(builder: (context) => _showAddToFavorait(context)),

                ),
          ),
        ),
      ),
    );
  }

  Widget _showAddToFavorait(BuildContext ctx) {
    final GestureDetector addAddToOrderButtonWithGesture = new GestureDetector(
      onTap: () {
        _addToFavoriteBtnTapped(ctx);
        if (LoadingScreenServices.userFavoriteProducts
            .any((productId) => productId.id == widget.products.id)) {
          Flushbar(
            backgroundColor: Colors.red[900],
            messageText: Text(
              " تم إضافة ${widget.products.name}  إلى المفضلة",
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
              Icons.favorite,
              size: 28.0,
              color: Colors.white,
            ),
            duration: Duration(seconds: 3),
            // leftBarIndicatorColor: UtilsImporter().colorUtils.kmColors,
          )..show(context);
        } else {
          Flushbar(
            backgroundColor: Colors.red[900],
            messageText: Text(
              "تم إزالة ${widget.products.name}  من المفضلة",
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
              Icons.favorite,
              size: 28.0,
              color: Colors.white,
            ),
            duration: Duration(seconds: 3),
            // leftBarIndicatorColor: UtilsImporter().colorUtils.kmColors,
          )..show(context);
        }
      },
      child: Container(
        height: 50.0,
        decoration: BoxDecoration(
            color: Colors.red[800],
            borderRadius: BorderRadius.all(Radius.circular(6.0))),
        child: Center(
          child: Text(
            LoadingScreenServices.userFavoriteProducts
                        .where(
                          (productId) => productId.id == widget.products.id,
                        )
                        .length ==
                    1
                ? 'الإزالة من المفضلة'
                : 'الإضافة إلى المفضلة',
            style: TextStyle(
                color: Colors.white,
                fontSize: 17.0,
                fontWeight: FontWeight.w500,
                fontFamily: UtilsImporter().stringUtils.HKGrotesk),
          ),
        ),
      ),
    );

    return Padding(
        padding:
            EdgeInsets.only(left: 0.0, right: 0.0, top: 10.0, bottom: 20.0),
        child: addAddToOrderButtonWithGesture);
  }

  void _addToFavoriteBtnTapped(context) {
    // Scaffold.of(context).showSnackBar(SnackBar(
    //   content: Text("Item Addes"),
    // ));
    if (LoadingScreen.userToken.length > 5) {
      LoadingScreenServices.userFavoriteProducts
                  .where(
                    (productId) => productId.id == widget.products.id,
                  )
                  .length ==
              0
          ? _addFavorite(context, widget.products)
          : _removeFavoraite();
      if (widget.isFromFavoriteScreen) {
        Navigator.of(context).pushNamedAndRemoveUntil(
            '/favoraites', (Route<dynamic> route) => false);
      } else {
        Navigator.of(context).pop();
      }
    } else {
      Navigator.pushNamed(context, LoginScreen.routeName);
    }
  }

  void _addFavorite(BuildContext ctx, ProductData product) {
    Services.addToFavorites(widget.products.id.toString());
    LoadingScreenServices.userFavoriteProducts.add(product);

    Tools.logToConsole("im in add to favoraitses");
    // Navigator.of(context).pop();
  }

  void _removeFavoraite() {
    for (int i = 0; i < LoadingScreenServices.userFavoriteProducts.length; i++)
      if (LoadingScreenServices.userFavoriteProducts[i].id ==
          widget.products.id)
        LoadingScreenServices.userFavoriteProducts.removeAt(i);

    Services.removeFromFavorites(widget.products.id.toString());

    // Toast.show("تم إزالة ${widget.products.name}  من المفضلة", context,
    //     duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
  }
}

_saveCategoryButton(
    {BuildContext context, int productId, String categoryId}) async {
  bool result = await ProductsServices.updateProductsDetails(
      bodyKey: "category_id",
      value: categoryId,
      productId: productId.toString());

  if (result) {
    Flushbar(
      backgroundColor: Colors.green,
      // titleText: Text("تمت الإضافة بنجاح"),
      messageText: Text(
        "تم التعديل بنجاح",
        style: flushBarStyle,
      ),

      boxShadows: [
        BoxShadow(
          color: UtilsImporter().colorUtils.primarycolor,
          offset: Offset(0.0, 2.0),
          blurRadius: 3.0,
        )
      ],
      icon: Icon(
        Icons.assignment_turned_in,
        size: 28.0,
        color: Colors.white,
      ),
      duration: Duration(seconds: 1),
      leftBarIndicatorColor: UtilsImporter().colorUtils.kmColors,
    )..show(context);
  } else {
    Flushbar(
      backgroundColor: Colors.red,
      // titleText: Text("تمت الإضافة بنجاح"),
      messageText: Text(
        "فشل بعملية التعديل",
        style: flushBarStyle,
      ),

      boxShadows: [
        BoxShadow(
          color: UtilsImporter().colorUtils.primarycolor,
          offset: Offset(0.0, 2.0),
          blurRadius: 3.0,
        )
      ],
      icon: Icon(
        Icons.error,
        size: 28.0,
        color: Colors.white,
      ),
      duration: Duration(seconds: 1),
      leftBarIndicatorColor: UtilsImporter().colorUtils.kmColors,
    )..show(context);
  }
}

_deleteImageButton({int imageId, BuildContext context}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceAround,
    children: [
      Text(
        "حذف الصورة",
        overflow: TextOverflow.clip,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 15,
          fontFamily: UtilsImporter().stringUtils.HKGrotesk,
        ),
      ),
      IconButton(
        icon: Icon(
          Icons.delete,
          color: Colors.red,
          size: 30,
        ),

        // widget.products.supplierCode != null &&
        //                 LoadingScreenServices.subSupplierCodeHint
        //                     .hasMatch(widget.products.supplierCode)
        onPressed: () async {
          bool response =
              await PricesChangesSerives.deleteImage(imageId: imageId);
          if (response) {
            Flushbar(
              backgroundColor: Colors.green,
              // titleText: Text("تمت الإضافة بنجاح"),
              messageText: Text(
                "تم حذف الصورة بنجاح",
                style: flushBarStyle,
              ),

              boxShadows: [
                BoxShadow(
                  color: UtilsImporter().colorUtils.primarycolor,
                  offset: Offset(0.0, 2.0),
                  blurRadius: 3.0,
                )
              ],
              icon: Icon(
                Icons.assignment_turned_in,
                size: 28.0,
                color: Colors.white,
              ),
              duration: Duration(seconds: 2),
              leftBarIndicatorColor: UtilsImporter().colorUtils.kmColors,
            )..show(context);
          } else {
            Flushbar(
              backgroundColor: Colors.red[900],
              messageText: Text(
                "فشل بعملية حذف الصورة",
                style: flushBarStyle,
              ),
              boxShadows: [
                BoxShadow(
                  color: Colors.red,
                  offset: Offset(0.0, 2.0),
                  blurRadius: 3.0,
                )
              ],
              icon: Icon(
                Icons.error,
                size: 28.0,
                color: Colors.white,
              ),
              duration: Duration(seconds: 3),
              // leftBarIndicatorColor: UtilsImporter().colorUtils.kmColors,
            )..show(context);
          }
        },
      ),
    ],
  );
}
// TextStyle(
// fontWeight: FontWeight.w400,
// color:
// UtilsImporter().colorUtils.primarycolor,
// fontFamily:
// UtilsImporter().stringUtils.HKGrotesk,
// fontSize: 20.0,
// )
