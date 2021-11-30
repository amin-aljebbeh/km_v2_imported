import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:kammun_app/utils/Loader.dart';
import 'package:kammun_app/utils/kammun_button.dart';
import 'package:kammun_app/utils/tools.dart';
import 'package:kammun_app/utils/utils_importer.dart';
import 'package:intl/intl.dart';
import 'package:kammun_app/views/Wedgit/AlertMessages.dart';
import 'package:kammun_app/views/loading/LoadingServices.dart';

import 'models/matching_report_model.dart';
import 'services/reports_services.dart';

class MatchingReport extends StatefulWidget {
  @override
  _MatchingReportState createState() => _MatchingReportState();
}

class _MatchingReportState extends State<MatchingReport> {
  String _reportDate = "يرجى أختيار تاريخ التقرير ";

  final DateFormat fullDateFormater = DateFormat('yyyy-MM-dd');
  bool isLoading = false;
  bool isError = false;
  int _selectedValue = -1;

  MatchingProducts _matchingProducts;

  _getMatchingReport() async {
    setState(() {
      isError = false;
      isLoading = true;
    });

    var response = await ReportsServcies.getMatchingReport(
        reportDate: _reportDate, subWarehouseId: _selectedValue.toString());
    if (response != null) {
      setState(() {
        isLoading = false;
        isError = false;
        _matchingProducts = response;
      });
      Tools.logToConsole(
          "THE Result is ${response.countProductsNotIncludedInKammun}");
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
                      Text("التاريخ",
                          style: TextStyle(
                              fontFamily:
                                  UtilsImporter().stringUtils.HKGrotesk)),
                      IconButton(
                        icon: Icon(Icons.timer),
                        onPressed: () {
                          DatePicker.showDatePicker(context,
                              showTitleActions: true,
                              onChanged: (date) {}, onConfirm: (date) {
                            setState(() {
                              _reportDate = date.toString().split(" ")[0];
                              Tools.logToConsole(_reportDate);
                            });
                          }, currentTime: DateTime.now(), locale: 'en');
                        },
                      ),
                      Text(_reportDate,
                          style: TextStyle(
                              fontFamily:
                                  UtilsImporter().stringUtils.HKGrotesk))
                    ]),
                ListTile(
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 10.0, vertical: 0.0),
                  title: Column(
                    children: LoadingScreenServices.subWarehouses
                        .map((data) => Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                              ),
                              child: RadioListTile(
                                controlAffinity:
                                    ListTileControlAffinity.trailing,
                                activeColor: Theme.of(context).primaryColor,
                                title: Text(
                                  "${data.name}",
                                  style: TextStyle(
                                    fontFamily:
                                        UtilsImporter().stringUtils.HKGrotesk,
                                  ),
                                ),
                                groupValue: _selectedValue,
                                value: data.id,
                                onChanged: (val) {
                                  setState(() {
                                    _selectedValue = data.id;
                                  });
                                },
                              ),
                            ))
                        .toList(),
                  ),
                ),
                KammunButton(
                  text: "إرسال",
                  onPress: () {
                    _getMatchingReport();
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
                isLoading ? Loader() : Column(children: []),
                _matchingProducts != null
                    ? Column(children: [
                        Text("المنتجات المختلفة بالكمية"),
                        ListView.builder(
                            itemBuilder: (BuildContext ctxt, int index) {
                          return Column(children: [
                            Text(_matchingProducts
                                .productsThatVaryInQuantity[index]
                                .kammunNameProducts),
                          ]);
                        })
                      ])
                    : Container(),
              ],
            )),
      ),
    );
  }
}
