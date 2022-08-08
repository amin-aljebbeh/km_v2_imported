import 'package:flutter/material.dart';
import '../core/core_importer.dart';

class PopArrow extends StatelessWidget {
  final Color color;
  const PopArrow({Key key, this.color = Colors.white}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => StoreProvider.of<AppState>(context).dispatch(Pop(returnValue: true)),
      child: Icon(Icons.arrow_back_ios, color: color, size: 40),
    );
  }
}
