import 'package:flutter/material.dart';
import 'package:kammun_app/models/models_importer.dart';
import 'package:kammun_app/utils/utils_importer.dart';
import 'package:kammun_app/views/loading/loading_services.dart';
import 'package:kammun_app/views/products_view/add_products.dart';
import 'package:kammun_app/views/products_view/barcode_screen.dart';
import 'package:kammun_app/views/products_view/products_view.dart';
import 'package:kammun_app/views/sub_category/sub_category.dart';
import 'package:kammun_app/views/widget/widgets_importer.dart';

class StoreViewCategory extends StatefulWidget {
  final String supplierCode;
  final bool forProductAdding;
  final GlobalKey<ScaffoldState> scaffoldKey;

  const StoreViewCategory({Key key, this.forProductAdding = false, this.scaffoldKey, this.supplierCode})
      : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return StoreViewCategoryState();
  }
}

class StoreViewCategoryState extends State<StoreViewCategory> {
  final double _crossAxisSpacing = 8, _mainAxisSpacing = 12, _aspectRatio = 2;
  final int _crossAxisCount = 2;
  static List<CategoryOriginalData> categoryListHome = [];

  @override
  void initState() {
    super.initState();
    setState(() {
      categoryListHome.clear();
      categoryListHome =
          LoadingScreenServices.categoryList.where((category) => category.parentCategoryId == 'null').toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          GridView.builder(
            primary: false,
            shrinkWrap: true, // use it

            padding: const EdgeInsets.only(left: 0, right: 0, top: 4, bottom: 4),
            itemCount: categoryListHome.length,

            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: _crossAxisCount,
              crossAxisSpacing: _crossAxisSpacing,
              mainAxisSpacing: _mainAxisSpacing,
              childAspectRatio: _aspectRatio,
            ),

            itemBuilder: (BuildContext context, int index) {
              var eachCategory = categoryListHome[index];
              return GestureDetector(
                onTap: () => _onTileClicked(eachCategory.id.toString()),
                child: ShopByCategory(
                  img: eachCategory.imageFileName,
                  categoryName: eachCategory.name,
                  index: index,
                  fit: BoxFit.cover,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // Function to be called on click
  void _onTileClicked(String index) {
    List<CategoryOriginalData> subCategoryList = LoadingScreenServices.categoryList
        .where((category) => category.parentCategoryId.toString() == index.toString())
        .toList();

    if (subCategoryList.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SubCategory(
            subCategory: subCategoryList,
            forProductAdding: widget.forProductAdding,
            scaffoldKey: widget.scaffoldKey,
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
                      categoryId: index,
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
              categoryId: index,
            ),
          ),
        );
      }
    }
  }
}
