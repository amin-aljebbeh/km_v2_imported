import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../../../core/core_importer.dart';
import '../../authentication/redux/authentication_action.dart';

class LoadingScreen extends StatefulWidget {
  static const String routeName = '/LoadingScreen';
  const LoadingScreen({Key key}) : super(key: key);

  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    StoreProvider.of<AppState>(navigatorKey.currentContext).dispatch(RestartApp());
    StoreProvider.of<AppState>(navigatorKey.currentContext).dispatch(CheckIfUserLoggedIn());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      builder: (context, state) => WillPopScope(
        onWillPop: () {
          return;
        },
        child: Scaffold(backgroundColor: Colors.white, extendBody: true, body: Lottie.asset('assets/introFinal.json')),
      ),
    );
  }
}
