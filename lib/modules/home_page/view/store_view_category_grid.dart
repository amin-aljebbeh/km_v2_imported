import 'package:flutter/material.dart';

import '../../../core/core_importer.dart';
import '../../products/view/products_view.dart';

class StoreViewCategory extends StatefulWidget {
  const StoreViewCategory({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return StoreViewCategoryState();
  }
}

class StoreViewCategoryState extends State<StoreViewCategory> {
  static List<CategoryModel> categoryListHome = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      categoryListHome = [];
      categoryListHome.addAll(StoreProvider.of<AppState>(context)
          .state
          .startupState
          .startModel
          .categories
          .where((category) => category.parentCategoryId == -1)
          .toList());
    });
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      builder: (context, state) {
        return SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: Column(
            children: <Widget>[
              GridView.builder(
                primary: false,
                shrinkWrap: true, // use it

                padding: const EdgeInsets.only(left: 0, right: 0, top: 4, bottom: 4),
                itemCount: categoryListHome.length,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 12,
                  childAspectRatio: 2,
                ),

                itemBuilder: (BuildContext context, int index) {
                  var eachCategory = categoryListHome[index];
                  return GestureDetector(
                    onTap: () => _onTileClicked(eachCategory.id.toString()),
                    child: ShopByCategory(
                      img: eachCategory.imageFileName,
                      categoryName: eachCategory.name,
                      index: index,
                    ),
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
  void _onTileClicked(String index) {
    List<CategoryModel> subCategoryList = [];

    List<CategoryModel> categoryList =
        StoreProvider.of<AppState>(context).state.startupState.startModel.categories;
    for (int i = 0; i < categoryList.length; i++) {
      if (categoryList[i].parentCategoryId.toString() == index.toString()) {
        subCategoryList.add(categoryList[i]);
      }
    }

    if (subCategoryList.isNotEmpty) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => SubCategory(subCategory: subCategoryList)));
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              ProductsView(productsViewType: ProductsViewTypes.category, categoryId: index.toString()),
        ),
      );
    }
  }
}
