import 'package:responsive_flutter/responsive_flutter.dart';

import '../core_importer.dart';

class ShopByCategory extends StatelessWidget {
  final String img;
  final String categoryName;
  final int index;
  final BoxFit fit;

  const ShopByCategory({kKey, key, @required this.img, @required this.categoryName, @required this.index, this.fit})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 2, left: 2),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: Stack(
          children: <Widget>[
            Image(
              image: img != 'null'
                  ? AdvImageCache(StaticVariables.imagePrefixUrl + img,
                      useMemCache: true, diskCacheExpire: const Duration(days: 400))
                  : const AssetImage("assets/kmIcon.png"),
              width: MediaQuery.of(context).size.width / 2,
              fit: fit,
            ),
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [0.2, 0.7],
                  colors: [Color.fromARGB(100, 0, 0, 0), Color.fromARGB(100, 0, 0, 0)],
                ),
              ),
              width: MediaQuery.of(context).size.width / 2,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Center(
                  child: Hero(
                    tag: index,
                    child: Text(
                      categoryName,
                      style: mainStyle.copyWith(
                        color: Colors.white,
                        fontSize: ResponsiveFlutter.of(context).fontSize(3),
                        fontWeight: FontWeight.bold,
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
