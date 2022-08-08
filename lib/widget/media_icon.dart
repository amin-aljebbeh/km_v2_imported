import 'package:flutter/material.dart';
import 'package:kammun_app/core/core_importer.dart';

class MediaIcon extends StatelessWidget {
  final IconData icon;
  final String url;

  const MediaIcon({Key key, @required this.icon, @required this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () => Services.openUrl(selected: url), child: Icon(icon, color: ColorUtils.primaryColor, size: 30));
  }
}
