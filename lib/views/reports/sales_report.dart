import 'package:flutter/material.dart';
import 'package:kammun_app/views/widget/widgets_importer.dart';
import 'package:kammun_app/utils/utils_importer.dart';

import 'models/sales_reports_model.dart';
import 'services/reports_services.dart';

class SalesReport extends StatefulWidget {
  @override
  _SalesReportState createState() => _SalesReportState();
}

class _SalesReportState extends State<SalesReport> {
  String _fromDateTimeValue = "يرجى أختيار تاريخ البداية";
  String _toDateTimeValue = "يرجى إختيار تاريخ النهاية";
  bool isLoading = false;
  bool isError = false;
  List<Widget> totalSubWarehouses = [];

  _reportCard(GetDailyStatistics response) {
    totalSubWarehouses.clear();
    for (int i = 0; i < response.data.length; i++) {
      if (response.data[i].statisticsWarehouses != null) {
        totalSubWarehouses.add(
          Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                response.data[i].name,
                style: TextStyle(
                  fontFamily: StringUtils.fontFamilyHKGrotesk,
                  fontSize: 25,
                ),
              ),
            ),
          ),
        );
        totalSubWarehouses.add(
          Center(
            child: Table(
              border: TableBorder.all(color: Colors.black, style: BorderStyle.solid, width: 2),
              children: [
                TableRow(children: [
                  KTableElement(text: "إجمالي المبيعات"),
                  KTableElement(text: "إجمالي التوصيل"),
                  KTableElement(text: "المجموع الكلي"),
                ]),
                TableRow(
                  children: [
                    KTableElement(
                      text: StringUtils().oCcy.format(response.data[i].statisticsWarehouses.totalSales).toString(),
                    ),
                    KTableElement(
                      text: StringUtils()
                          .oCcy
                          .format(response.data[i].statisticsWarehouses.deliveryIncome)
                          .toString(),
                    ),
                    KTableElement(
                      text: StringUtils().oCcy.format(response.data[i].statisticsWarehouses.total).toString(),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
        if (response.data[i].statisticsSubWarehouses != null) {
          for (int j = 0; j < response.data[i].statisticsSubWarehouses.length; j++) {
            totalSubWarehouses.add(
              KTableRow(
                children: [
                  KTableElement(
                    text: response.data[i].statisticsSubWarehouses[j].name,
                  ),
                  KTableElement(
                    text: StringUtils()
                        .oCcy
                        .format(int.parse(response.data[i].statisticsSubWarehouses[j].sumPurchasePrice))
                        .toString(),
                  ),
                ],
              ),
            );
          }
        }

        if (response.data[i].statisticsSupportedCities != null) {
          for (int j = 0; j < response.data[i].statisticsSupportedCities.length; j++) {
            totalSubWarehouses.add(
              KTableRow(
                children: [
                  KTableElement(
                    text: response.data[i].statisticsSupportedCities[j].name,
                  ),
                  KTableElement(
                    text: "عدد الطلبات",
                  ),
                  KTableElement(
                    text: "تسعيرة التوصيل",
                  ),
                ],
              ),
            );
            totalSubWarehouses.add(
              KTableRow(
                children: [
                  KTableElement(
                    text: StringUtils()
                        .oCcy
                        .format(
                            int.parse(response.data[i].statisticsSupportedCities[j].deliveryIncome.split(".")[0]))
                        .toString(),
                  ),
                  KTableElement(
                    text: StringUtils()
                        .oCcy
                        .format(
                          int.parse(
                            response.data[i].statisticsSupportedCities[j].ordersCount.toString(),
                          ),
                        )
                        .toString(),
                  ),
                  KTableElement(
                    text: StringUtils()
                        .oCcy
                        .format(
                          int.parse(
                            response.data[i].statisticsSupportedCities[j].deliveryPrice.split(".")[0].toString(),
                          ),
                        )
                        .toString(),
                  ),
                ],
              ),
            );
          }
        }
      }
    }
  }

  _getSailsReport() async {
    setState(() {
      isError = false;
      isLoading = true;
    });

    var response = await ReportsServices.getSalesReports(
      fromDate: _fromDateTimeValue,
      toDate: _toDateTimeValue,
    );
    if (response != null) {
      _reportCard(response);

      setState(() {
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
        title: Text(
          "إحصائيات المبيعات",
          style: mainStyle,
        ),
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(10),
          child: ListView(
            shrinkWrap: true,
            children: [
              KDatePicker(
                onConfirmStart: (date) {
                  setState(() {
                    _fromDateTimeValue = date;
                  });
                },
                onConfirmEnd: (date) {
                  setState(() {
                    _toDateTimeValue = date;
                  });
                },
              ),
              KammunButton(
                text: StringUtils.send,
                color: validDates() ? Theme.of(context).primaryColor : ColorUtils.searchGreyColor,
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
              isError ? AlertMessages(text: StringUtils.errorMessage, messageType: "internetError") : Container(),
              isLoading
                  ? Loader()
                  : totalSubWarehouses.length > 0
                      ? Column(
                          children: totalSubWarehouses,
                        )
                      : Container(),
            ],
          ),
        ),
      ),
    );
  }

  bool validDates() {
    return _fromDateTimeValue != "يرجى أختيار تاريخ البداية" && _toDateTimeValue != "يرجى إختيار تاريخ النهاية";
  }
}
