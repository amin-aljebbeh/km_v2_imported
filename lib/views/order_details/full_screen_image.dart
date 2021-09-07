import 'package:adv_image_cache/adv_image_cache.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FullScreenImage extends StatelessWidget {
  final String imageUrl;
  final String tag;

  const FullScreenImage({Key key, this.imageUrl, this.tag}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: GestureDetector(
        child: Center(
          child: Hero(
              tag: tag,
              child: FadeInImage(
                fadeInCurve: Curves.fastOutSlowIn,
                placeholder: AssetImage("assets/kmIcon.png"),
                // fit: BoxFit.fitWidth,
                image: AdvImageCache(
                  imageUrl,
                  useMemCache: true,
                  diskCacheExpire: Duration(minutes: 1),
                ),
             //   width: MediaQuery.of(context).size.width,
              //  height: 120,
              )
              //  CachedNetworkImage(
              //   width: MediaQuery.of(context).size.width,
              //   fit: BoxFit.contain,
              //   imageUrl: imageUrl,
              // ),
              ),
        ),
        onTap: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}
