import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:kammun_app/utils/Loader.dart';
import 'package:kammun_app/utils/tools.dart';
import 'package:kammun_app/utils/utils_importer.dart';
import 'package:intl/intl.dart';
import 'package:kammun_app/views/Wedgit/AlertMessages.dart';
import 'package:kammun_app/views/Wedgit/kammun_button.dart';
import 'package:toast/toast.dart';

import 'models/sales_reports_model.dart';
import 'services/reports_services.dart';

class SalesReport extends StatefulWidget {
  @override
  _SalesReportState createState() => _SalesReportState();
}

class _SalesReportState extends State<SalesReport> {
  String _fromDateTimeValue = "يرجى أختيار تاريخ البداية";
  String _toDateTimeValue = "يرجى إختيار تاريخ النهاية";
  final DateFormat fullDateFormatter = DateFormat('yyyy-MM-dd HH:mm:ss');
  bool isLoading = false;
  bool isError = false;
  int vegetables = 0;
  int toaster = 0;
  int library = 0;
  int seed = 0;
  int all = 0;

  List<Widget> totalSubWarehouses = [];

  _reportCard(GetDailyStatistics response) {
    totalSubWarehouses.clear();
    Tools.logToConsole("Response Data Length: ${response.data.length}");
    for (int i = 0; i < response.data.length; i++) {
      if (response.data[i].statisticsWarehouses != null) {
        totalSubWarehouses.add(
          Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                response.data[i].name,
                style: TextStyle(
                  fontFamily: UtilsImporter().stringUtils.HKGrotesk,
                  fontSize: 25,
                ),
              ),
            ),
          ),
        );
        totalSubWarehouses.add(
          Center(
            child: Table(
              border: TableBorder.all(
                  color: Colors.black, style: BorderStyle.solid, width: 2),
              children: [
                TableRow(children: [
                  Container(
                    margin: EdgeInsets.all(10),
                    child: Text(
                      "إجمالي المبيعات",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: UtilsImporter().stringUtils.HKGrotesk,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(10),
                    child: Text(
                      "إجمالي التوصيل",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: UtilsImporter().stringUtils.HKGrotesk),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(10),
                    child: Text(
                      "المجموع الكلي",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: UtilsImporter().stringUtils.HKGrotesk),
                    ),
                  )
                ]),
                TableRow(children: [
                  Container(
                    margin: EdgeInsets.all(10),
                    child: Text(
                      UtilsImporter()
                          .stringUtils
                          .oCcy
                          .format(
                              response.data[i].statisticsWarehouses.totalSales)
                          .toString(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: UtilsImporter().stringUtils.HKGrotesk),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(10),
                    child: Text(
                      UtilsImporter()
                          .stringUtils
                          .oCcy
                          .format(response
                              .data[i].statisticsWarehouses.deliveryIncome)
                          .toString(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: UtilsImporter().stringUtils.HKGrotesk),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(10),
                    child: Text(
                      UtilsImporter()
                          .stringUtils
                          .oCcy
                          .format(response.data[i].statisticsWarehouses.total)
                          .toString(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: UtilsImporter().stringUtils.HKGrotesk),
                    ),
                  )
                ]),
              ],
            ),
          ),
        );
        if (response.data[i].statisticsSubWarehouses != null) {
          for (int j = 0;
              j < response.data[i].statisticsSubWarehouses.length;
              j++) {
            totalSubWarehouses.add(
              Table(
                border: TableBorder.all(
                    color: Theme.of(context).primaryColor,
                    style: BorderStyle.solid,
                    width: 1),
                children: [
                  TableRow(children: [
                    Container(
                      margin: EdgeInsets.all(10),
                      child: Text(
                        response.data[i].statisticsSubWarehouses[j].name,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: UtilsImporter().stringUtils.HKGrotesk,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.all(10),
                      child: Text(
                        UtilsImporter()
                            .stringUtils
                            .oCcy
                            .format(int.parse(response.data[i]
                                .statisticsSubWarehouses[j].sumPurchasePrice))
                            .toString(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: UtilsImporter().stringUtils.HKGrotesk,
                        ),
                      ),
                    )
                  ]),
                ],
              ),
            );
          }
        }

        if (response.data[i].statisticsSupportedCities != null) {
          for (int j = 0;
              j < response.data[i].statisticsSupportedCities.length;
              j++) {
            totalSubWarehouses.add(
              Table(
                border: TableBorder.all(
                    color: Theme.of(context).primaryColor,
                    style: BorderStyle.solid,
                    width: 1),
                children: [
                  TableRow(children: [
                    Container(
                      margin: EdgeInsets.all(10),
                      child: Text(
                        response.data[i].statisticsSupportedCities[j].name,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: UtilsImporter().stringUtils.HKGrotesk,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.all(10),
                      child: Text(
                        "عدد الطلبات",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: UtilsImporter().stringUtils.HKGrotesk,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.all(10),
                      child: Text(
                        "تسعيرة التوصيل",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: UtilsImporter().stringUtils.HKGrotesk,
                        ),
                      ),
                    ),
                  ]),
                  TableRow(children: [
                    Container(
                      margin: EdgeInsets.all(10),
                      child: Text(
                        UtilsImporter()
                            .stringUtils
                            .oCcy
                            .format(int.parse(response.data[i]
                                .statisticsSupportedCities[j].deliveryIncome
                                .split(".")[0]))
                            .toString(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: UtilsImporter().stringUtils.HKGrotesk,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.all(10),
                      child: Text(
                        UtilsImporter()
                            .stringUtils
                            .oCcy
                            .format(int.parse(response.data[i]
                                .statisticsSupportedCities[j].ordersCount
                                .toString()))
                            .toString(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: UtilsImporter().stringUtils.HKGrotesk,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.all(10),
                      child: Text(
                        UtilsImporter()
                            .stringUtils
                            .oCcy
                            .format(int.parse(response.data[i]
                                .statisticsSupportedCities[j].deliveryPrice
                                .split(".")[0]
                                .toString()))
                            .toString(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: UtilsImporter().stringUtils.HKGrotesk,
                        ),
                      ),
                    )
                  ])
                ],
              ),
            );
          }
        }
      }
    }
    Tools.logToConsole(
        "The end if for  and the length : ${totalSubWarehouses.length}");
  }

  _getSailsReport() async {
    setState(() {
      isError = false;
      isLoading = true;
    });

    var response = await ReportsServcies.getSalesReports(
      fromDate: _fromDateTimeValue,
      toDate: _toDateTimeValue,
    );
    if (response != null) {
      _reportCard(response);

      setState(() {
        // vegetables = response.data[0].subWarehouses[0].sumPurchasePrice;
        // toaster = response.data.toaster;
        // library = response.data.dataLibrary;
        // seed = response.data.seed;
        // all = response.data.all;
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
                                  fullDateFormatter.format(date).toString();
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
                                  fullDateFormatter.format(date).toString();
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
                  text: UtilsImporter().stringUtils.send,
                  color: validDates()
                      ? Theme.of(context).primaryColor
                      : UtilsImporter().colorUtils.searchgreycolor,
                  onTap: () {
                    if (validDates())
                      _getSailsReport();
                    else
                      Toast.show('الرجاء إدخال كافة البيانات', context,
                          duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
                  },
                  height: 50,
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
                    : totalSubWarehouses.length > 0
                        ? Column(
                            // shrinkWrap: true,
                            children: totalSubWarehouses,
                          )
                        : Container(),
              ],
            )),
      ),
    );
  }

  bool validDates() {
    return _fromDateTimeValue != "يرجى أختيار تاريخ البداية" &&
        _toDateTimeValue != "يرجى إختيار تاريخ النهاية";
  }
}
