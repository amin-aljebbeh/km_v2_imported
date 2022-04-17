import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../utils/utils_importer.dart';
import '../Widget/widgets_importer.dart';
import 'models/report_model_importer.dart';
import 'services/reports_services.dart';

class FinancialReportView extends StatefulWidget {
  const FinancialReportView({Key key}) : super(key: key);

  @override
  _FinancialReportViewState createState() => _FinancialReportViewState();
}

class _FinancialReportViewState extends State<FinancialReportView> {
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

  _reportCard(FinancialReport response) {
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
    totalSubWarehouses.add(Column(
      children: [
        LabelRow(
          rightSideText: 'مستحقات الشركة الكلية : ',
          leftSideText: StringUtils().oCcy.format(response.data.general.totalCompanyDues.abs()),
          leftSideStyle: response.data.general.totalCompanyDues > 0 ? profitStyle : loseStyle,
        ),
        LabelRow(
          rightSideText: 'أرباح المتسوقين الكلية : ',
          leftSideText: StringUtils().oCcy.format(response.data.general.totalProfitsShoppers.abs()),
          leftSideStyle: response.data.general.totalProfitsShoppers > 0 ? profitStyle : loseStyle,
        ),
      ],
    ));
    totalSubWarehouses.add(Padding(
      padding: const EdgeInsets.all(8.0),
      child: Divider(
        thickness: 5,
        color: ColorUtils.primaryColor,
        height: 5,
      ),
    ));
    for (var warehouse in response.data.warehouses) {
      totalSubWarehouses.add(ExpandablePanel(
        header: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Text(
              warehouse.name,
              style: informationStyle,
            ),
          ),
        ),
        collapsed: Center(
          child: Column(
            children: [
              LabelRow(
                rightSideText: 'مستحقات الشركة : ',
                leftSideText: StringUtils().oCcy.format(warehouse.totalCompanyDues.abs()),
                leftSideStyle: warehouse.totalCompanyDues > 0 ? profitStyle : loseStyle,
              ),
              LabelRow(
                rightSideText: 'أرباح المتسوقين : ',
                leftSideText: StringUtils().oCcy.format(warehouse.totalProfitsShoppers.abs()),
                leftSideStyle: warehouse.totalProfitsShoppers > 0 ? profitStyle : loseStyle,
              ),
            ],
          ),
        ),
        expanded: Column(
          children: [
            KTableRow(
              children: [
                KTableElement(text: StringUtils.shopper),
                const KTableElement(text: 'مستحقات الشركة'),
                const KTableElement(text: 'الأرباح'),
                const KTableElement(text: 'متوسط زمن التوصيل'),
                const KTableElement(text: 'متوسط التقييم'),
              ],
            ),
            ListView.builder(
              itemCount: warehouse.shoppers.length,
              primary: false,
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int index) {
                return KTableRow(
                  children: [
                    KTableElement(text: warehouse.shoppers[index].name),
                    KTableElement(
                        text: StringUtils()
                            .oCcy
                            .format(int.parse(warehouse.shoppers[index].companyDues.replaceAll('-', ''))),
                        style: !warehouse.shoppers[index].companyDues.contains('-')
                            ? lightProfitStyle
                            : lightLoseStyle),
                    KTableElement(
                        text: StringUtils()
                            .oCcy
                            .format(int.parse(warehouse.shoppers[index].totalProfits.replaceAll('-', ''))),
                        style: !warehouse.shoppers[index].totalProfits.contains('-')
                            ? lightProfitStyle
                            : lightLoseStyle),
                    KTableElement(
                      text: warehouse.shoppers[index].avgDeliveryMinutes,
                      style: double.parse(warehouse.shoppers[index].avgDeliveryMinutes) < 45
                          ? lightProfitStyle
                          : lightLoseStyle,
                    ),
                    KTableElement(
                      text: warehouse.shoppers[index].avgOrderRating,
                      style: double.parse(warehouse.shoppers[index].avgOrderRating) > 30
                          ? lightProfitStyle
                          : lightLoseStyle,
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ));
    }
    totalSubWarehouses.add(Padding(
      padding: const EdgeInsets.all(8.0),
      child: Divider(
        thickness: 5,
        color: ColorUtils.primaryColor,
        height: 5,
      ),
    ));
    totalSubWarehouses.add(Center(
      child: SfCircularChart(
        title: ChartTitle(text: 'توزع مستحقات الشركة', textStyle: informationStyle),
        legend: Legend(isVisible: true, textStyle: informationStyle),
        series: <PieSeries<Warehouse, String>>[
          PieSeries<Warehouse, String>(
              pointColorMapper: (Warehouse warehouse, _) => ColorUtils.warehousesColors[warehouse.id - 1],
              explode: true,
              explodeIndex: 0,
              dataSource: response.data.warehouses,
              xValueMapper: (Warehouse warehouse, _) =>
                  StringUtils().oCcy.format(warehouse.totalCompanyDues).toString(),
              yValueMapper: (Warehouse warehouse, _) => warehouse.totalCompanyDues,
              dataLabelMapper: (Warehouse warehouse, _) => warehouse.name,
              dataLabelSettings: DataLabelSettings(isVisible: true, textStyle: blackBold)),
        ],
      ),
    ));
    totalSubWarehouses.add(Center(
      child: SfCircularChart(
        title: ChartTitle(text: 'توزع أرباح المتسوقين', textStyle: informationStyle),
        legend: Legend(isVisible: true, textStyle: informationStyle),
        series: <PieSeries<Warehouse, String>>[
          PieSeries<Warehouse, String>(
              pointColorMapper: (Warehouse warehouse, _) => ColorUtils.warehousesColors[warehouse.id - 1],
              strokeColor: Colors.red,
              explode: true,
              explodeIndex: 0,
              dataSource: response.data.warehouses,
              xValueMapper: (Warehouse warehouse, _) =>
                  StringUtils().oCcy.format(warehouse.totalProfitsShoppers).toString(),
              yValueMapper: (Warehouse warehouse, _) => warehouse.totalProfitsShoppers,
              dataLabelMapper: (Warehouse warehouse, _) => warehouse.name,
              dataLabelSettings: DataLabelSettings(isVisible: true, textStyle: blackBold)),
        ],
      ),
    ));
  }

  _getSailsReport() async {
    setState(() {
      isError = false;
      isLoading = true;
    });

    var response = await ReportsServices.getFinancialReport(
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
          "الأرباح والمستحقات المالية",
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
