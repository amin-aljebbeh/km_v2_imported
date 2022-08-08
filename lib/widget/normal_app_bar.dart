import 'package:flutter/material.dart';

import '../core/core_importer.dart';

class NormalAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool pop;
  const NormalAppBar({Key key, this.title, this.pop = true}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Center(
        child: Padding(padding: const EdgeInsets.only(left: 60), child: Text(title, style: decisionButtonStyle)),
      ),
      backgroundColor: ColorUtils.kmColors,
      leading: pop ? const Padding(padding: EdgeInsets.only(right: 15), child: PopArrow()) : Container(),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(55.0);
}
