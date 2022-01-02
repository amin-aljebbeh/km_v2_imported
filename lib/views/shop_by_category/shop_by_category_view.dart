import 'package:adv_image_cache/adv_image_cache.dart';
import 'package:flutter/material.dart';
import 'package:kammun_app/utils/new_utils_importer.dart';
import 'package:kammun_app/views/loading/LoadingServices.dart';
import 'package:responsive_flutter/responsive_flutter.dart';

class ShopByCategory extends StatefulWidget {
  final String img;
  final String categoryName;
  final int index;

  ShopByCategory(
      {Key,
      key,
      @required this.img,
      @required this.categoryName,
      @required this.index})
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
            Image(
              image: AdvImageCache(
                LoadingScreenServices.imagePrefixUrl + widget.img,
                useMemCache: true,
                diskCacheExpire: Duration(days: 400),
              ),
              width: MediaQuery.of(context).size.width / 2,
              fit: BoxFit.cover,
            ),
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
                        fontFamily: StringUtils.HKGrotesk,
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
