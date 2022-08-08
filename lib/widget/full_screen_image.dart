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
        child: Center(child: Hero(tag: tag, child: Image(image: NetworkImage(imageUrl)))),
        onTap: () => Navigator.pop(context),
      ),
    );
  }
}
