import 'package:adv_image_cache/adv_image_cache.dart';
import 'package:flutter/material.dart';
import 'package:responsive_flutter/responsive_flutter.dart';

import '../../../core/core_importer.dart';
import '../../products/view/products_view.dart';

class SubCategory extends StatefulWidget {
  final List<CategoryModel> subCategory;

  const SubCategory({Key key, this.subCategory}) : super(key: key);

  @override
  _SubCategoryState createState() => _SubCategoryState();
}

class _SubCategoryState extends State<SubCategory> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    void _onTileClicked(int index) {
      List<CategoryModel> subCategoryList = [];
      List<CategoryModel> categoryList = StoreProvider.of<AppState>(context).state.startupState.startModel.categories;
      for (int i = 0; i < categoryList.length; i++) {
        if (categoryList[i].parentCategoryId.toString() == index.toString()) {
          subCategoryList.add(categoryList[i]);
        }
      }

      if (subCategoryList.isNotEmpty) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SubCategory(subCategory: subCategoryList),
          ),
        );
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductsView(
              productsViewType: ProductsViewTypes.category,
              categoryId: index.toString(),
            ),
          ),
        );
      }
    }

    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      builder: (context, state) {
        return Scaffold(
          key: scaffoldKey,
          appBar: KAppBar(searchController: searchController, scaffoldKey: scaffoldKey),
          body: widget.subCategory.isEmpty
              ? Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 75.0, right: 90.0),
                    child: Center(
                      child: Text('لا يوجد اصناف متوفرة حالياً، سيتم إضافة اصناف في المستقبل',
                          style: TextStyle(
                              color: ColorUtils.primaryColor,
                              fontSize: ResponsiveFlutter.of(context).fontSize(3),
                              fontWeight: FontWeight.bold,
                              fontFamily: StringUtils.fontFamily)),
                    ),
                  ),
                )
              : SafeArea(
                  child: ListView.builder(
                    primary: false,
                    scrollDirection: Axis.vertical,
                    physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
                    shrinkWrap: true,
                    itemCount: widget.subCategory == null ? 0 : widget.subCategory.length,
                    itemBuilder: (BuildContext context, int index) {
                      var eachProduct = widget.subCategory[index];

                      return GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () => _onTileClicked(widget.subCategory[index].id),
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                            side: BorderSide(color: ColorUtils.kmColors, width: 4.0),
                          ),
                          elevation: 4,
                          margin: const EdgeInsets.all(10),
                          child: Column(
                            children: <Widget>[
                              Stack(
                                children: <Widget>[
                                  ClipRRect(
                                    borderRadius: const BorderRadius.all(Radius.circular(30)),
                                    child: FadeInImage(
                                      image: AdvImageCache(
                                        state.startupState.startModel.company.imageBaseUrl + eachProduct.imageFileName,
                                        useMemCache: true,
                                        diskCacheExpire: const Duration(days: 100),
                                      ),
                                      width: MediaQuery.of(context).size.width,
                                      fadeInDuration: const Duration(seconds: 1),
                                      height: MediaQuery.of(context).size.height * 0.18,
                                      fadeInCurve: Curves.fastOutSlowIn,
                                      placeholder: const AssetImage('assets/kmlogoo.png'),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  ClipRRect(
                                    borderRadius: const BorderRadius.all(Radius.circular(30)),
                                    child: Container(
                                      height: MediaQuery.of(context).size.height * 0.18,
                                      width: double.infinity,
                                      color: Colors.black54,
                                      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: Text(
                                          eachProduct.name,
                                          style: TextStyle(
                                            fontSize: ResponsiveFlutter.of(context).fontSize(4),
                                            color: Colors.white,
                                            fontFamily: StringUtils.fontFamily,
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
                ),
        );
      },
    );
  }
}
