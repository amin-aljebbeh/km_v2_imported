import 'package:flutter/material.dart';
import 'package:kammun_app/utils/utils_importer.dart';

class DailyStatistics extends StatefulWidget {
  const DailyStatistics({Key key}) : super(key: key);

  @override
  _DailyStatisticsState createState() => _DailyStatisticsState();
}

class _DailyStatisticsState extends State<DailyStatistics> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "لوحة تحكم المدير",
          style: mainStyle,
        ),
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(10),
          child: ListView(
            children: [
              ListTile(
                leading: const Icon(Icons.info),
                // trailing: Icon(Icons.arrow_back),
                title: Text("إحصائيات المبيعات",
                    style: TextStyle(fontFamily: StringUtils.fontFamilyHKGrotesk, fontSize: 25)),
                onTap: () {
                  Navigator.of(context).pushNamed('/sales_reports');
                },
              ),
              ListTile(
                leading: const Icon(Icons.info),
                // trailing: Icon(Icons.arrow_back),
                title: Text(
                  "تقرير المطابقة",
                  style: TextStyle(
                    fontFamily: StringUtils.fontFamilyHKGrotesk,
                    fontSize: 25,
                  ),
                ),
                onTap: () {
                  Navigator.of(context).pushNamed('/matching_report');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
