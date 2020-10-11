import 'package:flutter/material.dart';
import 'package:kammun_app/utils/utils_importer.dart';

class ServerUpdate extends StatelessWidget {
  static final String routeName = "/server-update";

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  "assets/maintenance.png",
                  width: 100,
                  height: 150,
                ),
                Text(
                  "تحديثات ضمن النظام",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 25.0,
                      fontWeight: FontWeight.w500,
                      fontFamily: UtilsImporter().stringUtils.HKGrotesk),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      top: 8.0, bottom: 10, left: 30, right: 15),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      "نأسف لحدوث ذلك ولكن يقوم مدير النظام حالياً بإجراء بعض الإصلاحات و التطويرات، سوف نعاود العمل خلال مدة قصيرة",
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 18,
                        fontFamily: UtilsImporter().stringUtils.HKGrotesk,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                // Padding(
                //     padding: const EdgeInsets.all(8.0),
                //     child: _showAddAddressButton()),
              ],
            ),
          ),
          color: Colors.white,
          // color: Color.fromARGB(255, 40, 51, 140),
        ),
      ),
    );
  }
}
