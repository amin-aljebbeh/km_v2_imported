import 'package:firebase_core/firebase_core.dart';

import '../../core/core_importer.dart';
import '../../features/errors_screen/internet_error.dart';
import '../../features/update_screen/update_required_screen.dart';

class LoadingScreen extends StatefulWidget {
  static String userToken = 'Bearer ';
  static String updateUrl = '';

  const LoadingScreen({Key key}) : super(key: key);

  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  Future fetchInformation;
  Future checkUpdate;

  CartProduct cartLoad = CartProduct();

  dynamic notificationValue;

  @override
  void initState() {
    fetchInformation = _getClientInfo();

    super.initState();
  }

  _getClientInfo() async {
    try {
      await Firebase.initializeApp();
      bool userLoggedIn = await Services.checkIfUserLoggedIn();
      if (userLoggedIn) {
        bool x = await GeneralApis.fetchStartInformation(context: context);
        return x;
      }
      return 'userNotLoggedIn';
    } catch (e) {
      /**/
    }
  }

  loadingProgress() {
    return Scaffold(
      backgroundColor: kmColors,
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
            image: DecorationImage(image: AssetImage('assets/welcome_screen.png'), fit: BoxFit.contain)),
        child: Stack(
          children: <Widget>[
            Positioned(
                left: MediaQuery.of(context).size.width - 80,
                bottom: MediaQuery.of(context).size.height / 2 - 37,
                height: 100,
                width: 100,
                child: Image.asset('assets/Loading.gif')),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: fetchInformation,
      builder: (context, snapShot) {
        if (snapShot.data == 'userNotLoggedIn') return const LoginScreen();

        if (snapShot.connectionState == ConnectionState.done) {
          if (snapShot.hasError || snapShot.data == false) {
            return const InternetError();
          } else if (StaticVariables.updateRequired) {
            return const UpdateScreen();
          } else if (StaticVariables.serverMaintain) {
            return const ServerUpdate();
          } else {
            final child = HomeView(routeIndex: 0, notificationValue: notificationValue);
            return AnimatedSwitcher(
              transitionBuilder: (Widget child, Animation<double> animation) {
                var begin = const Offset(0.0, 1.0);
                var end = Offset.zero;
                var curve = Curves.ease;

                var tween = Tween(begin: begin, end: end);
                var curvedAnimation = CurvedAnimation(parent: animation, curve: curve);

                final slide = HomeView(routeIndex: 0, notificationValue: notificationValue);
                return SlideTransition(position: tween.animate(curvedAnimation), child: slide);
              },
              duration: const Duration(milliseconds: 250),
              child: child,
            );
          }
        } else {
          return loadingProgress();
        }
      },
    );
  }
}
