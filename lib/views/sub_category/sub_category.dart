import 'package:adv_image_cache/adv_image_cache.dart';
import 'package:flutter/material.dart';
import 'package:kammun_app/utils/tools.dart';
import 'package:kammun_app/models/start_model.dart';
import 'package:kammun_app/utils/utils_importer.dart';
import 'package:kammun_app/views/loading/LoadingServices.dart';
import 'package:kammun_app/views/products_view/products_view.dart';
import 'package:responsive_flutter/responsive_flutter.dart';

// ignore: must_be_immutable
class SubCategory extends StatefulWidget {
  int heroIndex;
  static int cartCount = 0;
  //String category_name;
  List<CategoryOriginalData> subCategory = [];

  SubCategory({this.heroIndex, this.subCategory});

  @override
  _SubCategoryState createState() => _SubCategoryState();
}

class _SubCategoryState extends State<SubCategory> {
  TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    void _onTileClicked(int index) {
      List<CategoryOriginalData> subCategoryList = List<CategoryOriginalData>();

      for (int i = 0; i < LoadingScreenServices.categoryList.length; i++) {
        Tools.logToConsole(
            LoadingScreenServices.categoryList[i].parentCategoryId.toString() +
                "   ------   " +
                index.toString());
        if (LoadingScreenServices.categoryList[i].parentCategoryId.toString() ==
            index.toString()) {
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
              heroIndex: (index),
              categoryId: index.toString(),
            ),
          ),
        );
      }
    }

    Widget _showSearchTxtFld() {
      final GestureDetector searchButtonWithGesture = new GestureDetector(
        child: Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
          child: new Container(
            height: 40.0,
            decoration: new BoxDecoration(
                color: Colors.white,
                borderRadius: new BorderRadius.all(Radius.circular(6.0))),
            child: TextField(
              controller: _searchController,
              onSubmitted: (_) {
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (context) => new ProductsView(
                              queryString: _searchController.text,
                              categoryId: "0",
                            )));
              },
              cursorColor: UtilsImporter().colorUtils.primaryColor,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search),
                contentPadding: const EdgeInsets.only(bottom: 0.5),
                hintText: "بحث",
                hintStyle: TextStyle(
                  fontFamily: UtilsImporter().stringUtils.HKGrotesk,
                ),
              ),
            ),
          ),
        ),
      );

      return new Padding(
          padding: EdgeInsets.only(left: 0.0, right: 0.0, top: 5.0),
          child: searchButtonWithGesture);
    }

    return Scaffold(
      appBar: PreferredSize(
        child: AppBar(
          leading: Padding(
            padding: const EdgeInsets.only(top: 8.0, right: 25),
            child: IconButton(
              icon: Icon(
                Icons.shopping_cart,
                size: 35,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.of(context).pushNamedAndRemoveUntil(
                    '/cart', (Route<dynamic> route) => false);
              },
            ),
          ),

          backgroundColor: Color.fromARGB(255, 210, 178, 2),
          automaticallyImplyLeading: false,
          // hides leading widget

          flexibleSpace: SafeArea(
            // top: true,
            // left: false,
            // bottom: false,
            // right: false,
            child: Column(
              children: <Widget>[
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Opacity(
                        opacity: 0.0,
                        child: Icon(
                          Icons.home,
                          color: Colors.white,
                          size: 40,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 5.0),
                        child: Transform.scale(
                          scale: 2,
                          child: InkWell(
                            onTap: () {
                              Navigator.pushNamedAndRemoveUntil(
                                context,
                                '/home',
                                (Route<dynamic> route) => false,
                              );
                            },
                            child: Image.asset(
                              "assets/logobw.png",
                              width: 150,
                              height: 50,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                          padding: const EdgeInsets.only(top: 5.0, left: 0),
                          child: IconButton(
                              onPressed: () => Navigator.of(context).pop(true),
                              icon: Icon(
                                Icons.arrow_forward_ios,
                                color: Colors.white,
                                size: 40,
                              ))),
                    ]),
                _showSearchTxtFld(),
              ],
            ),
          ),
        ),
        preferredSize: Size.fromHeight(105),
      ),
      body: widget.subCategory.length == 0
          ? Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.only(left: 75.0, right: 90.0),
                child: Center(
                  child: Text(
                      "لا يوجد اصناف متوفرة حالياً، سيتم إضافة اصناف في المستقبل",
                      style: TextStyle(
                          color: UtilsImporter().colorUtils.primaryColor,
                          fontSize: ResponsiveFlutter.of(context).fontSize(3),
                          fontWeight: FontWeight.bold,
                          fontFamily: UtilsImporter().stringUtils.HKGrotesk)),
                ),
              ),
            )
          : ListView.builder(
              primary: false,
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount:
                  widget.subCategory == null ? 0 : widget.subCategory.length,
              itemBuilder: (BuildContext context, int index) {
                var eachProduct = widget.subCategory[index];

                return new GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () => _onTileClicked(widget.subCategory[index].id),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                      side: BorderSide(
                        color: UtilsImporter().colorUtils.kmColors,
                        width: 4.0,
                      ),
                    ),
                    elevation: 4,
                    margin: EdgeInsets.all(10),
                    child: Column(
                      children: <Widget>[
                        Stack(
                          children: <Widget>[
                            ClipRRect(
                              borderRadius: BorderRadius.all(
                                Radius.circular(30),
                              ),
                              child: Image(
                                image: AdvImageCache(
                                  LoadingScreenServices.imagePrefixUrl +
                                      eachProduct.imageFileName,
                                  useMemCache: true,
                                  diskCacheExpire: Duration(days: 400),
                                ),
                                width: MediaQuery.of(context).size.width,
                                //fadeInDuration: const Duration(microseconds: 1),
                                height:
                                    MediaQuery.of(context).size.height * 0.25,
                                // fadeInCurve: Curves.fastOutSlowIn,
                                // fadeInCurve: Curves.fastOutSlowIn,

                                // placeholder: AssetImage("assets/kmlogoo.png"),
                                fit: BoxFit.cover,
                              ),

                              // Image.asset(
                              //   eachProduct.image_file_name,
                              //   height: 150,
                              //   width: double.infinity,
                              //   fit: BoxFit.cover,
                              // ),
                            ),
                            ClipRRect(
                              borderRadius: BorderRadius.all(
                                Radius.circular(30),
                              ),
                              child: Container(
                                // width: double.infinity,
                                //  height: ,
                                //constraints: BoxConstraints.expand(),
                                height:
                                    MediaQuery.of(context).size.height * 0.25,
                                width: double.infinity,
                                color: Colors.black54,
                                padding: EdgeInsets.symmetric(
                                  vertical: 5,
                                  horizontal: 20,
                                ),
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    eachProduct.name,
                                    style: TextStyle(
                                      fontSize: ResponsiveFlutter.of(context)
                                          .fontSize(4),
                                      color: Colors.white,
                                      fontFamily:
                                          UtilsImporter().stringUtils.HKGrotesk,
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
    );
  }
}
