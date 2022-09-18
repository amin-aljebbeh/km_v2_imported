import '../core/core_importer.dart';

snackBar({String message, bool success, BuildContext context}) {
  ScaffoldMessenger.of(context)
    ..removeCurrentSnackBar()
    ..showSnackBar(SnackBar(
        content: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Icon(success ? Icons.check_rounded : Icons.error_rounded, color: Colors.white),
          Expanded(child: Text(message, style: flushBarStyle))
        ]),
        backgroundColor: success ? Colors.green : Colors.red,
        shape: const StadiumBorder(),
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        duration: Duration(seconds: success ? 1 : 2)));
}
