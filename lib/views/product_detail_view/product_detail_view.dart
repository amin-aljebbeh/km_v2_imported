import 'dart:async';
import 'package:adv_image_cache/adv_image_cache.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:kammun_app/models/models_importer.dart';
import 'package:kammun_app/views/Wedgit/widgets_importer.dart';
import 'package:kammun_app/views/cart/services/cart_services.dart';
import 'package:kammun_app/views/loading/Loading.dart';
import 'package:kammun_app/views/loading/LoadingServices.dart';
import 'package:kammun_app/views/login/login_view.dart';
import 'package:kammun_app/views/prices_changes/services/prices_changes_services.dart';
import 'package:kammun_app/views/products_attached_to_warehouse/services/added_products_services.dart';
import 'package:kammun_app/views/products_view/services/products_services.dart';
import 'package:kammun_app/views/shop_by_category/shop_by_category_view.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Services.dart';
import 'package:full_screen_image/full_screen_image.dart';
import 'package:kammun_app/utils/utils_importer.dart';

// ignore: must_be_immutable
class ProductDetailView extends StatefulWidget {
  ProductData product;
  bool isFromFavoriteScreen;

  ProductDetailView({this.product, @required this.isFromFavoriteScreen});

  @override
  State<StatefulWidget> createState() {
    return ProductDetailViewState();
  }
}

class ProductDetailViewState extends State<ProductDetailView> with SingleTickerProviderStateMixin {
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

  bool isLoading = false;
  bool isError = false;

  String selectedValueCategoryValue;
  String productSubWarehouseId;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      left: false,
      right: false,
      bottom: true,
      child: Scaffold(
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
                  onPressed: () =>
                      Navigator.of(context).pushNamedAndRemoveUntil('/home', (Route<dynamic> route) => false),
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
                backgroundColor: ColorUtils.primaryColor,
                expandedHeight: 300.0,
                floating: false,
                pinned: true,
                title: Container(
                  alignment: Alignment.bottomCenter,
                  //padding: EdgeInsets.only(top: 15),
                  //   width: MediaQuery.of(context).size.width * 0.65,
                  child: done
                      ? AutoSizeText(
                          widget.product.name,
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
                                child: widget.product.images.length > 0
                                    ? Image(
                                        image: AdvImageCache(
                                          LoadingScreenServices.imagePrefixUrl +
                                              widget.product.images[0].imageFileName,
                                          useMemCache: true,
                                          diskCacheExpire: Duration(days: 400),
                                        ),
                                        width: MediaQuery.of(context).size.width / 2,
                                        height: 120,
                                        fit: BoxFit.contain,
                                      )
                                    : Image.asset(
                                        "assets/logobw.png",
                                      ),
                              ),
                            ),
                          )
                        : widget.product.images.length > 0
                            ? FullScreenWidget(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: Image(
                                    image: AdvImageCache(
                                      LoadingScreenServices.imagePrefixUrl +
                                          widget.product.images[0].imageFileName,
                                      useMemCache: true,
                                      diskCacheExpire: Duration(days: 400),
                                    ),
                                    width: MediaQuery.of(context).size.width / 2,
                                    height: 120,
                                    fit: BoxFit.contain,
                                  ),
                                ),
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
                    borderRadius:
                        BorderRadius.only(topRight: Radius.circular(20.0), topLeft: Radius.circular(20.0))),
                child: ListView(
                  shrinkWrap: true,
                  children: <Widget>[
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          widget.product.name,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: ColorUtils.primaryColor,
                            fontFamily: StringUtils.fontFamilyHKGrotesk,
                            fontSize: 25,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text(StringUtils.quantity + ' :', style: paragraphStyle),
                            SizedBox(width: 5),
                            Text(
                              widget.product.unit.toString() != "null"
                                  ? widget.product.quantity.toString() + " " + widget.product.unit.toString()
                                  : widget.product.quantity.toString(),
                              style: informationStyle,
                            ),
                          ],
                        ),
                        Column(
                          // crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text(StringUtils.price + ' :', style: paragraphStyle),
                            SizedBox(width: 5),
                            Text(
                                "${StringUtils().oCcy.format(int.parse(widget.product.price.toString().split(".")[0]))} ${LoadingScreenServices.companyInformation.currency}",
                                style: informationStyle),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        LabelRow(
                          rightSideText: StringUtils.description + ' :',
                          leftSideText:
                              widget.product.description != null ? widget.product.description.split("@")[0] : "",
                          leftSideStyle: informationStyle,
                        ),
                      ],
                    ),
                    Container(
                      height: 74,
                      child: ListView.builder(
                          itemCount: widget.product.categories.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                              width: MediaQuery.of(context).size.width * 0.45,
                              child: GestureDetector(
                                onLongPress: () {
                                  if (Services.isProductsController()) {
                                    List<DialogButton> dialogButtons = [
                                      DialogButton(
                                        text: StringUtils.yes,
                                        onTap: () async {
                                          Navigator.of(context).pop();
                                          bool result = await ProductsServices.removeProductFromCategory(
                                              productId: widget.product.id.toString(),
                                              categoryId: widget.product.categories[index].id.toString());
                                          Services.resultFlushBar(context: context, result: result);
                                          if (result) {
                                            setState(() {
                                              widget.product.categories.removeAt(index);
                                            });
                                          }
                                        },
                                      ),
                                      DialogButton(
                                        text: StringUtils.no,
                                        onTap: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ];
                                    showMyDialog(
                                        title: '',
                                        context: context,
                                        text:
                                            'هل تريد إزالة ${widget.product.name} من ${widget.product.categories[index].name} ؟',
                                        dialogButtons: dialogButtons);
                                  }
                                },
                                child: ShopByCategory(
                                  img: widget.product.categories[index].imageFileName,
                                  categoryName: widget.product.categories[index].name,
                                  index: index,
                                ),
                              ),
                            );
                          }),
                    ),
                    SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
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
                                  fontFamily: StringUtils.fontFamilyHKGrotesk,
                                  fontSize: 35)),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
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
                    SizedBox(height: 15),
                    int.parse(widget.product.isActive) == 0
                        ? Container(
                            height: 50,
                            width: MediaQuery.of(context).size.width,
                            padding: const EdgeInsets.all(3.0),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                    Radius.circular(10.0) //                 <--- border radius here
                                    ),
                                border: Border.all(color: ColorUtils.primaryColor, width: 4)),
                            child: Center(
                                child: Text(
                              StringUtils.outOfStock,
                              style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: StringUtils.fontFamilyHKGrotesk),
                            )),
                          )
                        : Container(),
                    KammunButton(
                      text:
                          '${StringUtils.addToCart}  (${StringUtils().oCcy.format(numberOfOrders * int.parse(widget.product.price.toString().split(".")[0]))})',
                      height: 50,
                      color: Theme.of(context).primaryColor,
                      onTap: () async {
                        String productsId = "";
                        String productsQuantity = "";
                        if (LoadingScreen.userToken.length > 5) {
                          Navigator.of(context).pop(true);

                          widget.product.productCount = numberOfOrders;

                          CartServices.addProductToCart(widget.product);
                          Flushbar(
                            backgroundColor: Colors.green,
                            messageText: Text(
                              "تم إضافة ${widget.product.name} لسلة المشتريات",
                              style: flushBarStyle,
                            ),
                            boxShadows: [
                              BoxShadow(
                                color: ColorUtils.primaryColor,
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
                            leftBarIndicatorColor: ColorUtils.kmColors,
                          )..show(context);

                          SharedPreferences prefs = await SharedPreferences.getInstance();
                          for (int i = 0; i < CartServices.cartProducts.length; i++) {
                            productsId += CartServices.cartProducts[i].id.toString() + ";";
                            productsQuantity += CartServices.cartProducts[i].productCount.toString() + ";";
                          }
                          prefs.setString("userCart", productsId + "@" + productsQuantity);
                        } else {
                          Navigator.of(context).pushNamed(LoginScreen.routeName);
                        }
                      },
                    ),
                    (LoadingScreenServices.subWarehouses
                            .any((element) => element.id == widget.product.subWarehouseId))
                        ? Column(
                            children: [
                              SizedBox(height: 30),
                              UpdateProductInfoWidget(
                                title: StringUtils.edit + ' ' + StringUtils.price + ' :',
                                inputType: TextInputType.number,
                                bodyKey: "price",
                                productId: widget.product.id,
                                productData: widget.product,
                                textHint: widget.product.price,
                                initialText: widget.product.price,
                                onSavePressed: (newValue) {
                                  setState(() {
                                    widget.product.price = newValue;
                                  });
                                },
                              ),
                              UpdateProductInfoWidget(
                                title: StringUtils.edit + ' ' + StringUtils.supplierCode + ':',
                                inputType: TextInputType.text,
                                textHint: widget.product.supplierCode,
                                initialText: widget.product.supplierCode,
                                bodyKey: "supplier_code",
                                productId: widget.product.id,
                                productData: widget.product,
                                onSavePressed: (newValue) {
                                  setState(() {
                                    widget.product.supplierCode = newValue;
                                  });
                                },
                              ),
                              UpdateProductInfoWidget(
                                title: StringUtils.priceFactor + ' :',
                                inputType: TextInputType.number,
                                bodyKey: "price_factor",
                                productId: widget.product.id,
                                productData: widget.product,
                                textHint: widget.product.priceFactor,
                                initialText: widget.product.priceFactor,
                                onSavePressed: (newValue) {
                                  setState(() {
                                    widget.product.priceFactor = newValue;
                                  });
                                },
                              ),
                              Services.isProductsController() || Services.isAdmin() || Services.isSuperAdmin()
                                  ? Column(
                                      children: [
                                        UpdateProductInfoWidget(
                                          title: StringUtils.edit + ' ' + StringUtils.priority + ' :',
                                          textHint: widget.product.priority.toString(),
                                          inputType: TextInputType.text,
                                          bodyKey: "priority",
                                          productId: widget.product.id,
                                          isForSubWarehouse: true,
                                          productData: widget.product,
                                          initialText: widget.product.priority.toString(),
                                          onSavePressed: (newValue) {
                                            setState(() {
                                              widget.product.priority = int.parse(newValue);
                                            });
                                          },
                                        ),
                                        UpdateProductInfoWidget(
                                          title: StringUtils.edit + ' ' + StringUtils.name + ' :',
                                          textHint: widget.product.name,
                                          inputType: TextInputType.multiline,
                                          bodyKey: "name",
                                          productId: widget.product.id,
                                          initialText: widget.product.name,
                                          isForSubWarehouse: false,
                                          productData: widget.product,
                                          onSavePressed: (newValue) {
                                            setState(() {
                                              widget.product.name = newValue;
                                            });
                                          },
                                        ),
                                        UpdateProductInfoWidget(
                                          title: StringUtils.edit + ' ' + StringUtils.unit + ' :',
                                          inputType: TextInputType.multiline,
                                          bodyKey: "unit",
                                          productId: widget.product.id,
                                          isForSubWarehouse: false,
                                          productData: widget.product,
                                          textHint: widget.product.unit,
                                          initialText: widget.product.unit,
                                          onSavePressed: (newValue) {
                                            setState(() {
                                              widget.product.unit = newValue;
                                            });
                                          },
                                        ),
                                        UpdateProductInfoWidget(
                                          title: StringUtils.edit + ' ' + StringUtils.quantity + ' :',
                                          isForSubWarehouse: false,
                                          inputType: TextInputType.text,
                                          productData: widget.product,
                                          textHint: widget.product.quantity,
                                          bodyKey: "quantity",
                                          productId: widget.product.id,
                                          initialText: widget.product.quantity,
                                          onSavePressed: (newValue) {
                                            setState(() {
                                              widget.product.quantity = newValue;
                                            });
                                          },
                                        ),
                                        UpdateProductInfoWidget(
                                          title: StringUtils.edit + ' ' + StringUtils.description + ' :',
                                          textHint: "الوصف الجديد",
                                          inputType: TextInputType.multiline,
                                          bodyKey: "description",
                                          productId: widget.product.id,
                                          isForSubWarehouse: false,
                                          productData: widget.product,
                                          initialText: widget.product.description,
                                          onSavePressed: (newValue) {
                                            setState(() {
                                              widget.product.description = newValue;
                                            });
                                          },
                                        ),
                                        Container(
                                          width: MediaQuery.of(context).size.width,
                                          padding: EdgeInsets.only(left: 5, right: 5),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(6),
                                            border: Border.all(width: 5, color: ColorUtils.greyColor),
                                          ),
                                          child: Center(
                                            child: new DropdownButton(
                                              style: decisionButtonStyle,
                                              underline: Container(),
                                              isExpanded: false,
                                              items: Services.productSubWarehouseNames(context),
                                              iconEnabledColor: ColorUtils.greyColor,
                                              value: productSubWarehouseId,
                                              hint: new Text(
                                                LoadingScreenServices.subWarehouses
                                                    .firstWhere((subWarehouse) =>
                                                        subWarehouse.id == widget.product.subWarehouseId)
                                                    .name,
                                                style: decisionButtonStyle.copyWith(
                                                  color: ColorUtils.greyColor,
                                                ),
                                              ),
                                              onChanged: (value) async {
                                                bool result =
                                                    await AddedProductsServices.changeProductSubWarehouse(
                                                        widget.product, value);

                                                Services.resultFlushBar(context: context, result: result);
                                                setState(() {
                                                  if (value != null) {
                                                    if (result) productSubWarehouseId = value;
                                                    widget.product.subWarehouseId = int.parse(value);
                                                  }
                                                });
                                              },
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 15),
                                        Container(
                                          width: MediaQuery.of(context).size.width,
                                          padding: EdgeInsets.only(left: 5, right: 5),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(6),
                                            border: Border.all(width: 5, color: ColorUtils.greyColor),
                                          ),
                                          child: Center(
                                            child: new SearchableDropdown(
                                              style: decisionButtonStyle,
                                              closeButton: FlatButton(
                                                child: Text(
                                                  StringUtils.close,
                                                  style: decisionButtonStyle.copyWith(
                                                    color: ColorUtils.greyColor,
                                                  ),
                                                ),
                                                onPressed: () => Navigator.of(context).pop(),
                                              ),
                                              isCaseSensitiveSearch: false,
                                              underline: Container(),
                                              isExpanded: false,
                                              items: LoadingScreenServices.fullCategoryList,
                                              iconEnabledColor: ColorUtils.greyColor,
                                              value: selectedValueCategoryValue,
                                              hint: new Text(
                                                'اختيار الصنف التابع له المنتج',
                                                style: decisionButtonStyle.copyWith(color: ColorUtils.greyColor),
                                              ),
                                              searchHint: new Text(
                                                'إختيار الصنف',
                                                style: decisionButtonStyle.copyWith(
                                                  color: ColorUtils.greyColor,
                                                ),
                                              ),
                                              onChanged: (value) {
                                                setState(() {
                                                  if (value != null) {
                                                    selectedValueCategoryValue = value.toString().split(";")[1];
                                                    print(MediaQuery.of(context).size.width);
                                                  }
                                                });
                                              },
                                            ),
                                          ),
                                        ),
                                        widget.product.images.length > 0
                                            ? KammunButton(
                                                height: 50,
                                                color: Theme.of(context).primaryColor,
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                                                  bool result = await PricesChangesServices.deleteImage(
                                                      imageId: widget.product.images[0].id);
                                                  Services.resultFlushBar(context: context, result: result);
                                                },
                                              )
                                            : Container(),
                                        KammunButton(
                                          height: 50,
                                          text: "الإضافة لصنف جديد",
                                          color: Theme.of(context).primaryColor,
                                          onTap: () async {
                                            bool result = await _saveCategory(
                                                categoryId: selectedValueCategoryValue,
                                                context: context,
                                                productId: widget.product.id);
                                            if (result) {
                                              setState(() {
                                                widget.product.categories.add(CategoryOriginalData(
                                                    id: int.parse(selectedValueCategoryValue),
                                                    name: LoadingScreenServices.categoryList
                                                        .firstWhere((category) =>
                                                            category.id.toString() == selectedValueCategoryValue)
                                                        .name,
                                                    imageFileName: LoadingScreenServices.categoryList
                                                        .firstWhere((category) =>
                                                            category.id.toString() == selectedValueCategoryValue)
                                                        .imageFileName));
                                              });
                                            }
                                          },
                                        ),
                                        AddImageWidget(
                                            hasImage: false,
                                            onSubmit: (image) async {
                                              bool result = await ProductsServices.setImageToProducts(
                                                  productId: widget.product.id, image: image);
                                              Services.resultFlushBar(context: context, result: result);
                                            }),
                                        Services.isAdmin() || Services.isProductsController()
                                            ? Column(
                                                children: [
                                                  KammunButton(
                                                    height: 50,
                                                    text: "إزالة من المستودع",
                                                    color: Colors.red,
                                                    onTap: () {
                                                      List<DialogButton> dialogButtons = [
                                                        DialogButton(
                                                          text: StringUtils.yes,
                                                          onTap: () async {
                                                            bool result = await AddedProductsServices
                                                                .unAttachProductsToSubWarehouse(
                                                                    productsId: widget.product.id.toString(),
                                                                    subWarehouse:
                                                                        widget.product.subWarehouseId.toString());
                                                            if (result) {
                                                              int count = 0;
                                                              Navigator.of(context).popUntil((_) => count++ >= 1);
                                                            }
                                                            Services.resultFlushBar(
                                                                context: context, result: result);
                                                          },
                                                        ),
                                                        DialogButton(
                                                          text: StringUtils.no,
                                                          onTap: () {
                                                            Navigator.of(context).pop();
                                                          },
                                                        ),
                                                      ];
                                                      showMyDialog(
                                                          title: '',
                                                          context: context,
                                                          text:
                                                              'هل تريد إزالة ${widget.product.name} من المستودع ؟',
                                                          dialogButtons: dialogButtons);
                                                    },
                                                  ),
                                                  KammunButton(
                                                    height: 50,
                                                    text: "حذف المنتج",
                                                    color: Colors.red,
                                                    onTap: () {
                                                      List<DialogButton> dialogButtons = [
                                                        DialogButton(
                                                          text: StringUtils.yes,
                                                          onTap: () async {
                                                            bool result = await ProductsServices.deleteProduct(
                                                                widget.product.id.toString());
                                                            if (result) {
                                                              int count = 0;
                                                              Navigator.of(context).popUntil((_) => count++ >= 2);
                                                            }
                                                            Services.resultFlushBar(
                                                                context: context, result: result);
                                                          },
                                                        ),
                                                        DialogButton(
                                                          text: StringUtils.no,
                                                          onTap: () {
                                                            Navigator.of(context).pop();
                                                          },
                                                        ),
                                                      ];
                                                      showMyDialog(
                                                          title: '',
                                                          context: context,
                                                          text: 'هل تريد حذف ${widget.product.name} نهائياً ؟',
                                                          dialogButtons: dialogButtons);
                                                    },
                                                  ),
                                                ],
                                              )
                                            : Container(),
                                        SizedBox(height: 30),
                                      ],
                                    )
                                  : Services.isSupplierManager()
                                      ? KammunButton(
                                          height: 50,
                                          text: "إزالة من المستودع",
                                          color: Colors.red,
                                          onTap: () {
                                            List<DialogButton> dialogButtons = [
                                              DialogButton(
                                                text: StringUtils.yes,
                                                onTap: () async {
                                                  bool result =
                                                      await AddedProductsServices.unAttachProductsToSubWarehouse(
                                                          productsId: widget.product.id.toString(),
                                                          subWarehouse: widget.product.subWarehouseId.toString());
                                                  if (result) {
                                                    int count = 0;
                                                    Navigator.of(context).popUntil((_) => count++ >= 1);
                                                  }
                                                  Services.resultFlushBar(context: context, result: result);
                                                },
                                              ),
                                              DialogButton(
                                                text: StringUtils.no,
                                                onTap: () {
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                            ];
                                            showMyDialog(
                                                title: '',
                                                context: context,
                                                text: 'هل تريد إزالة ${widget.product.name} من المستودع ؟',
                                                dialogButtons: dialogButtons);
                                          },
                                        )
                                      : Container(),
                            ],
                          )
                        : Container(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Future<bool> _saveCategory({BuildContext context, int productId, String categoryId}) async {
  bool result = await ProductsServices.updateProductsDetails(
      bodyKey: "category_id", value: categoryId, productId: productId.toString());

  Services.resultFlushBar(context: context, result: result);
  return result;
}
