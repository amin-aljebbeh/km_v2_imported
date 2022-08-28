import 'package:flutter/material.dart';

class KTableRow extends StatelessWidget {
  final List<Widget> children;

  const KTableRow({Key key, @required this.children}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Table(
        border: TableBorder.all(color: Theme.of(context).primaryColor, style: BorderStyle.solid, width: 1),
        children: [TableRow(children: children)]);
  }
}
