import 'package:flutter/material.dart';
import 'package:kammun_app/utils/utils_importer.dart';

class ManagementView extends StatelessWidget {
  final List<Widget> children;
  final String title;

  const ManagementView({Key key, this.children, this.title}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
          style: mainStyle,
        ),
      ),
      body: SafeArea(
        child: Column(
          children: children,
        ),
      ),
    );
  }
}
