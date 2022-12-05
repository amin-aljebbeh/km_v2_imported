import '../../../core/core_importer.dart';

class BottomBarItem {
  static BottomNavigationBarItem build({IconData icon, String text}) {
    return BottomNavigationBarItem(
      activeIcon: Stack(
        children: [
          Column(children: [Icon(icon, color: kmColors), Text(text, style: homeActiveIconStyle)])
        ],
      ),
      icon: Stack(
        children: [
          Column(children: [Icon(icon, color: primaryColor), Text(text, style: homeIconStyle)])
        ],
      ),
      label: '',
    );
  }
}
