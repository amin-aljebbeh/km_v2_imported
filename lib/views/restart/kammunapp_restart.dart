import 'package:flutter/material.dart';

class KammunRestart extends StatefulWidget {
  const KammunRestart({Key key, this.child}) : super(key: key);

  final Widget child;

  static void restartApp(BuildContext context) {
    context.findAncestorStateOfType<_KammunRestartState>().restartApp();
  }

  @override
  _KammunRestartState createState() => _KammunRestartState();
}

class _KammunRestartState extends State<KammunRestart> {
  Key key = UniqueKey();

  void restartApp() {
    setState(() {
      key = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: key,
      child: widget.child,
    );
  }
}
