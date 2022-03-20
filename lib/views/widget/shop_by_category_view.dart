import 'package:adv_image_cache/adv_image_cache.dart';
import 'package:flutter/material.dart';
import 'package:kammun_app/utils/utils_importer.dart';
import 'package:kammun_app/views/loading/LoadingServices.dart';
import 'package:responsive_flutter/responsive_flutter.dart';

class ShopByCategory extends StatefulWidget {
  final String img;
  final String categoryName;
  final int index;
  final BoxFit fit;

  ShopByCategory({kKey, key, @required this.img, @required this.categoryName, @required this.index, this.fit})
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
              image: widget.img != 'null'
                  ? AdvImageCache(
                      LoadingScreenServices.imagePrefixUrl + widget.img,
                      useMemCache: true,
                      diskCacheExpire: Duration(days: 400),
                    )
                  : AssetImage("assets/kmIcon.png"),
              width: MediaQuery.of(context).size.width / 2,
              fit: widget.fit,
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [0.2, 0.7],
                  colors: [
                    Color.fromARGB(100, 0, 0, 0),
                    Color.fromARGB(100, 0, 0, 0),
                  ],
                ),
              ),
              width: MediaQuery.of(context).size.width / 2,
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
                        fontFamily: StringUtils.fontFamilyHKGrotesk,
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
