import 'package:responsive_flutter/responsive_flutter.dart';

import '../../../core/core_importer.dart';
import '../../general_information/domain/entities/category_entity.dart';
import '../../products/presentation/pages/products_page.dart';
import '../../products/presentation/redux/products_action.dart';
import '../../products_view/pages/add_products.dart';
import '../../barcode/presentation/pages/barcode_scanner_page.dart';
import '../pages/sub_category.dart';

class SubCategoryWidget extends StatelessWidget {
  final CategoryEntity subCategory;
  final bool forProductAdding;
  final GlobalKey<ScaffoldState> scaffoldKey;
  final String supplierCode;

  const SubCategoryWidget({Key key, this.subCategory, this.forProductAdding, this.scaffoldKey, this.supplierCode})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => _onTileClicked(subCategory.id, context),
      child: Card(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30), side: BorderSide(color: kmColors, width: 4.0)),
        elevation: 4,
        margin: const EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            Stack(
              children: <Widget>[
                ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(30)),
                  child: Image(
                    image: AdvImageCache(
                      StaticVariables.imagePrefixUrl + subCategory.imageFileName,
                      useMemCache: true,
                      diskCacheExpire: const Duration(days: 400),
                    ),
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.25,
                    fit: BoxFit.cover,
                  ),
                ),
                ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(30)),
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.25,
                    width: double.infinity,
                    color: Colors.black54,
                    padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        subCategory.name,
                        style: mainStyle.copyWith(
                            fontSize: ResponsiveFlutter.of(context).fontSize(4), color: Colors.white),
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
  }

  void _onTileClicked(int index, BuildContext context) {
    List<CategoryEntity> subCategoryList = StoreProvider.of<AppState>(context)
        .state
        .generalInformationState
        .categories
        .where((category) => category.parentCategoryId.toString() == index.toString())
        .toList();

    if (subCategoryList.isNotEmpty) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => SubCategory(
                  subCategory: subCategoryList,
                  scaffoldKey: scaffoldKey,
                  forProductAdding: forProductAdding,
                  supplierCode: supplierCode)));
    } else {
      if (forProductAdding) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BarcodeScannerPage(
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
                            AddProductsView(categoryId: index, barcode: param, supplierCode: supplierCode)));
              },
            ),
          ),
        );
      } else {
        StoreProvider.of<AppState>(context).dispatch(InitProducts());
        StoreProvider.of<AppState>(context)
            .dispatch(SetProductsViewTypes(productsViewTypes: ProductsViewTypes.category));
        StoreProvider.of<AppState>(context).dispatch(SetCategoryId(categoryId: index));
        StoreProvider.of<AppState>(context).dispatch(GetProductsAction());
        Navigator.push(context, MaterialPageRoute(builder: (context) => const ProductsPage()));
      }
    }
  }
}
