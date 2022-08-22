import 'package:adv_image_cache/adv_image_cache.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flushbar/flushbar.dart';
import 'package:full_screen_image/full_screen_image.dart';
import 'package:kammun_app/views/cart/services/cart_services.dart';
import 'package:kammun_app/views/loading/loading.dart';
import 'package:kammun_app/views/loading/loading_services.dart';
import 'package:kammun_app/views/login/login_view.dart';
import 'package:kammun_app/views/prices_changes/services/prices_changes_services.dart';
import 'package:kammun_app/views/products_attached_to_warehouse/services/added_products_services.dart';
import 'package:kammun_app/views/products_view/services/products_services.dart';
import 'package:search_choices/search_choices.dart';

import '../../core/core_importer.dart';

class ProductDetailView extends StatefulWidget {
  final ProductData product;
  final Function(String) onAddBarcode;
  final Function(String) onChangePrice;
  final Function(String) onChangeUnit;
  final Function(String) onChangeQuantity;

  const ProductDetailView(
      {Key key, this.product, this.onAddBarcode, this.onChangePrice, this.onChangeUnit, this.onChangeQuantity})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => ProductDetailViewState();
}

class ProductDetailViewState extends State<ProductDetailView> with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Animation _animation;
  bool done = false;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  final _controller = ScrollController(initialScrollOffset: 0.0);
  final _height = 100.0;

  int numberOfOrders = 1;
  bool productOnFavorites = false;

  @override
  void initState() {
    if (widget.product.warehouses.isEmpty) {
      widget.product.warehouses.add(Warehouse(name: 'غير مضاف لمستودع', id: 0));
    }
    super.initState();

    Timer(const Duration(milliseconds: 100), () => _animateToIndex(2.5));

    _animationController = AnimationController(duration: const Duration(milliseconds: 1500), vsync: this);
    _animation = Tween(begin: 1.5, end: 0.0).animate(_animationController);

    _animationController.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  _animateToIndex(i) async {
    await _controller.animateTo(_height * i, duration: const Duration(milliseconds: 1500), curve: Curves.easeInOut);
    setState(() => done = true);
  }

  bool isLoading = false;
  bool isError = false;

  String selectedValueCategoryValue;
  String productSubWarehouseId;

  @override
  Widget build(BuildContext context) {
    String price = widget.product.price;
    if (Services.isSupplierManager()) {
      price = (int.parse(widget.product.price.split('.')[0]) - widget.product.increasePercentage).toString();
    }
    return SafeArea(
      key: scaffoldKey,
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
                          Navigator.of(context).pushNamedAndRemoveUntil('/home', (Route<dynamic> route) => false)),
                  actions: <Widget>[
                    IconButton(
                        onPressed: () => Navigator.of(context).pop(true),
                        icon: const Icon(Icons.arrow_forward_ios, size: 35))
                  ],
                  backgroundColor: ColorUtils.primaryColor,
                  expandedHeight: 300.0,
                  floating: false,
                  pinned: true,
                  title: Container(
                      alignment: Alignment.bottomCenter,
                      child: done ? AutoSizeText(widget.product.name, maxLines: 1, style: mainStyle) : Container()),
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
                                          child: widget.product.images.isNotEmpty
                                              ? Image(
                                                  image: AdvImageCache(
                                                      LoadingScreenServices.imagePrefixUrl +
                                                          widget.product.images[0].imageFileName,
                                                      useMemCache: true,
                                                      diskCacheExpire: const Duration(days: 400)),
                                                  width: MediaQuery.of(context).size.width / 2,
                                                  height: 120,
                                                  fit: BoxFit.contain)
                                              : Image.asset('assets/logobw.png'))))
                              : widget.product.images.isNotEmpty
                                  ? FullScreenWidget(
                                      child: ClipRRect(
                                          borderRadius: BorderRadius.circular(16),
                                          child: Image(
                                              image: AdvImageCache(
                                                  LoadingScreenServices.imagePrefixUrl +
                                                      widget.product.images[0].imageFileName,
                                                  useMemCache: true,
                                                  diskCacheExpire: const Duration(days: 400)),
                                              width: MediaQuery.of(context).size.width / 2,
                                              height: 120,
                                              fit: BoxFit.contain)))
                                  : Image.asset('assets/logobw.png')))),
            ];
          },
          body: SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 25),
              child: Container(
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(topRight: Radius.circular(20.0), topLeft: Radius.circular(20.0))),
                child: ListView(
                  shrinkWrap: true,
                  children: <Widget>[
                    Center(
                        child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(widget.product.name,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: ColorUtils.primaryColor,
                                    fontFamily: StringUtils.fontFamily,
                                    fontSize: 25)))),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text(StringUtils.quantity + ' :', style: paragraphStyle),
                            const SizedBox(width: 5),
                            Text(
                                widget.product.unit.toString() != 'null'
                                    ? widget.product.quantity.toString() + ' ' + widget.product.unit.toString()
                                    : widget.product.quantity.toString(),
                                style: informationStyle),
                          ],
                        ),
                        Column(
                          children: <Widget>[
                            Text(StringUtils.price + ' :', style: paragraphStyle),
                            const SizedBox(width: 5),
                            Text(
                                '${StringUtils().oCcy.format(int.parse(widget.product.price.toString().split('.')[0]))} ${LoadingScreenServices.companyInformation.currency}',
                                style: informationStyle),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    LabelRow(
                        rightSideText: 'ProductId : ',
                        leftSideText: widget.product.id.toString(),
                        leftSideStyle: informationStyle),
                    const SizedBox(height: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        LabelRow(
                            rightSideText: StringUtils.description + ' :',
                            leftSideText:
                                widget.product.description != null ? widget.product.description.split('@')[0] : "",
                            leftSideStyle: informationStyle),
                      ],
                    ),
                    SizedBox(
                      height: 74,
                      child: ListView.builder(
                        itemCount: widget.product.categories.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (BuildContext context, int index) {
                          return SizedBox(
                            width: MediaQuery.of(context).size.width * 0.45,
                            child: GestureDetector(
                              onLongPress: () {
                                if (Services.isProductsController()) {
                                  List<DialogButton> dialogButtons = [
                                    DialogButton(
                                      text: StringUtils.yes,
                                      onTap: () async {
                                        Navigator.of(context).pop();
                                        bool result = await ProductsServices.removeProductFromCategoryService(
                                            productId: widget.product.id.toString(),
                                            categoryId: widget.product.categories[index].id.toString());
                                        Services.resultFlushBar(context: context, result: result);
                                        if (result) {
                                          setState(() => widget.product.categories.removeAt(index));
                                        }
                                      },
                                    ),
                                    DialogButton(text: StringUtils.no, onTap: () => Navigator.of(context).pop()),
                                  ];
                                  showMyDialog(
                                      title: '',
                                      text:
                                          'هل تريد إزالة ${widget.product.name} من ${widget.product.categories[index].name} ؟',
                                      dialogButtons: dialogButtons);
                                }
                              },
                              child: ShopByCategory(
                                  img: widget.product.categories[index].imageFileName,
                                  categoryName: widget.product.categories[index].name,
                                  index: index,
                                  fit: BoxFit.cover),
                            ),
                          );
                        },
                      ),
                    ),
                    if (Services.isProductsController())
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: SizedBox(
                          height: 74,
                          child: ListView.builder(
                            itemCount: widget.product.warehouses.length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (BuildContext context, int index) {
                              return SizedBox(
                                width: MediaQuery.of(context).size.width * 0.45,
                                child: ShopByCategory(
                                    img: 'null',
                                    categoryName: widget.product.warehouses[index].name,
                                    index: index + 100,
                                    fit: BoxFit.contain),
                              );
                            },
                          ),
                        ),
                      ),
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                            padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                            child: InkWell(
                                onTap: () => setState(() {
                                      if (numberOfOrders > 1) {
                                        numberOfOrders = numberOfOrders - 1;
                                      }
                                    }),
                                child: Image.asset('assets/remove.png', width: 60, height: 60))),
                        const SizedBox(width: 10),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(numberOfOrders.toString(),
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                  fontFamily: StringUtils.fontFamily,
                                  fontSize: 35)),
                        ),
                        const SizedBox(width: 10),
                        Padding(
                            padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                            child: InkWell(
                                onTap: () => setState(() => numberOfOrders = numberOfOrders + 1),
                                child: Image.asset('assets/add.png', width: 60, height: 60))),
                      ],
                    ),
                    const SizedBox(height: 15),
                    if (widget.product.isActive == '0')
                      Container(
                          height: 50,
                          width: MediaQuery.of(context).size.width,
                          padding: const EdgeInsets.all(3.0),
                          decoration: BoxDecoration(
                              borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                              border: Border.all(color: ColorUtils.primaryColor, width: 4)),
                          child: Center(
                              child: Text(StringUtils.outOfStock,
                                  style: TextStyle(
                                      fontSize: 25, fontWeight: FontWeight.bold, fontFamily: StringUtils.fontFamily)))),
                    KammunButton(
                      text:
                          '${StringUtils.addToCart}  (${StringUtils().oCcy.format(numberOfOrders * int.parse(widget.product.price.toString().split('.')[0]))})',
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
                            messageText: Text('تم إضافة ${widget.product.name} لسلة المشتريات', style: flushBarStyle),
                            boxShadows: [
                              BoxShadow(color: ColorUtils.primaryColor, offset: const Offset(0.0, 2.0), blurRadius: 3.0)
                            ],
                            icon: const Icon(Icons.assignment_turned_in, size: 28.0, color: Colors.white),
                            duration: const Duration(seconds: 3),
                            leftBarIndicatorColor: ColorUtils.kmColors,
                          ).show(context);
                          SharedPreferences prefs = await SharedPreferences.getInstance();
                          productsId =
                              CartServices.cartProducts.fold('', (ids, product) => product.id.toString() + ';');
                          productsQuantity = CartServices.cartProducts
                              .fold('', (counts, product) => product.productCount.toString() + ';');
                          prefs.setString('userCart', productsId + '@' + productsQuantity);
                        } else {
                          Navigator.of(context).pushNamed(LoginScreen.routeName);
                        }
                      },
                    ),
                    Column(
                      children: [
                        const SizedBox(height: 30),
                        UpdateProductInfoWidget(
                          title: StringUtils.edit + ' ' + StringUtils.price + ' :',
                          inputType: TextInputType.text,
                          bodyKey: 'price',
                          productId: widget.product.id,
                          productData: widget.product,
                          textHint: price,
                          increasePercentage: widget.product.increasePercentage,
                          priceFactor:
                              widget.product.priceFactor != null ? double.parse(widget.product.priceFactor) : 1,
                          initialText: price,
                          onSavePressed: (newValue, result) => setState(() {
                            if (result) {
                              widget.product.price = newValue;
                              widget.onChangePrice(newValue);
                            }
                          }),
                        ),
                        UpdateProductInfoWidget(
                          title: StringUtils.edit + ' ' + StringUtils.supplierCode + ':',
                          inputType: TextInputType.text,
                          textHint: widget.product.supplierCode,
                          initialText: widget.product.supplierCode,
                          bodyKey: 'supplier_code',
                          productId: widget.product.id,
                          productData: widget.product,
                          onSavePressed: (newValue, result) => setState(() => widget.product.supplierCode = newValue),
                        ),
                        UpdateProductInfoWidget(
                          title: StringUtils.priceFactor + ' :',
                          inputType: TextInputType.text,
                          bodyKey: 'price_factor',
                          productId: widget.product.id,
                          productData: widget.product,
                          textHint: widget.product.priceFactor,
                          initialText: widget.product.priceFactor,
                          onSavePressed: (newValue, result) => setState(() => widget.product.priceFactor = newValue),
                        ),
                        Services.isProductsController() || Services.isAdmin() || Services.isSuperAdmin()
                            ? Column(
                                children: [
                                  UpdateProductInfoWidget(
                                    title: StringUtils.edit + ' ' + StringUtils.priority + ' :',
                                    textHint: widget.product.priority.toString(),
                                    inputType: TextInputType.text,
                                    bodyKey: 'priority',
                                    productId: widget.product.id,
                                    isForSubWarehouse: true,
                                    productData: widget.product,
                                    initialText: widget.product.priority.toString(),
                                    onSavePressed: (newValue, result) =>
                                        setState(() => widget.product.priority = int.parse(newValue)),
                                  ),
                                  UpdateProductInfoWidget(
                                    title: StringUtils.edit + ' ' + StringUtils.name,
                                    textHint: widget.product.name,
                                    inputType: TextInputType.multiline,
                                    bodyKey: 'name',
                                    productId: widget.product.id,
                                    initialText: widget.product.name,
                                    isForSubWarehouse: false,
                                    productData: widget.product,
                                    onSavePressed: (newValue, result) => setState(() => widget.product.name = newValue),
                                  ),
                                  UpdateProductInfoWidget(
                                    title: StringUtils.edit + ' ' + StringUtils.unit + ' :',
                                    inputType: TextInputType.multiline,
                                    bodyKey: 'unit',
                                    productId: widget.product.id,
                                    isForSubWarehouse: false,
                                    productData: widget.product,
                                    textHint: widget.product.unit,
                                    initialText: widget.product.unit,
                                    onSavePressed: (newValue, result) => setState(() {
                                      widget.product.unit = newValue;
                                      widget.onChangeUnit(newValue);
                                    }),
                                  ),
                                  UpdateProductInfoWidget(
                                    title: StringUtils.edit + ' ' + StringUtils.quantity + ' :',
                                    isForSubWarehouse: false,
                                    inputType: TextInputType.text,
                                    productData: widget.product,
                                    textHint: widget.product.quantity,
                                    bodyKey: 'quantity',
                                    productId: widget.product.id,
                                    initialText: widget.product.quantity,
                                    onSavePressed: (newValue, result) => setState(() {
                                      widget.product.quantity = newValue;
                                      widget.onChangeQuantity(newValue);
                                    }),
                                  ),
                                  UpdateProductInfoWidget(
                                    title: StringUtils.edit + ' ' + StringUtils.description + ' :',
                                    textHint: 'الوصف الجديد',
                                    inputType: TextInputType.multiline,
                                    bodyKey: 'description',
                                    productId: widget.product.id,
                                    isForSubWarehouse: false,
                                    productData: widget.product,
                                    initialText: widget.product.description,
                                    onSavePressed: (newValue, result) =>
                                        setState(() => widget.product.description = newValue),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    padding: const EdgeInsets.only(left: 5, right: 5),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(6),
                                      border: Border.all(width: 5, color: ColorUtils.greyColor),
                                    ),
                                    child: Center(
                                      child: DropdownButton(
                                        style: decisionButtonStyle,
                                        underline: Container(),
                                        isExpanded: false,
                                        items: Services.productSubWarehouseNames(context),
                                        iconEnabledColor: ColorUtils.greyColor,
                                        value: productSubWarehouseId,
                                        hint: Text(
                                          LoadingScreenServices.subWarehouses
                                              .firstWhere(
                                                  (subWarehouse) => subWarehouse.id == widget.product.subWarehouseId,
                                                  orElse: () => SubWarehouse(name: 'غير مضاف'))
                                              .name,
                                          style: decisionButtonStyle.copyWith(color: ColorUtils.greyColor),
                                        ),
                                        onChanged: (value) async {
                                          setState(() {
                                            isLoading = true;
                                            widget.product.warehouses.removeWhere((warehouse) => warehouse.id == 0);
                                          });
                                          bool remove = LoadingScreenServices.subWarehouses
                                              .where((subWarehouse) => subWarehouse.id == widget.product.subWarehouseId)
                                              .toList()
                                              .isNotEmpty;
                                          bool result = await AddedProductsServices.changeProductSubWarehouse(
                                              widget.product, value, remove);

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
                                  const SizedBox(height: 15),
                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    padding: const EdgeInsets.only(left: 5, right: 5),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(6),
                                        border: Border.all(width: 5, color: ColorUtils.greyColor)),
                                    child: Center(
                                      child: SearchChoices.single(
                                        rightToLeft: true,
                                        searchInputDecoration: InputDecoration(
                                            suffixIcon: Icon(Icons.search, size: 24, color: ColorUtils.primaryColor),
                                            contentPadding: const EdgeInsets.symmetric(vertical: 12)),
                                        iconDisabledColor: Colors.black,
                                        displayClearIcon: false,
                                        style: dropdownItemStyle,
                                        closeButton: TextButton(
                                          child: Text(StringUtils.close,
                                              style: decisionButtonStyle.copyWith(color: ColorUtils.primaryColor)),
                                          onPressed: () => Navigator.of(context).pop(),
                                        ),
                                        isCaseSensitiveSearch: false,
                                        underline: Container(),
                                        isExpanded: false,
                                        items: LoadingScreenServices.fullCategoryList,
                                        iconEnabledColor: ColorUtils.greyColor,
                                        value: selectedValueCategoryValue,
                                        hint: Text('اختيار الصنف التابع له المنتج',
                                            style: decisionButtonStyle.copyWith(color: ColorUtils.greyColor)),
                                        searchHint: Text('إختيار الصنف',
                                            style: decisionButtonStyle.copyWith(color: ColorUtils.greyColor)),
                                        onChanged: (value) {
                                          setState(() {
                                            if (value != null) {
                                              selectedValueCategoryValue = value.toString().split(';')[1];
                                            }
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                  widget.product.images.isNotEmpty
                                      ? KammunButton(
                                          height: 50,
                                          color: Theme.of(context).primaryColor,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Text('حذف الصورة',
                                                  overflow: TextOverflow.clip, style: decisionButtonStyle),
                                              const Icon(Icons.delete, color: Colors.white, size: 30),
                                            ],
                                          ),
                                          onTap: () async {
                                            showMyDialog(
                                                title: 'حذف صورة',
                                                text: 'هل أنت متأكد من رغبتك في حذف صورة المنتج ؟',
                                                dialogButtons: [
                                                  const CloseButton(),
                                                  DialogButton(
                                                    text: StringUtils.yes,
                                                    onTap: () async {
                                                      bool result = await PricesChangesServices.deleteImage(
                                                          imageId: widget.product.images[0].id);
                                                      Services.resultFlushBar(context: context, result: result);
                                                    },
                                                  )
                                                ]);
                                          },
                                        )
                                      : Container(),
                                  KammunButton(
                                    height: 50,
                                    text: 'الإضافة لصنف جديد',
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
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      if (Services.isProductsController())
                                        Row(
                                          children: [
                                            BarcodeIcon(
                                              productData: widget.product,
                                              color: ColorUtils.kmColors,
                                              requestType: BarcodeRequestType.addBarcode,
                                              productId: widget.product.id,
                                              scaffoldKey: scaffoldKey,
                                              onAddBarcode: (result) => widget.onAddBarcode(result),
                                            ),
                                            IconButton(
                                              icon: Icon(Icons.list, size: 30, color: ColorUtils.kmColors2),
                                              onPressed: () {
                                                showMyDialog(
                                                  title: 'باركود',
                                                  content: Column(
                                                    children: widget.product.barcodes
                                                        .map(
                                                          (barcode) => GestureDetector(
                                                            child: Column(
                                                              children: [
                                                                const Divider(color: Colors.black, thickness: 1),
                                                                Text(barcode.barcode,
                                                                    style: decisionButtonStyle.copyWith(
                                                                        color: Colors.black)),
                                                                const Divider(color: Colors.black, thickness: 1),
                                                              ],
                                                            ),
                                                            onTap: () {
                                                              Navigator.of(context).pop();
                                                              showMyDialog(
                                                                title: 'إزالة باركود',
                                                                dialogButtons: [
                                                                  DialogButton(
                                                                    text: StringUtils.yes,
                                                                    onTap: () async {
                                                                      bool result =
                                                                          await ProductsServices.deleteBarcode(
                                                                              bareCodeId: widget.product.barcodes
                                                                                  .firstWhere((barcodeToDelete) =>
                                                                                      barcodeToDelete.barcode ==
                                                                                      barcode.barcode)
                                                                                  .id);
                                                                      Navigator.of(context).pop();
                                                                      if (result) {
                                                                        setState(() {
                                                                          widget.product.barcodes.removeWhere(
                                                                              (barcodeToDelete) =>
                                                                                  barcodeToDelete.barcode ==
                                                                                  barcode.barcode);
                                                                        });
                                                                      }
                                                                      Services.resultFlushBar(
                                                                          context: context, result: result);
                                                                    },
                                                                  ),
                                                                  DialogButton(
                                                                      text: StringUtils.no,
                                                                      onTap: () => Navigator.of(context).pop()),
                                                                ],
                                                                text:
                                                                    'هل أنت متأكد أنك ترغب في إزالة الباركود للمنتج ؟',
                                                              );
                                                            },
                                                          ),
                                                        )
                                                        .toList(),
                                                  ),
                                                  dialogButtons: [const CloseWidget()],
                                                );
                                              },
                                            ),
                                          ],
                                        ),
                                      AddImageWidget(
                                        onSubmit: (image) async {
                                          bool result = await ProductsServices.setImageToProducts(
                                              productId: widget.product.id, image: image);
                                          Services.resultFlushBar(context: context, result: result);
                                        },
                                      ),
                                    ],
                                  ),
                                  (Services.isAdmin() || Services.isProductsController())
                                      ? Column(
                                          children: [
                                            if (LoadingScreenServices.subWarehouses
                                                .any((element) => element.id == widget.product.subWarehouseId))
                                              KammunButton(
                                                height: 50,
                                                text: 'إزالة من المستودع',
                                                color: Colors.red,
                                                onTap: () {
                                                  List<DialogButton> dialogButtons = [
                                                    DialogButton(
                                                      text: StringUtils.yes,
                                                      onTap: () async {
                                                        bool result = await AddedProductsServices
                                                            .unAttachProductsToSubWarehouseService(
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
                                                        text: StringUtils.no, onTap: () => Navigator.of(context).pop()),
                                                  ];
                                                  showMyDialog(
                                                      title: '',
                                                      text: 'هل تريد إزالة ${widget.product.name} من المستودع ؟',
                                                      dialogButtons: dialogButtons);
                                                },
                                              ),
                                            KammunButton(
                                              height: 50,
                                              text: 'حذف المنتج',
                                              color: Colors.red,
                                              onTap: () {
                                                List<DialogButton> dialogButtons = [
                                                  DialogButton(
                                                    text: StringUtils.yes,
                                                    onTap: () async {
                                                      bool result = await ProductsServices.deleteProductService(
                                                          widget.product.id.toString());
                                                      if (result) {
                                                        int count = 0;
                                                        Navigator.of(context).popUntil((_) => count++ >= 2);
                                                      }
                                                      Services.resultFlushBar(context: context, result: result);
                                                    },
                                                  ),
                                                  DialogButton(
                                                      text: StringUtils.no, onTap: () => Navigator.of(context).pop()),
                                                ];
                                                showMyDialog(
                                                    title: '',
                                                    text: 'هل تريد حذف ${widget.product.name} نهائياً ؟',
                                                    dialogButtons: dialogButtons);
                                              },
                                            ),
                                          ],
                                        )
                                      : Container(),
                                  const SizedBox(height: 30),
                                ],
                              )
                            : Services.isSupplierManager() &&
                                    (LoadingScreenServices.subWarehouses
                                        .any((element) => element.id == widget.product.subWarehouseId))
                                ? KammunButton(
                                    height: 50,
                                    text: 'إزالة من المستودع',
                                    color: Colors.red,
                                    onTap: () {
                                      List<DialogButton> dialogButtons = [
                                        DialogButton(
                                          text: StringUtils.yes,
                                          onTap: () async {
                                            bool result =
                                                await AddedProductsServices.unAttachProductsToSubWarehouseService(
                                                    productsId: widget.product.id.toString(),
                                                    subWarehouse: widget.product.subWarehouseId.toString());
                                            if (result) {
                                              int count = 0;
                                              Navigator.of(context).popUntil((_) => count++ >= 1);
                                            }
                                            Services.resultFlushBar(context: context, result: result);
                                          },
                                        ),
                                        DialogButton(text: StringUtils.no, onTap: () => Navigator.of(context).pop()),
                                      ];
                                      showMyDialog(
                                          title: '',
                                          text: 'هل تريد إزالة ${widget.product.name} من المستودع ؟',
                                          dialogButtons: dialogButtons);
                                    },
                                  )
                                : Container(),
                      ],
                    ),
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
      bodyKey: 'category_id', value: categoryId, productId: productId.toString());

  Services.resultFlushBar(context: context, result: result);
  return result;
}
