import '../core_importer.dart';

class CloseWidget extends StatelessWidget {
  const CloseWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) => DialogButton(text: closeString, onTap: () => Navigator.of(context).pop());
}
