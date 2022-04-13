import 'package:flutter/material.dart';
import 'package:kammun_app/utils/utils_importer.dart';
import 'package:kammun_app/views/widget/widgets_importer.dart';
import 'models/sales_reports_model.dart';
import 'services/reports_services.dart';

class SalesReport extends StatefulWidget {
  const SalesReport({Key key}) : super(key: key);

  @override
  _SalesReportState createState() => _SalesReportState();
}

class _SalesReportState extends State<SalesReport> {
  String fromDateTimeValue;
  String toDateTimeValue;
  bool isLoading = false;
  bool isError = false;
  List<Widget> totalSubWarehouses = [];

  @override
  void initState() {
    fromDateTimeValue = "يرجى أختيار تاريخ البداية";
    toDateTimeValue = "يرجى إختيار تاريخ النهاية";
    super.initState();
  }

  _reportCard(GetDailyStatistics response) {
    totalSubWarehouses.clear();
    totalSubWarehouses.add(Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          'إحصائيات عامة',
          style: informationStyle,
        ),
      ),
    ));
    totalSubWarehouses.add(
      Table(
        border: TableBorder.all(color: Colors.black, style: BorderStyle.solid, width: 2),
        children: [
          TableRow(children: [
            KTableElement(text: StringUtils.totalSales),
            KTableElement(text: StringUtils.shoppingProfits),
            KTableElement(text: StringUtils.deliveryProfits),
          ]),
          TableRow(
            children: [
              KTableElement(
                text: StringUtils().oCcy.format(response.generalStatistics.totalSales),
              ),
              KTableElement(
                text: StringUtils().oCcy.format(response.generalStatistics.totalShoppingProfits),
              ),
              KTableElement(
                text: StringUtils().oCcy.format(response.generalStatistics.totalDeliveryProfits),
              ),
            ],
          ),
        ],
      ),
    );
    for (int i = 0; i < response.warehouses.length; i++) {
      if (response.warehouses[i].statisticsWarehouses != null) {
        totalSubWarehouses.add(
          Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                response.warehouses[i].name,
                style: TextStyle(
                  fontFamily: StringUtils.fontFamilyHKGrotesk,
                  fontSize: 25,
                ),
              ),
            ),
          ),
        );
        totalSubWarehouses.add(
          Table(
            border: TableBorder.all(color: Colors.black, style: BorderStyle.solid, width: 2),
            children: [
              TableRow(children: [
                KTableElement(text: StringUtils.totalSales),
                const KTableElement(text: "إجمالي التوصيل"),
                const KTableElement(text: "المجموع الكلي"),
              ]),
              TableRow(
                children: [
                  KTableElement(
                    text: StringUtils().oCcy.format(response.warehouses[i].statisticsWarehouses.totalSales),
                  ),
                  KTableElement(
                    text: StringUtils().oCcy.format(response.warehouses[i].statisticsWarehouses.deliveryIncome),
                  ),
                  KTableElement(
                    text: StringUtils().oCcy.format(response.warehouses[i].statisticsWarehouses.total),
                  ),
                ],
              ),
              TableRow(children: [
                KTableElement(text: StringUtils.ordersCount),
                KTableElement(text: StringUtils.shoppingProfits),
                KTableElement(text: StringUtils.deliveryProfits),
              ]),
              TableRow(
                children: [
                  KTableElement(
                    text: StringUtils().oCcy.format(response.warehouses[i].statisticsWarehouses.orderCount),
                  ),
                  KTableElement(
                    text: StringUtils().oCcy.format(response.warehouses[i].statisticsWarehouses.shoppingProfits),
                  ),
                  KTableElement(
                    text: StringUtils().oCcy.format(response.warehouses[i].statisticsWarehouses.deliveryProfits),
                  ),
                ],
              ),
            ],
          ),
        );
        if (response.warehouses[i].statisticsSubWarehouses != null) {
          for (int j = 0; j < response.warehouses[i].statisticsSubWarehouses.length; j++) {
            totalSubWarehouses.add(
              Column(
                children: [
                  KTableElement(
                    text: response.warehouses[i].statisticsSubWarehouses[j].name,
                  ),
                  KTableRow(
                    children: [
                      const KTableElement(
                        text: 'مجموع سعر المبيع',
                      ),
                      KTableElement(
                        text: StringUtils.shoppingProfits,
                      ),
                      const KTableElement(
                        text: 'مجموع القيم المضافة',
                      ),
                    ],
                  ),
                  KTableRow(
                    children: [
                      KTableElement(
                        text: StringUtils()
                            .oCcy
                            .format(int.parse(response.warehouses[i].statisticsSubWarehouses[j].sumPurchasePrice)),
                      ),
                      KTableElement(
                        text: StringUtils().oCcy.format(int.parse(
                            response.warehouses[i].statisticsSubWarehouses[j].totalShoppingProfits.split('.')[0])),
                      ),
                      KTableElement(
                        text: StringUtils()
                            .oCcy
                            .format(
                                int.parse(response.warehouses[i].statisticsSubWarehouses[j].totalIncreaseValue))
                            .toString(),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }
          totalSubWarehouses.add(const KTableElement(
            text: 'المناطق المدعومة',
          ));
        }

        if (response.warehouses[i].statisticsSupportedCities != null) {
          for (int j = 0; j < response.warehouses[i].statisticsSupportedCities.length; j++) {
            totalSubWarehouses.add(
              KTableRow(
                children: [
                  KTableElement(
                    text: response.warehouses[i].statisticsSupportedCities[j].name,
                  ),
                  KTableElement(
                    text: StringUtils.ordersCount,
                  ),
                  const KTableElement(
                    text: "تسعيرة التوصيل",
                  ),
                ],
              ),
            );
            totalSubWarehouses.add(
              KTableRow(
                children: [
                  KTableElement(
                    text: StringUtils().oCcy.format(int.parse(
                        response.warehouses[i].statisticsSupportedCities[j].deliveryIncome.split(".")[0])),
                  ),
                  KTableElement(
                    text: StringUtils()
                        .oCcy
                        .format(
                          response.warehouses[i].statisticsSupportedCities[j].ordersCount,
                        )
                        .toString(),
                  ),
                  KTableElement(
                    text: StringUtils().oCcy.format(
                          int.parse(
                            response.warehouses[i].statisticsSupportedCities[j].deliveryPrice
                                .split(".")[0]
                                .toString(),
                          ),
                        ),
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
      fromDate: fromDateTimeValue,
      toDate: toDateTimeValue,
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
        backgroundColor: ColorUtils.primaryColor,
        title: Text(
          "إحصائيات المبيعات",
          style: mainStyle,
        ),
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(10),
          child: ListView(
            padding: const EdgeInsets.only(bottom: 25),
            shrinkWrap: true,
            children: [
              KDatePicker(
                onConfirmStart: (date) {
                  setState(() {
                    fromDateTimeValue = date;
                  });
                },
                onConfirmEnd: (date) {
                  setState(() {
                    toDateTimeValue = date;
                  });
                },
              ),
              KammunButton(
                text: StringUtils.send,
                color: validDates() ? Theme.of(context).primaryColor : ColorUtils.searchGreyColor,
                onTap: () {
                  if (validDates()) {
                    _getSailsReport();
                  } else {
                    Toast.show('الرجاء إدخال كافة البيانات', context,
                        duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
                  }
                },
                height: 50,
              ),
              const SizedBox(
                height: 20,
              ),
              isError ? AlertMessages(text: StringUtils.errorMessage, messageType: "internetError") : Container(),
              isLoading
                  ? const Loader()
                  : totalSubWarehouses.isNotEmpty
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
    return fromDateTimeValue != "يرجى أختيار تاريخ البداية" && toDateTimeValue != "يرجى إختيار تاريخ النهاية";
  }
}
