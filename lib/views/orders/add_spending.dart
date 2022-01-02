import 'package:flutter/material.dart';
import 'package:kammun_app/models/models_importer.dart';
import 'package:kammun_app/utils/Loader.dart';
import 'package:kammun_app/utils/utils_importer.dart';

class AddSpending extends StatefulWidget {
  final OrdersOriginalData orderDetails;

  const AddSpending({Key key, this.orderDetails}) : super(key: key);

  @override
  _AddSpendingState createState() => _AddSpendingState();
}

bool isLoading = false;

class _AddSpendingState extends State<AddSpending> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 210, 178, 2),
        automaticallyImplyLeading: false,
        flexibleSpace: SafeArea(
          child: Column(
            children: <Widget>[
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Opacity(
                      opacity: 0.0,
                      child: Icon(
                        Icons.home,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5.0),
                      child: Transform.scale(
                        scale: 2,
                        child: InkWell(
                          onTap: () {
                            Navigator.pushNamedAndRemoveUntil(
                              context,
                              '/home',
                              (Route<dynamic> route) => false,
                            );
                          },
                          child: Image.asset(
                            "assets/logobw.png",
                            width: 150,
                            height: 50,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.only(top: 5.0, left: 0),
                        child: IconButton(
                            onPressed: () => Navigator.of(context).pop(true),
                            icon: Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.white,
                              size: 40,
                            ))),
                  ]),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding:
              const EdgeInsets.only(top: 25.0, bottom: 8, left: 8, right: 8),
          child: isLoading
              ? Center(child: Loader())
              : ListView(
                  shrinkWrap: true,
                  children: [
                    Text(
                      "أنت تقوم حاليا بإضافة مصروف على الطلب",
                      style: TextStyle(
                        fontFamily: StringUtils.fontFamilyHKGrotesk,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
