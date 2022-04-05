import 'package:flutter/material.dart';
import 'package:kammun_app/models/models_importer.dart';
import 'package:kammun_app/views/widget/widgets_importer.dart';
import 'package:kammun_app/views/loading/loading_services.dart';
import 'package:kammun_app/views/products_view/products_view.dart';
import 'package:kammun_app/views/sub_category/sub_category.dart';

class StoreViewCategory extends StatefulWidget {
  const StoreViewCategory({Key key}) : super(key: key);

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
      for (int i = 0; i < LoadingScreenServices.categoryList.length; i++) {
        if (LoadingScreenServices.categoryList[i].parentCategoryId == 'null') {
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
    List<CategoryOriginalData> subCategoryList = [];

    for (int i = 0; i < LoadingScreenServices.categoryList.length; i++) {
      if (LoadingScreenServices.categoryList[i].parentCategoryId.toString() == index.toString()) {
        subCategoryList.add(LoadingScreenServices.categoryList[i]);
      }
    }

    if (subCategoryList.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SubCategory(
            subCategory: subCategoryList,
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
