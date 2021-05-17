import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:kammun_app/utils/Loader.dart';
import 'package:kammun_app/utils/kammun_button.dart';
import 'package:kammun_app/utils/utils_importer.dart';
import 'package:intl/intl.dart';
import 'package:kammun_app/views/Wedgit/AlertMessagess.dart';

import 'services/reports_services.dart';

class SalesReport extends StatefulWidget {
  @override
  _SalesReportState createState() => _SalesReportState();
}

class _SalesReportState extends State<SalesReport> {
  String _fromDateTimeValue = "يرجى أختيار تاريخ البداية";
  String _toDateTimeValue = "يرجى إختيار تاريخ النهاية";
  final DateFormat fullDateFormater = DateFormat('yyyy-MM-dd HH:mm:ss');
  bool isLoading = false;
  bool isError = false;
  int vegetables = 0;
  int toaster = 0;
  int library = 0;
  int seed = 0;
  int all = 0;

  _getSailesReport() async {
    setState(() {
      isError = false;
      isLoading = true;
    });

    var response = await ReportsServcies.getSailesReports(
        fromDate: _fromDateTimeValue,
        toDate: _toDateTimeValue,
        warehouseId: "1");
    if (response != null) {
      setState(() {
        vegetables = response.data.vegetables;
        toaster = response.data.toaster;
        library = response.data.dataLibrary;
        seed = response.data.seed;
        all = response.data.all;
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
        isError = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("إحصائيات المبيعات",
            style:
                TextStyle(fontFamily: UtilsImporter().stringUtils.HKGrotesk)),
      ),
      body: SafeArea(
        child: Container(
            padding: EdgeInsets.all(10),
            child: ListView(
              shrinkWrap: true,
              children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text("من تاريخ",
                          style: TextStyle(
                              fontFamily:
                                  UtilsImporter().stringUtils.HKGrotesk)),
                      IconButton(
                        icon: Icon(Icons.timer),
                        onPressed: () {
                          DatePicker.showDateTimePicker(context,
                              showTitleActions: true,
                              onChanged: (date) {}, onConfirm: (date) {
                            setState(() {
                              _fromDateTimeValue =
                                  fullDateFormater.format(date).toString();
                            });
                          }, currentTime: DateTime.now(), locale: 'en');
                        },
                      ),
                      Text(_fromDateTimeValue,
                          style: TextStyle(
                              fontFamily:
                                  UtilsImporter().stringUtils.HKGrotesk))
                    ]),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text("إلى تاريخ",
                          style: TextStyle(
                              fontFamily:
                                  UtilsImporter().stringUtils.HKGrotesk)),
                      IconButton(
                        icon: Icon(Icons.timeline),
                        onPressed: () {
                          DatePicker.showDateTimePicker(context,
                              showTitleActions: true,
                              onChanged: (date) {}, onConfirm: (date) {
                            setState(() {
                              _toDateTimeValue =
                                  fullDateFormater.format(date).toString();
                            });
                          }, currentTime: DateTime.now(), locale: 'en');
                        },
                      ),
                      Text(_toDateTimeValue,
                          style: TextStyle(
                              fontFamily:
                                  UtilsImporter().stringUtils.HKGrotesk))
                    ]),
                KammunButton(
                  text: "إرسال",
                  onPress: () {
                    _getSailesReport();
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                isError
                    ? AlertMessages(
                        text: "حطأ أثناء جلب البيانات",
                        messageType: "internetError")
                    : Container(),
                isLoading
                    ? Loader()
                    : Column(children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text("البزورية:",
                                style: TextStyle(
                                    fontFamily:
                                        UtilsImporter().stringUtils.HKGrotesk)),
                            Text(
                                UtilsImporter()
                                    .stringUtils
                                    .oCcy
                                    .format(seed)
                                    .toString(),
                                style: TextStyle(
                                    fontFamily:
                                        UtilsImporter().stringUtils.HKGrotesk))
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text("المحمصة:",
                                style: TextStyle(
                                    fontFamily:
                                        UtilsImporter().stringUtils.HKGrotesk)),
                            Text(
                                UtilsImporter()
                                    .stringUtils
                                    .oCcy
                                    .format(toaster)
                                    .toString(),
                                style: TextStyle(
                                    fontFamily:
                                        UtilsImporter().stringUtils.HKGrotesk))
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text("الخضار:",
                                style: TextStyle(
                                    fontFamily:
                                        UtilsImporter().stringUtils.HKGrotesk)),
                            Text(
                                UtilsImporter()
                                    .stringUtils
                                    .oCcy
                                    .format(vegetables)
                                    .toString(),
                                style: TextStyle(
                                    fontFamily:
                                        UtilsImporter().stringUtils.HKGrotesk))
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text("المكتبة:",
                                style: TextStyle(
                                    fontFamily:
                                        UtilsImporter().stringUtils.HKGrotesk)),
                            Text(
                                UtilsImporter()
                                    .stringUtils
                                    .oCcy
                                    .format(library)
                                    .toString(),
                                style: TextStyle(
                                    fontFamily:
                                        UtilsImporter().stringUtils.HKGrotesk))
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text("المجموع:",
                                style: TextStyle(
                                    fontFamily:
                                        UtilsImporter().stringUtils.HKGrotesk)),
                            Text(
                                UtilsImporter()
                                    .stringUtils
                                    .oCcy
                                    .format(all)
                                    .toString(),
                                style: TextStyle(
                                    fontFamily:
                                        UtilsImporter().stringUtils.HKGrotesk))
                          ],
                        ),
                      ]),
              ],
            )),
      ),
    );
  }
}
