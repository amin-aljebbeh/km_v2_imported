import 'package:adv_image_cache/adv_image_cache.dart';
import 'package:flutter/material.dart';
import 'package:kammun_app/models/models_importer.dart';
import 'package:kammun_app/utils/utils_importer.dart';
import 'package:kammun_app/views/widget/widgets_importer.dart';
import 'package:kammun_app/views/loading/LoadingServices.dart';
import 'package:kammun_app/views/products_view/products_view.dart';
import 'package:responsive_flutter/responsive_flutter.dart';

// ignore: must_be_immutable
class SubCategory extends StatefulWidget {
  List<CategoryOriginalData> subCategory = [];

  SubCategory({Key key, this.subCategory}) : super(key: key);

  @override
  _SubCategoryState createState() => _SubCategoryState();
}

class _SubCategoryState extends State<SubCategory> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    void _onTileClicked(int index) {
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

    return Scaffold(
      key: scaffoldKey,
      appBar: PreferredSize(
        child: AppBar(
          leading: Padding(
            padding: const EdgeInsets.only(top: 8.0, right: 25),
            child: IconButton(
              icon: const Icon(
                Icons.shopping_cart,
                size: 35,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.of(context).pushNamedAndRemoveUntil('/cart', (Route<dynamic> route) => false);
              },
            ),
          ),
          backgroundColor: const Color.fromARGB(255, 210, 178, 2),
          automaticallyImplyLeading: false,
          flexibleSpace: SafeArea(
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Opacity(
                      opacity: 0.0,
                      child: Icon(
                        Icons.home,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                    const AppBarKammunImage(),
                    Padding(
                      padding: const EdgeInsets.only(top: 5.0, left: 0),
                      child: IconButton(
                        onPressed: () => Navigator.of(context).pop(true),
                        icon: const Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.white,
                          size: 40,
                        ),
                      ),
                    ),
                  ],
                ),
                StoreSearchTextField(
                  searchController: searchController,
                  scaffoldKey: scaffoldKey,
                ),
              ],
            ),
          ),
        ),
        preferredSize: const Size.fromHeight(105),
      ),
      body: widget.subCategory.isEmpty
          ? Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.only(left: 75.0, right: 90.0),
                child: Center(
                  child: Text("لا يوجد اصناف متوفرة حالياً، سيتم إضافة اصناف في المستقبل",
                      style: TextStyle(
                          color: ColorUtils.primaryColor,
                          fontSize: ResponsiveFlutter.of(context).fontSize(3),
                          fontWeight: FontWeight.bold,
                          fontFamily: StringUtils.fontFamilyHKGrotesk)),
                ),
              ),
            )
          : SafeArea(
              child: ListView.builder(
                primary: false,
                scrollDirection: Axis.vertical,
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
                        side: BorderSide(
                          color: ColorUtils.kmColors,
                          width: 4.0,
                        ),
                      ),
                      elevation: 4,
                      margin: const EdgeInsets.all(10),
                      child: Column(
                        children: <Widget>[
                          Stack(
                            children: <Widget>[
                              ClipRRect(
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(30),
                                ),
                                child: FadeInImage(
                                  image: AdvImageCache(
                                    LoadingScreenServices.imagePrefixUrl + eachProduct.imageFileName,
                                    useMemCache: true,
                                    diskCacheExpire: const Duration(minutes: 1),
                                  ),
                                  width: MediaQuery.of(context).size.width,
                                  fadeInDuration: const Duration(seconds: 1),
                                  height: MediaQuery.of(context).size.height * 0.18,
                                  fadeInCurve: Curves.fastOutSlowIn,
                                  placeholder: const AssetImage("assets/kmlogoo.png"),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              ClipRRect(
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(30),
                                ),
                                child: Container(
                                  height: MediaQuery.of(context).size.height * 0.18,
                                  width: double.infinity,
                                  color: Colors.black54,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 5,
                                    horizontal: 20,
                                  ),
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                      eachProduct.name,
                                      style: TextStyle(
                                        fontSize: ResponsiveFlutter.of(context).fontSize(4),
                                        color: Colors.white,
                                        fontFamily: StringUtils.fontFamilyHKGrotesk,
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
  }
}
