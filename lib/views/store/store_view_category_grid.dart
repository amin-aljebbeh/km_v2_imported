import 'package:adv_image_cache/adv_image_cache.dart';
import 'package:flutter/material.dart';
import 'package:kammun_app/models/start_model.dart';
import 'package:kammun_app/utils/utils_importer.dart';
import 'package:kammun_app/views/loading/LoadingServices.dart';
import 'package:kammun_app/views/products_view/products_view.dart';
import 'package:kammun_app/views/sub_category/sub_category.dart';
import 'package:responsive_flutter/responsive_flutter.dart';

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
      for (int i = 0; i < LoadingScreenServices.categoryList.length; i++) {
        if (LoadingScreenServices.categoryList[i].parentCategoryId == null) {
          categoryListHome.add(LoadingScreenServices.categoryList[i]);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // for (int i = 0; i < categoryListHome.length; i++) {
    // }
    // double screenWidth = MediaQuery.of(context).size.width;

    // // var width = (screenWidth - ((_crossAxisCount - 1) * _crossAxisSpacing)) /
    // //     _crossAxisCount;
    // // //var height = (width / _aspectRatio) * categoryListHome.length / 1.75;
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
    //String category_name = categoriesListArray[index]['category_name'];
    // List<Map<String, dynamic>> productsAry =
    //     categoriesListArray[index]["grocery_products"];

    List<CategoryOriginalData> subCategoryList = List<CategoryOriginalData>();

    for (int i = 0; i < LoadingScreenServices.categoryList.length; i++) {
      if (LoadingScreenServices.categoryList[i].parentCategoryId.toString() == index.toString()) {
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

class ShopByCategory extends StatefulWidget {
  final String img;
  final String categoryName;
  final int index;

  ShopByCategory({Key, key, @required this.img, @required this.categoryName, @required this.index})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ShopByCategoryState();
  }
}

class ShopByCategoryState extends State<ShopByCategory> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 2, left: 2),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: Stack(
          children: <Widget>[
            FadeInImage(
              image: AdvImageCache(
                LoadingScreenServices.imagePrefixUrl + widget.img,
                useMemCache: true,
                diskCacheExpire: Duration(minutes: 1),
              ),
              width: MediaQuery.of(context).size.width,
              fadeInDuration: const Duration(seconds: 1),
              // fadeInCurve: Curves.fastOutSlowIn,
              fadeInCurve: Curves.fastOutSlowIn,

              placeholder: AssetImage("assets/kmlogoo.png"),
              fit: BoxFit.cover,
            ),
            // Image.network(
            //   widget.img,
            //   width: MediaQuery.of(context).size.width / 2,
            //   fit: BoxFit.cover,
            // ),
            // Image.asset(
            //   widget.img,
            //   width: MediaQuery.of(context).size.width / 2,
            //   height: 120,
            //   fit: BoxFit.cover,
            // ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  // Add one stop for each color. Stops should increase from 0 to 1
                  stops: [0.2, 0.7],
                  colors: [
                    Color.fromARGB(100, 0, 0, 0),
                    Color.fromARGB(100, 0, 0, 0),
                  ],
                  // stops: [0.0, 0.1],
                ),
              ),
              width: MediaQuery.of(context).size.width / 2,
              // height: ,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Center(
                  child: Hero(
                    tag: widget.index,
                    child: Text(
                      widget.categoryName,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: ResponsiveFlutter.of(context).fontSize(3),
                        fontWeight: FontWeight.bold,
                        fontFamily: UtilsImporter().stringUtils.fontFamilyHKGrotesk,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
