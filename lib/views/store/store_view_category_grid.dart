import 'package:flutter/material.dart';
import 'package:kammun_app/models/models_importer.dart';
import 'package:kammun_app/views/widget/widgets_importer.dart';
import 'package:kammun_app/views/loading/LoadingServices.dart';
import 'package:kammun_app/views/products_view/products_view.dart';
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
  static List<CategoryOriginalData> categoryListHome = List<CategoryOriginalData>();

  @override
  void initState() {
    super.initState();
    setState(() {
      categoryListHome.clear();
      categoryListHome =
          LoadingScreenServices.categoryList.where((category) => category.parentCategoryId == null).toList();
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
    List<CategoryOriginalData> subCategoryList = LoadingScreenServices.categoryList
        .where((category) => category.parentCategoryId.toString() == index.toString())
        .toList();

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
            categoryId: index.toString(),
          ),
        ),
      );
    }
  }
}
