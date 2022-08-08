import 'package:flutter/material.dart';

import '../../../core/core_importer.dart';

class BottomBarItem {
  static BottomNavigationBarItem build({IconData icon, String text, int cartCount}) {
    return BottomNavigationBarItem(
      activeIcon: Stack(
        children: [
          Column(children: [Icon(icon, color: ColorUtils.primaryColor), Text(text, style: homeActiveIconStyle)]),
          if (cartCount != null)
            Positioned(
                top: 0,
                right: 0,
                child: CircleAvatar(
                    child: Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Text(cartCount.toString(), style: mainStyle.copyWith(fontSize: 10))),
                    radius: 6,
                    backgroundColor: ColorUtils.primaryColor))
        ],
      ),
      icon: Stack(
        children: [
          Column(children: [Icon(icon, color: Colors.grey), Text(text, style: homeIconStyle)]),
          if (cartCount != null)
            Positioned(
                top: 0,
                right: 0,
                child: CircleAvatar(
                    child: Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Text(cartCount.toString(), style: mainStyle.copyWith(fontSize: 10))),
                    radius: 6,
                    backgroundColor: ColorUtils.primaryColor))
        ],
      ),
    );
  }
}
