import 'package:flutter/material.dart';

class KCacheImage extends StatelessWidget {
  final Object tag;
  final String image;

  const KCacheImage({Key key, @required this.tag, @required this.image}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100.0,
      height: 100.0,
      decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(20.0))),
      child: Hero(
        tag: tag,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Image(
            fit: BoxFit.contain,
            image: image.isNotEmpty
                ? NetworkImage(image)
                : const AssetImage('assets/kmIcon.png'),
            width: MediaQuery.of(context).size.width,
            height: 120,
          ),
        ),
      ),
    );
  }
}
