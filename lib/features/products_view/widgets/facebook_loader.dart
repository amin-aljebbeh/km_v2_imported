import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class FacebookLoader extends StatelessWidget {
  const FacebookLoader({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300],
        highlightColor: Colors.grey[100],
        enabled: true,
        child: ListView(
          shrinkWrap: true,
          children: List.generate(10, (_) {
            return Flex(
              crossAxisAlignment: CrossAxisAlignment.center,
              direction: Axis.horizontal,
              children: [
                Container(
                    width: 80.0,
                    height: 80.0,
                    color: Colors.white,
                    margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                          width: double.infinity,
                          height: 8.0,
                          color: Colors.white,
                          margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 2)),
                      Container(
                          width: double.infinity,
                          height: 8.0,
                          color: Colors.white,
                          margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 2)),
                      Container(width: 40.0, height: 8.0, color: Colors.white),
                    ],
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
