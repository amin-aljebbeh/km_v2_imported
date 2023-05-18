import 'package:kammun_app/features/products_view/add_products.dart';
import 'package:kammun_app/features/products_view/barcode_screen.dart';
import 'package:kammun_app/features/products_view/products_view.dart';
import 'package:kammun_app/features/sub_category/sub_category.dart';

import '../../core/core_importer.dart';

class StoreViewCategory extends StatelessWidget {
  final String supplierCode;
  final bool forProductAdding;
  final GlobalKey<ScaffoldState> scaffoldKey;

  const StoreViewCategory({Key key, this.forProductAdding = false, this.scaffoldKey, this.supplierCode})
      : super(key: key);
  final double _crossAxisSpacing = 8, _mainAxisSpacing = 12, _aspectRatio = 2;
  final int _crossAxisCount = 2;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          GridView.builder(
            primary: false,
            shrinkWrap: true,
            padding: const EdgeInsets.only(left: 0, right: 0, top: 4, bottom: 4),
            itemCount:
                StaticVariables.categoryList.where((category) => category.parentCategoryId == 'null').toList().length,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: _crossAxisCount,
                crossAxisSpacing: _crossAxisSpacing,
                mainAxisSpacing: _mainAxisSpacing,
                childAspectRatio: _aspectRatio),
            itemBuilder: (BuildContext context, int index) {
              var eachCategory =
                  StaticVariables.categoryList.where((category) => category.parentCategoryId == 'null').toList()[index];
              return GestureDetector(
                onTap: () => _onTileClicked(eachCategory.id.toString(), context),
                child: ShopByCategory(
                    img: eachCategory.imageFileName, categoryName: eachCategory.name, index: index, fit: BoxFit.cover),
              );
            },
          ),
        ],
      ),
    );
  }

  // Function to be called on click
  void _onTileClicked(String index, BuildContext context) {
    List<CategoryOriginalData> subCategoryList = StaticVariables.categoryList
        .where((category) => category.parentCategoryId.toString() == index.toString())
        .toList();

    if (subCategoryList.isNotEmpty) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => SubCategory(
                  subCategory: subCategoryList,
                  forProductAdding: forProductAdding,
                  scaffoldKey: scaffoldKey,
                  supplierCode: supplierCode)));
    } else {
      if (forProductAdding) {
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
                  scaffoldKey.currentContext,
                  MaterialPageRoute(
                    builder: (screenContext) =>
                        AddProductsView(categoryId: index, barcode: param, supplierCode: supplierCode),
                  ),
                );
              },
            ),
          ),
        );
      } else {
        Navigator.push(context, MaterialPageRoute(builder: (context) => ProductsView(categoryId: index)));
      }
    }
  }
}
