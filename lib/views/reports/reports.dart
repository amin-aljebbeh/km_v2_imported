import 'package:flutter/material.dart';
import 'package:kammun_app/utils/utils_importer.dart';

class DailyStatistics extends StatefulWidget {
  @override
  _DailyStatisticsState createState() => _DailyStatisticsState();
}

class _DailyStatisticsState extends State<DailyStatistics> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("لوحة تحكم المدير",
            style:
                TextStyle(fontFamily: UtilsImporter().stringUtils.HKGrotesk)),
      ),
      body: SafeArea(
        child: Container(
            padding: EdgeInsets.all(10),
            child: ListView(
              children: [
                ListTile(
                  leading: Icon(Icons.info),
                  // trailing: Icon(Icons.arrow_back),
                  title: Text("إحصائيات المبيعات",
                      style: TextStyle(
                          fontFamily: UtilsImporter().stringUtils.HKGrotesk,
                          fontSize: 25)),
                  onTap: () {
                    Navigator.of(context).pushNamed('/sales_reports');
                  },
                ),
                ListTile(
                  leading: Icon(Icons.info),
                  // trailing: Icon(Icons.arrow_back),
                  title: Text("تقرير المطابقة",
                      style: TextStyle(
                          fontFamily: UtilsImporter().stringUtils.HKGrotesk,
                          fontSize: 25)),
                  onTap: () {
                    Navigator.of(context).pushNamed('/matching_report');
                  },
                ),
              ],
            )),
      ),
    );
  }
}
