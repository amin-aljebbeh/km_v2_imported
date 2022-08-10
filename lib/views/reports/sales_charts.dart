import 'package:syncfusion_flutter_charts/charts.dart';
import '../../core/core_importer.dart';
import 'models/report_model_importer.dart';
import 'services/reports_services.dart';

class SalesCharts extends StatefulWidget {
  const SalesCharts({Key key}) : super(key: key);

  @override
  _SalesChartsState createState() => _SalesChartsState();
}

class _SalesChartsState extends State<SalesCharts> {
  TooltipBehavior tooltipBehavior;
  String fromDateTimeValue;
  String toDateTimeValue;
  bool isLoading = false;
  bool isError = false;
  List<Widget> totalSubWarehouses = [];

  @override
  void initState() {
    fromDateTimeValue = 'يرجى أختيار تاريخ البداية';
    toDateTimeValue = 'يرجى إختيار تاريخ النهاية';
    tooltipBehavior = TooltipBehavior(enable: true, textStyle: mainStyle, color: ColorUtils.primaryColor);
    super.initState();
  }

  _getSailsReport() async {
    setState(() {
      isError = false;
      isLoading = true;
    });

    var response = await ReportsServices.getSalesReports(fromDate: fromDateTimeValue, toDate: toDateTimeValue);
    if (response != null) {
      _reportCard(response);

      setState(() => isLoading = false);
    } else {
      setState(() {
        isLoading = false;
        isError = true;
      });
    }
  }

  _reportCard(GetDailyStatistics response) {
    totalSubWarehouses.clear();
    totalSubWarehouses.add(Center(
      child: SfCircularChart(
        title: ChartTitle(text: 'توزع مرابح التوصيل', textStyle: informationStyle),
        legend: Legend(isVisible: true, textStyle: informationStyle),
        series: <PieSeries<WarehouseStatistics, String>>[
          PieSeries<WarehouseStatistics, String>(
              pointColorMapper: (WarehouseStatistics warehouse, _) => ColorUtils.warehousesColors[warehouse.id - 1],
              explode: true,
              explodeIndex: 0,
              dataSource: response.warehouses,
              xValueMapper: (WarehouseStatistics warehouse, _) =>
                  StringUtils().oCcy.format(warehouse.statisticsWarehouses.deliveryProfits).toString(),
              yValueMapper: (WarehouseStatistics warehouse, _) => warehouse.statisticsWarehouses.deliveryProfits,
              dataLabelMapper: (WarehouseStatistics warehouse, _) => warehouse.name,
              dataLabelSettings: DataLabelSettings(isVisible: true, textStyle: blackBold)),
        ],
      ),
    ));
    totalSubWarehouses.add(Center(
      child: SfCircularChart(
        title: ChartTitle(text: 'توزع مرابح التسوق', textStyle: informationStyle),
        legend: Legend(isVisible: true, textStyle: informationStyle),
        series: <PieSeries<WarehouseStatistics, String>>[
          PieSeries<WarehouseStatistics, String>(
              pointColorMapper: (WarehouseStatistics warehouse, _) => ColorUtils.warehousesColors[warehouse.id - 1],
              explode: true,
              explodeIndex: 0,
              dataSource: response.warehouses,
              xValueMapper: (WarehouseStatistics warehouse, _) =>
                  StringUtils().oCcy.format(warehouse.statisticsWarehouses.shoppingProfits).toString(),
              yValueMapper: (WarehouseStatistics warehouse, _) => warehouse.statisticsWarehouses.shoppingProfits,
              dataLabelMapper: (WarehouseStatistics warehouse, _) => warehouse.name,
              dataLabelSettings: DataLabelSettings(isVisible: true, textStyle: blackBold)),
        ],
      ),
    ));
    totalSubWarehouses.add(Center(
      child: SfCircularChart(
        title: ChartTitle(text: 'توزع عدد الطلبات', textStyle: informationStyle),
        legend: Legend(isVisible: true, textStyle: informationStyle),
        series: <PieSeries<WarehouseStatistics, String>>[
          PieSeries<WarehouseStatistics, String>(
              pointColorMapper: (WarehouseStatistics warehouse, _) => ColorUtils.warehousesColors[warehouse.id - 1],
              explode: true,
              explodeIndex: 0,
              dataSource: response.warehouses,
              xValueMapper: (WarehouseStatistics warehouse, _) =>
                  StringUtils().oCcy.format(warehouse.statisticsWarehouses.orderCount).toString(),
              yValueMapper: (WarehouseStatistics warehouse, _) => warehouse.statisticsWarehouses.orderCount,
              dataLabelMapper: (WarehouseStatistics warehouse, _) => warehouse.name,
              dataLabelSettings: DataLabelSettings(isVisible: true, textStyle: blackBold)),
        ],
      ),
    ));
    totalSubWarehouses.add(Center(
      child: SfCircularChart(
        title: ChartTitle(text: 'توزع إجمالي المبيعات', textStyle: informationStyle),
        legend: Legend(isVisible: true, textStyle: informationStyle),
        series: <PieSeries<WarehouseStatistics, String>>[
          PieSeries<WarehouseStatistics, String>(
              pointColorMapper: (WarehouseStatistics warehouse, _) => ColorUtils.warehousesColors[warehouse.id - 1],
              explode: true,
              explodeIndex: 0,
              dataSource: response.warehouses,
              xValueMapper: (WarehouseStatistics warehouse, _) =>
                  StringUtils().oCcy.format(warehouse.statisticsWarehouses.totalSales).toString(),
              yValueMapper: (WarehouseStatistics warehouse, _) => warehouse.statisticsWarehouses.totalSales,
              dataLabelMapper: (WarehouseStatistics warehouse, _) => warehouse.name,
              dataLabelSettings: DataLabelSettings(isVisible: true, textStyle: blackBold)),
        ],
      ),
    ));
    totalSubWarehouses.add(Center(
      child: SfCircularChart(
        title: ChartTitle(text: 'توزع المجموع الكلي', textStyle: informationStyle),
        legend: Legend(isVisible: true, textStyle: informationStyle),
        series: <PieSeries<WarehouseStatistics, String>>[
          PieSeries<WarehouseStatistics, String>(
              pointColorMapper: (WarehouseStatistics warehouse, _) => ColorUtils.warehousesColors[warehouse.id - 1],
              explode: true,
              explodeIndex: 0,
              dataSource: response.warehouses,
              xValueMapper: (WarehouseStatistics warehouse, _) =>
                  StringUtils().oCcy.format(warehouse.statisticsWarehouses.total).toString(),
              yValueMapper: (WarehouseStatistics warehouse, _) => warehouse.statisticsWarehouses.total,
              dataLabelMapper: (WarehouseStatistics warehouse, _) => warehouse.name,
              dataLabelSettings: DataLabelSettings(isVisible: true, textStyle: blackBold)),
        ],
      ),
    ));
    totalSubWarehouses.add(Center(
      child: SfCircularChart(
        title: ChartTitle(text: 'توزع إجمالي التوصيل', textStyle: informationStyle),
        legend: Legend(isVisible: true, textStyle: informationStyle),
        series: <PieSeries<WarehouseStatistics, String>>[
          PieSeries<WarehouseStatistics, String>(
              pointColorMapper: (WarehouseStatistics warehouse, _) => ColorUtils.warehousesColors[warehouse.id - 1],
              explode: true,
              explodeIndex: 0,
              dataSource: response.warehouses,
              xValueMapper: (WarehouseStatistics warehouse, _) =>
                  StringUtils().oCcy.format(warehouse.statisticsWarehouses.deliveryIncome).toString(),
              yValueMapper: (WarehouseStatistics warehouse, _) => warehouse.statisticsWarehouses.deliveryIncome,
              dataLabelMapper: (WarehouseStatistics warehouse, _) => warehouse.name,
              dataLabelSettings: DataLabelSettings(isVisible: true, textStyle: blackBold)),
        ],
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: ColorUtils.primaryColor,
          title: Text('إحصائيات المبيعات', style: mainStyle),
        ),
        body: SafeArea(
          child: Container(
            padding: const EdgeInsets.all(10),
            child: ListView(
              padding: const EdgeInsets.only(bottom: 25),
              shrinkWrap: true,
              children: [
                KDatePicker(
                  onConfirmStart: (date) => setState(() => fromDateTimeValue = date),
                  onConfirmEnd: (date) => setState(() => toDateTimeValue = date),
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
                const SizedBox(height: 20),
                isError ? AlertMessages(text: StringUtils.errorMessage, messageType: 'internetError') : Container(),
                isLoading
                    ? const Loader()
                    : totalSubWarehouses.isNotEmpty
                        ? Column(children: totalSubWarehouses)
                        : Container(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool validDates() =>
      fromDateTimeValue != 'يرجى أختيار تاريخ البداية' && toDateTimeValue != 'يرجى إختيار تاريخ النهاية';
}
