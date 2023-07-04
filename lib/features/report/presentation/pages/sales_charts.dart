import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../../core/core_importer.dart';
import '../../data/models/sales_reports_model.dart';
import '../../domain/entities/warehouse_statistics_entity.dart';
import '../redux/reports_action.dart';

class SalesCharts extends StatefulWidget {
  const SalesCharts({Key key}) : super(key: key);

  @override
  _SalesChartsState createState() => _SalesChartsState();
}

class _SalesChartsState extends State<SalesCharts> {
  TooltipBehavior tooltipBehavior;
  String fromDateTimeValue;
  String toDateTimeValue;

  @override
  void initState() {
    fromDateTimeValue = 'يرجى أختيار تاريخ البداية';
    toDateTimeValue = 'يرجى إختيار تاريخ النهاية';
    tooltipBehavior = TooltipBehavior(enable: true, textStyle: mainStyle, color: primaryColor);
    super.initState();
  }

  List<Widget> _reportCard() {
    List<Widget> totalSubWarehouses = [];
    DailyStatisticsModel response = StoreProvider.of<AppState>(context).state.reportState.dailyStatisticsEntity;
    totalSubWarehouses.clear();
    totalSubWarehouses.add(Center(
      child: SfCircularChart(
        title: ChartTitle(text: 'توزع مرابح التوصيل', textStyle: informationStyle),
        legend: Legend(isVisible: true, textStyle: informationStyle),
        series: <PieSeries<WarehouseStatisticsEntity, String>>[
          PieSeries<WarehouseStatisticsEntity, String>(
              pointColorMapper: (WarehouseStatisticsEntity warehouse, _) =>
                  warehousesColors[((warehouse.id - 1) % warehousesColors.length) % warehousesColors.length],
              explode: true,
              explodeIndex: 0,
              dataSource: response.warehouses,
              xValueMapper: (WarehouseStatisticsEntity warehouse, _) =>
                  StringUtils().oCcy.format(warehouse.statisticsWarehouses.deliveryProfits),
              yValueMapper: (WarehouseStatisticsEntity warehouse, _) => warehouse.statisticsWarehouses.deliveryProfits,
              dataLabelMapper: (WarehouseStatisticsEntity warehouse, _) => warehouse.name,
              dataLabelSettings: DataLabelSettings(isVisible: true, textStyle: blackBold)),
        ],
      ),
    ));
    totalSubWarehouses.add(Center(
      child: SfCircularChart(
        title: ChartTitle(text: 'توزع مرابح التسوق', textStyle: informationStyle),
        legend: Legend(isVisible: true, textStyle: informationStyle),
        series: <PieSeries<WarehouseStatisticsEntity, String>>[
          PieSeries<WarehouseStatisticsEntity, String>(
              pointColorMapper: (WarehouseStatisticsEntity warehouse, _) =>
                  warehousesColors[(warehouse.id - 1) % warehousesColors.length],
              explode: true,
              explodeIndex: 0,
              dataSource: response.warehouses,
              xValueMapper: (WarehouseStatisticsEntity warehouse, _) =>
                  StringUtils().oCcy.format(warehouse.statisticsWarehouses.shoppingProfits),
              yValueMapper: (WarehouseStatisticsEntity warehouse, _) => warehouse.statisticsWarehouses.shoppingProfits,
              dataLabelMapper: (WarehouseStatisticsEntity warehouse, _) => warehouse.name,
              dataLabelSettings: DataLabelSettings(isVisible: true, textStyle: blackBold)),
        ],
      ),
    ));
    totalSubWarehouses.add(Center(
      child: SfCircularChart(
        title: ChartTitle(text: 'توزع عدد الطلبات', textStyle: informationStyle),
        legend: Legend(isVisible: true, textStyle: informationStyle),
        series: <PieSeries<WarehouseStatisticsEntity, String>>[
          PieSeries<WarehouseStatisticsEntity, String>(
              pointColorMapper: (WarehouseStatisticsEntity warehouse, _) =>
                  warehousesColors[(warehouse.id - 1) % warehousesColors.length],
              explode: true,
              explodeIndex: 0,
              dataSource: response.warehouses,
              xValueMapper: (WarehouseStatisticsEntity warehouse, _) =>
                  StringUtils().oCcy.format(warehouse.statisticsWarehouses.orderCount),
              yValueMapper: (WarehouseStatisticsEntity warehouse, _) => warehouse.statisticsWarehouses.orderCount,
              dataLabelMapper: (WarehouseStatisticsEntity warehouse, _) => warehouse.name,
              dataLabelSettings: DataLabelSettings(isVisible: true, textStyle: blackBold)),
        ],
      ),
    ));
    totalSubWarehouses.add(Center(
      child: SfCircularChart(
        title: ChartTitle(text: 'توزع إجمالي المبيعات', textStyle: informationStyle),
        legend: Legend(isVisible: true, textStyle: informationStyle),
        series: <PieSeries<WarehouseStatisticsEntity, String>>[
          PieSeries<WarehouseStatisticsEntity, String>(
              pointColorMapper: (WarehouseStatisticsEntity warehouse, _) =>
                  warehousesColors[(warehouse.id - 1) % warehousesColors.length],
              explode: true,
              explodeIndex: 0,
              dataSource: response.warehouses,
              xValueMapper: (WarehouseStatisticsEntity warehouse, _) =>
                  StringUtils().oCcy.format(warehouse.statisticsWarehouses.totalSales),
              yValueMapper: (WarehouseStatisticsEntity warehouse, _) => warehouse.statisticsWarehouses.totalSales,
              dataLabelMapper: (WarehouseStatisticsEntity warehouse, _) => warehouse.name,
              dataLabelSettings: DataLabelSettings(isVisible: true, textStyle: blackBold)),
        ],
      ),
    ));
    totalSubWarehouses.add(Center(
      child: SfCircularChart(
        title: ChartTitle(text: 'توزع المجموع الكلي', textStyle: informationStyle),
        legend: Legend(isVisible: true, textStyle: informationStyle),
        series: <PieSeries<WarehouseStatisticsEntity, String>>[
          PieSeries<WarehouseStatisticsEntity, String>(
              pointColorMapper: (WarehouseStatisticsEntity warehouse, _) =>
                  warehousesColors[(warehouse.id - 1) % warehousesColors.length],
              explode: true,
              explodeIndex: 0,
              dataSource: response.warehouses,
              xValueMapper: (WarehouseStatisticsEntity warehouse, _) =>
                  StringUtils().oCcy.format(warehouse.statisticsWarehouses.total),
              yValueMapper: (WarehouseStatisticsEntity warehouse, _) => warehouse.statisticsWarehouses.total,
              dataLabelMapper: (WarehouseStatisticsEntity warehouse, _) => warehouse.name,
              dataLabelSettings: DataLabelSettings(isVisible: true, textStyle: blackBold)),
        ],
      ),
    ));
    totalSubWarehouses.add(Center(
      child: SfCircularChart(
        title: ChartTitle(text: 'توزع إجمالي التوصيل', textStyle: informationStyle),
        legend: Legend(isVisible: true, textStyle: informationStyle),
        series: <PieSeries<WarehouseStatisticsEntity, String>>[
          PieSeries<WarehouseStatisticsEntity, String>(
              pointColorMapper: (WarehouseStatisticsEntity warehouse, _) =>
                  warehousesColors[(warehouse.id - 1) % warehousesColors.length],
              explode: true,
              explodeIndex: 0,
              dataSource: response.warehouses,
              xValueMapper: (WarehouseStatisticsEntity warehouse, _) =>
                  StringUtils().oCcy.format(warehouse.statisticsWarehouses.deliveryIncome),
              yValueMapper: (WarehouseStatisticsEntity warehouse, _) => warehouse.statisticsWarehouses.deliveryIncome,
              dataLabelMapper: (WarehouseStatisticsEntity warehouse, _) => warehouse.name,
              dataLabelSettings: DataLabelSettings(isVisible: true, textStyle: blackBold)),
        ],
      ),
    ));
    return totalSubWarehouses;
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      distinct: true,
      builder: (context, state) {
        return SafeArea(
          child: Scaffold(
            appBar: AppBar(backgroundColor: primaryColor, title: Text('إحصائيات المبيعات', style: appBarStyle)),
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
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: KammunButton(
                        text: send,
                        color: validDates() ? Theme.of(context).primaryColor : searchGreyColor,
                        onTap: () {
                          if (validDates()) {
                            StoreProvider.of<AppState>(context)
                                .dispatch(GetSalesReportsAction(fromDate: fromDateTimeValue, toDate: toDateTimeValue));
                          } else {
                            Toast.show('الرجاء إدخال كافة البيانات', context,
                                duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
                          }
                        },
                        height: 50,
                      ),
                    ),
                    if (state.errorState.isError) AlertMessages(text: errorMessage, messageType: 'internetError'),
                    state.loadingState.loading.isNotEmpty
                        ? const Loader()
                        : state.reportState.dailyStatisticsEntity != null
                            ? Column(children: _reportCard())
                            : Container(),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  bool validDates() =>
      fromDateTimeValue != 'يرجى أختيار تاريخ البداية' && toDateTimeValue != 'يرجى إختيار تاريخ النهاية';
}
