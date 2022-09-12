import 'package:flutter/material.dart';
import 'package:kammun_app/utils/utils_importer.dart';

import '../../service.dart';

class MediaIcon extends StatelessWidget {
  final IconData icon;
  final String url;
  final String mobileNumber;

  const MediaIcon({Key key, @required this.icon, @required this.url, this.mobileNumber = ''}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Services.openUrl(url, mobileNumber: mobileNumber),
      child: Icon(icon, color: url == 'customer_whatsapp' ? kmColors : primaryColor, size: 30),
    );
  }
}
