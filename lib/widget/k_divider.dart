import 'package:flutter/material.dart';

import '../core/core_importer.dart';

class KDivider extends StatelessWidget {
  const KDivider({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: ColorUtils.kmColors2,
        border: Border.all(color: Colors.white, width: 1.0),
        borderRadius: BorderRadius.circular(5.0),
      ),
      height: 5,
    );
  }
}
