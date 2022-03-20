import 'package:flutter/material.dart';
import 'package:kammun_app/utils/utils_importer.dart';

import '../../Services.dart';

class MediaIcon extends StatelessWidget {
  final IconData icon;
  final String url;
  final String mobileNumber;

  MediaIcon({Key key, @required this.icon, @required this.url, this.mobileNumber = ''}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return IconButton(
      padding: EdgeInsets.all(0),
      onPressed: () => Services.openUrl(url, mobileNumber: mobileNumber),
      icon: Icon(
        icon,
        color: url == 'customer_whatsapp' ? ColorUtils.kmColors : ColorUtils.primaryColor,
        size: 30,
      ),
    );
  }
}
