import 'package:adv_image_cache/adv_image_cache.dart';
import 'package:flutter/material.dart';

class KCacheImage extends StatelessWidget {
  final int tag;
  final String image;

  const KCacheImage({
    Key key,
    @required this.tag,
    @required this.image,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100.0,
      height: 100.0,
      decoration: new BoxDecoration(
          borderRadius: new BorderRadius.all(Radius.circular(20.0))),
      child: Hero(
        tag: tag,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Image(
            fit: BoxFit.contain,
            image: image.length > 0
                ? AdvImageCache(
                    image,
                    useMemCache: true,
                    diskCacheExpire: Duration(days: 400),
                  )
                : AssetImage("assets/kmIcon.png"),
            width: MediaQuery.of(context).size.width,
            height: 120,
          ),
        ),
      ),
    );
  }
}
