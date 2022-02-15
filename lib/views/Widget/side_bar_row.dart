import 'package:flutter/material.dart';
import 'package:kammun_app/utils/utils_importer.dart';

class SideBarRow extends StatelessWidget {
  final IconData icon;
  final String text;
  final Function onTap;

  const SideBarRow({
    Key key,
    @required this.icon,
    @required this.text,
    @required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Icon(
          icon,
          color: ColorUtils.primaryColor,
          size: 30,
        ),
      ),
      title: Text(
        text,
        style: mainStyle,
      ),
      onTap: onTap,
    );
  }
}
