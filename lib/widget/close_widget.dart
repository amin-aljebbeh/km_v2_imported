import '../core/core_importer.dart';

class CloseWidget extends StatelessWidget {
  const CloseWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DialogButton(
        text: StringUtils.close,
        onTap: () {
          Navigator.of(navigatorKey.currentContext).pop();
        });
  }
}
