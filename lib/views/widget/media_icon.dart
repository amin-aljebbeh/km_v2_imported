import 'package:flutter/material.dart';
import 'package:kammun_app/utils/utils_importer.dart';

import '../../service.dart';

class MediaIcon extends StatelessWidget {
  final IconData icon;
  final String url;

  const MediaIcon({Key key, @required this.icon, @required this.url}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Services.openUrl(url),
      child: Icon(
        icon,
        color: ColorUtils.primaryColor,
        size: 30,
      ),
    );
  }
}
