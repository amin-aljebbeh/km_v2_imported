import 'package:kammun_app/features/barcode/presentation/pages/barcode_scanner_page.dart';
import 'package:kammun_app/features/products_view/pages/add_products.dart';

import '../../../core/core_importer.dart';
import '../../general_information/domain/entities/category_entity.dart';
import '../../products/presentation/pages/products_page.dart';
import '../../products/presentation/redux/products_action.dart';
import '../../sub_category/pages/sub_category.dart';

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
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      distinct: true,
      builder: (context, state) {
        return SingleChildScrollView(
          child: Column(
            children: <Widget>[
              GridView.builder(
                primary: false,
                shrinkWrap: true,
                padding: const EdgeInsets.only(left: 0, right: 0, top: 4, bottom: 4),
                itemCount: state.generalInformationState.categories
                    .where((category) => category.parentCategoryId == 'null')
                    .toList()
                    .length,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: _crossAxisCount,
                    crossAxisSpacing: _crossAxisSpacing,
                    mainAxisSpacing: _mainAxisSpacing,
                    childAspectRatio: _aspectRatio),
                itemBuilder: (BuildContext context, int index) {
                  var eachCategory = state.generalInformationState.categories
                      .where((category) => category.parentCategoryId == 'null')
                      .toList()[index];
                  return GestureDetector(
                    onTap: () => _onTileClicked(eachCategory.id, context),
                    child: ShopByCategory(
                        img: eachCategory.imageFileName,
                        categoryName: eachCategory.name,
                        index: index,
                        fit: BoxFit.cover),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // Function to be called on click
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
                  forProductAdding: forProductAdding,
                  scaffoldKey: scaffoldKey,
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
                        AddProductsView(categoryId: index, barcode: param, supplierCode: supplierCode),
                  ),
                );
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
