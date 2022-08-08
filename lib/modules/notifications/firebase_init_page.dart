import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import '../../core/core_importer.dart';

class FirebaseInitPage extends StatefulWidget {
  final Store<AppState> store;

  const FirebaseInitPage({Key key, this.store}) : super(key: key);

  @override
  _FirebaseInitPageState createState() => _FirebaseInitPageState();
}

class _FirebaseInitPageState extends State<FirebaseInitPage> {
  bool initialized = false;
  bool authorized = false;
  bool error = false;

  void checkNotificationPermission() async {}

  void initializeFlutterFire() async {
    try {
      await Firebase.initializeApp().then((value) => {initialized = true});
    } catch (e) {
      error = true;
    }
    FirebaseMessaging messaging = FirebaseMessaging();

    if (Platform.isIOS) {
      authorized = await messaging
          .requestNotificationPermissions(const IosNotificationSettings(sound: true, badge: true, alert: true));

      if (initialized && authorized) {
        messaging.getToken().then((value) async {
          if (value != null) {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.setString('firebase_token', value);
          }
        });

        // ignore: missing_return
        messaging.configure(onMessage: (Map<String, dynamic> message) {
          if (message['data']['route_name'] != null) Navigator.pushNamed(context, message['data']['route_name']);
          if (message['notification'] != null) {
            showOverlayNotification(
              (context) => Card(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                child: SafeArea(
                  child: ListTile(
                    onTap: () {},
                    leading: SizedBox.fromSize(
                        size: const Size(40, 40), child: ClipOval(child: Image.asset('assets/kmIcon.png'))),
                    title: Text(message['notification']['title'] ?? 'Kammun', style: mainStyle),
                    subtitle: Text(message['notification']['body'] ?? '', style: mainStyle),
                    trailing: IconButton(icon: const Icon(Icons.close), onPressed: () {}),
                  ),
                ),
              ),
              duration: const Duration(milliseconds: 5000),
            );
          }
        }, onLaunch: (Map<String, dynamic> message) async {
          if (message['data']['route_name'] != null) Navigator.pushNamed(context, message['data']['route_name']);
          if (message['notification'] != null) {
            showOverlayNotification(
              (context) => Card(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                child: SafeArea(
                  child: ListTile(
                    onTap: () {},
                    leading: SizedBox.fromSize(
                        size: const Size(40, 40), child: ClipOval(child: Image.asset('assets/kmIcon.png'))),
                    title: Text(message['notification']['title'] ?? 'Kammun', style: mainStyle),
                    subtitle: Text(message['notification']['body'] ?? '', style: mainStyle),
                    trailing: IconButton(icon: const Icon(Icons.close), onPressed: () {}),
                  ),
                ),
              ),
              duration: const Duration(milliseconds: 5000),
            );
          }
        }, onResume: (Map<String, dynamic> message) async {
          if (message['data']['route_name'] != null) Navigator.pushNamed(context, message['data']['route_name']);
          if (message['notification'] != null) {
            showOverlayNotification(
              (context) => Card(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                child: SafeArea(
                  child: ListTile(
                    onTap: () {},
                    leading: SizedBox.fromSize(
                        size: const Size(40, 40), child: ClipOval(child: Image.asset('assets/kmIcon.png'))),
                    title: Text(message['notification']['title'] ?? 'Kammun', style: mainStyle),
                    subtitle: Text(message['notification']['body'] ?? '', style: mainStyle),
                    trailing: IconButton(icon: const Icon(Icons.close), onPressed: () {}),
                  ),
                ),
              ),
              duration: const Duration(milliseconds: 5000),
            );
          }
        });
      }
    } else {
      messaging.getToken().then((value) async {
        if (value != null) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString('firebase_token', value);
        }
      });

      // ignore: missing_return
      messaging.configure(onMessage: (Map<String, dynamic> message) {
        if (message['data']['route_name'] != null) Navigator.pushNamed(context, message['data']['route_name']);
        if (message['notification'] != null) {
          showOverlayNotification(
            (context) => Card(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              child: SafeArea(
                child: ListTile(
                  onTap: () {},
                  leading: SizedBox.fromSize(
                      size: const Size(40, 40), child: ClipOval(child: Image.asset('assets/kmIcon.png'))),
                  title: Text(message['notification']['title'] ?? 'Kammun', style: mainStyle),
                  subtitle: Text(message['notification']['body'] ?? '', style: mainStyle),
                  trailing: IconButton(icon: const Icon(Icons.close), onPressed: () {}),
                ),
              ),
            ),
            duration: const Duration(milliseconds: 5000),
          );
        }
      }, onLaunch: (Map<String, dynamic> message) async {
        if (message['data']['route_name'] != null) Navigator.pushNamed(context, message['data']['route_name']);
        if (message['notification'] != null) {
          showOverlayNotification(
            (context) => Card(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              child: SafeArea(
                child: ListTile(
                  onTap: () {},
                  leading: SizedBox.fromSize(
                      size: const Size(40, 40), child: ClipOval(child: Image.asset('assets/kmIcon.png'))),
                  title: Text(message['notification']['title'] ?? 'Kammun', style: mainStyle),
                  subtitle: Text(message['notification']['body'] ?? '', style: mainStyle),
                  trailing: IconButton(icon: const Icon(Icons.close), onPressed: () {}),
                ),
              ),
            ),
            duration: const Duration(milliseconds: 5000),
          );
        }
      }, onResume: (Map<String, dynamic> message) async {
        if (message['data']['route_name'] != null) Navigator.pushNamed(context, message['data']['route_name']);
        if (message['notification'] != null) {
          showOverlayNotification(
            (context) => Card(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              child: SafeArea(
                child: ListTile(
                  onTap: () {},
                  leading: SizedBox.fromSize(
                      size: const Size(40, 40), child: ClipOval(child: Image.asset('assets/kmIcon.png'))),
                  title: Text(message['notification']['title'] ?? 'Kammun', style: mainStyle),
                  subtitle: Text(message['notification']['body'] ?? '', style: mainStyle),
                  trailing: IconButton(icon: const Icon(Icons.close), onPressed: () {}),
                ),
              ),
            ),
            duration: const Duration(milliseconds: 5000),
          );
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    initializeFlutterFire();
  }

  @override
  Widget build(BuildContext context) {
    if (error) return const Text('ERROR NOTIFICATION');
    if (!initialized) return const CircularProgressIndicator();
    return MyApp(store: widget.store);
  }
}
