import '../core_importer.dart';

class ScreenMessage extends StatelessWidget {
  final String message;

  const ScreenMessage({Key key, @required this.message}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: 50.0,
        child: Center(
          child: Text(message,
              style: mainStyle.copyWith(fontWeight: FontWeight.w700, color: primaryColor, fontSize: 20.0)),
        ),
      ),
    );
  }
}
