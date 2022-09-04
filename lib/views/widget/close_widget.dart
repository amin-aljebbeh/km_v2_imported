import 'package:flutter/material.dart';

import '../../utils/utils_importer.dart';
import 'dialog_button.dart';

class CloseWidget extends StatelessWidget {
  const CloseWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DialogButton(
        text: close,
        onTap: () {
          Navigator.of(context).pop();
        });
  }
}
