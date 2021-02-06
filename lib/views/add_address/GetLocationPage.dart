import 'package:flutter/material.dart';
import 'package:kammun_app/utils/tools.dart';
import 'package:location/location.dart';

class GetLocationPage extends StatefulWidget {
  @override
  _GetLocationPageState createState() => _GetLocationPageState();
}

class _GetLocationPageState extends State<GetLocationPage> {
  var location = new Location();

  Map<String, double> userLocation;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            userLocation == null
                ? CircularProgressIndicator()
                : Text("Location:" +
                    userLocation["latitude"].toString() +
                    " " +
                    userLocation["longitude"].toString()),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: RaisedButton(
                onPressed: () {
                  _getLocation().then((value) {
                    setState(() {
                      userLocation = value;
                    });
                  });
                },
                color: Colors.blue,
                child: Text(
                  "Get Location",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<Map<String, double>> _getLocation() async {
    LocationData currentLocation;

    await location.requestPermission();
    if (await location.hasPermission() == PermissionStatus.granted) {
      try {
        currentLocation = await location.getLocation();
      } catch (e) {
        currentLocation = null;
      }
      Map<String, double> userLocation = {
        "latitude": currentLocation.latitude,
        "longitude": currentLocation.longitude
      };
      return userLocation;
    } else {}
  }
}
