import 'package:flutter/material.dart';
import 'package:kammun_app/models/start_models/category_model.dart';
import 'package:kammun_app/utils/tools.dart';
import 'package:kammun_app/models/start_model.dart';
import 'package:kammun_app/views/loading/LoadingServices.dart';
import 'package:kammun_app/views/products_view/products_view.dart';
import 'package:kammun_app/views/shop_by_category/shop_by_category_view.dart';
import 'package:kammun_app/views/sub_category/sub_category.dart';

class StoreViewCategory extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return StoreViewCategoryState();
  }
}

class StoreViewCategoryState extends State<StoreViewCategory> {
  double _crossAxisSpacing = 8, _mainAxisSpacing = 12, _aspectRatio = 2;
  int _crossAxisCount = 2;
  static List<CategoryOriginalData> categoryListHome =
      List<CategoryOriginalData>();

  @override
  void initState() {
    super.initState();
    setState(() {
      Tools.logToConsole("-------- the Category List value ==========");
      // Tools.logToConsole(LoadingScreenServices.categoryList);
      categoryListHome.clear();
      for (int i = 0; i < LoadingScreenServices.categoryList.length; i++) {
        if (LoadingScreenServices.categoryList[i].parentCategoryId == null) {
          categoryListHome.add(LoadingScreenServices.categoryList[i]);
        }
      }
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

            padding: EdgeInsets.only(left: 0, right: 0, top: 4, bottom: 4),
            itemCount: categoryListHome.length,

            // itemCount: categoriesListArray.length,
            physics: new NeverScrollableScrollPhysics(),
            gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: _crossAxisCount,
              crossAxisSpacing: _crossAxisSpacing,
              mainAxisSpacing: _mainAxisSpacing,
              childAspectRatio: _aspectRatio,
            ),

            itemBuilder: (BuildContext context, int index) {
              var eachCategory = categoryListHome[index];
              return new GestureDetector(
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
  }

  // Function to be called on click
  void _onTileClicked(String index) {
    Tools.logToConsole("You tapped on item $index");

    //String category_name = categoriesListArray[index]['category_name'];
    // List<Map<String, dynamic>> productsAry =
    //     categoriesListArray[index]["grocery_products"];

    List<CategoryOriginalData> subCategoryList = List<CategoryOriginalData>();

    for (int i = 0; i < LoadingScreenServices.categoryList.length; i++) {
      Tools.logToConsole(
          LoadingScreenServices.categoryList[i].parentCategoryId.toString() +
              "   ------   " +
              index);
      if (LoadingScreenServices.categoryList[i].parentCategoryId.toString() ==
          index.toString()) {
        Tools.logToConsole("added");
        subCategoryList.add(LoadingScreenServices.categoryList[i]);
      }
    }

    if (subCategoryList.length > 0) {
      Navigator.push(
        context,
        new MaterialPageRoute(
          builder: (context) => new SubCategory(
            subCategory: subCategoryList,
          ),
        ),
      );
    } else {
      Navigator.push(
        context,
        new MaterialPageRoute(
          builder: (context) => new ProductsView(
            heroIndex: int.parse(index),
            categoryId: index.toString(),
          ),
        ),
      );
    }
  }
}
