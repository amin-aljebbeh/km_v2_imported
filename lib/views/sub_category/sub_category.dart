import 'package:adv_image_cache/adv_image_cache.dart';
import 'package:flutter/material.dart';
import 'package:kammun_app/models/models_importer.dart';
import 'package:kammun_app/utils/utils_importer.dart';
import 'package:kammun_app/views/Widget/widgets_importer.dart';
import 'package:kammun_app/views/loading/LoadingServices.dart';
import 'package:kammun_app/views/products_view/add_products.dart';
import 'package:kammun_app/views/products_view/barcode_screen.dart';
import 'package:kammun_app/views/products_view/products_view.dart';
import 'package:responsive_flutter/responsive_flutter.dart';

// ignore: must_be_immutable
class SubCategory extends StatefulWidget {
  int heroIndex;
  static int cartCount = 0;
  List<CategoryOriginalData> subCategory = [];
  final bool forProductAdding;
  final GlobalKey<ScaffoldState> scaffoldKey;
  final String supplierCode;

  SubCategory(
      {Key key,
      this.heroIndex,
      this.subCategory,
      this.forProductAdding = false,
      this.scaffoldKey,
      this.supplierCode})
      : super(key: key);

  @override
  _SubCategoryState createState() => _SubCategoryState();
}

class _SubCategoryState extends State<SubCategory> {
  TextEditingController searchController = TextEditingController();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    void _onTileClicked(int index) {
      List<CategoryOriginalData> subCategoryList = LoadingScreenServices.categoryList
          .where((category) => category.parentCategoryId.toString() == index.toString())
          .toList();

      if (subCategoryList.isNotEmpty) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SubCategory(
              subCategory: subCategoryList,
              scaffoldKey: widget.scaffoldKey,
              forProductAdding: widget.forProductAdding,
              supplierCode: widget.supplierCode,
            ),
          ),
        );
      } else {
        if (widget.forProductAdding) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BarCodeScreen(
                requestType: BarcodeRequestType.addProduct,
                onIgnore: (barcode) {
                  int param;
                  if (barcode == null) {
                    param = null;
                  } else {
                    param = int.parse(barcode);
                  }
                  Navigator.push(
                    widget.scaffoldKey.currentContext,
                    MaterialPageRoute(
                      builder: (screenContext) => AddProductsView(
                        categoryId: index.toString(),
                        barcode: param,
                        supplierCode: widget.supplierCode,
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProductsView(
                categoryId: index.toString(),
              ),
            ),
          );
        }
      }
    }

    return Scaffold(
      key: scaffoldKey,
      appBar: PreferredSize(
        child: AppBar(
          leading: Padding(
            padding: const EdgeInsets.only(top: 8.0, right: 25),
            child: IconButton(
              icon: const Icon(
                Icons.shopping_cart,
                size: 35,
                color: Colors.white,
              ),
              onPressed: () {
                if (!widget.forProductAdding) {
                  Navigator.of(context).pushNamedAndRemoveUntil('/cart', (Route<dynamic> route) => false);
                }
              },
            ),
          ),
          backgroundColor: const Color.fromARGB(255, 210, 178, 2),
          automaticallyImplyLeading: false,
          flexibleSpace: SafeArea(
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const SizedBox(
                      width: 40,
                    ),
                    const AppBarKammunImage(),
                    Padding(
                      padding: const EdgeInsets.only(top: 5.0, left: 0),
                      child: IconButton(
                        onPressed: () => Navigator.of(context).pop(true),
                        icon: const Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.white,
                          size: 40,
                        ),
                      ),
                    ),
                  ],
                ),
                if (!widget.forProductAdding)
                  StoreSearchTextField(
                    searchController: searchController,
                    scaffoldKey: scaffoldKey,
                  ),
              ],
            ),
          ),
        ),
        preferredSize: const Size.fromHeight(105),
      ),
      body: widget.subCategory.isEmpty
          ? Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.only(left: 75.0, right: 90.0),
                child: Center(
                  child: Text("لا يوجد اصناف متوفرة حالياً، سيتم إضافة اصناف في المستقبل",
                      style: TextStyle(
                          color: ColorUtils.primaryColor,
                          fontSize: ResponsiveFlutter.of(context).fontSize(3),
                          fontWeight: FontWeight.bold,
                          fontFamily: StringUtils.fontFamilyHKGrotesk)),
                ),
              ),
            )
          : ListView.builder(
              primary: false,
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: widget.subCategory == null ? 0 : widget.subCategory.length,
              itemBuilder: (BuildContext context, int index) {
                var eachProduct = widget.subCategory[index];
//todo : add to exist widget
                return GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () => _onTileClicked(widget.subCategory[index].id),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                      side: BorderSide(
                        color: ColorUtils.kmColors,
                        width: 4.0,
                      ),
                    ),
                    elevation: 4,
                    margin: const EdgeInsets.all(10),
                    child: Column(
                      children: <Widget>[
                        Stack(
                          children: <Widget>[
                            ClipRRect(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(30),
                              ),
                              child: Image(
                                image: AdvImageCache(
                                  LoadingScreenServices.imagePrefixUrl + eachProduct.imageFileName,
                                  useMemCache: true,
                                  diskCacheExpire: const Duration(days: 400),
                                ),
                                width: MediaQuery.of(context).size.width,
                                height: MediaQuery.of(context).size.height * 0.25,
                                fit: BoxFit.cover,
                              ),
                            ),
                            ClipRRect(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(30),
                              ),
                              child: Container(
                                height: MediaQuery.of(context).size.height * 0.25,
                                width: double.infinity,
                                color: Colors.black54,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 5,
                                  horizontal: 20,
                                ),
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    eachProduct.name,
                                    style: TextStyle(
                                      fontSize: ResponsiveFlutter.of(context).fontSize(4),
                                      color: Colors.white,
                                      fontFamily: StringUtils.fontFamilyHKGrotesk,
                                    ),
                                    softWrap: true,
                                    overflow: TextOverflow.fade,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
