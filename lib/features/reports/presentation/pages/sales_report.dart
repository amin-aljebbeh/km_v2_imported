import 'package:expandable/expandable.dart';
import 'package:kammun_app/features/reports/presentation/redux/reports_action.dart';

import '../../../../core/core_importer.dart';
import '../../data/models/sales_reports_model.dart';

class SalesReport extends StatefulWidget {
  const SalesReport({Key key}) : super(key: key);

  @override
  _SalesReportState createState() => _SalesReportState();
}

class _SalesReportState extends State<SalesReport> {
  String fromDateTimeValue;
  String toDateTimeValue;

  @override
  void initState() {
    fromDateTimeValue = 'يرجى أختيار تاريخ البداية';
    toDateTimeValue = 'يرجى إختيار تاريخ النهاية';
    super.initState();
  }

  List<Widget> _reportCard() {
    List<Widget> totalSubWarehouses = [];
    DailyStatisticsModel response = StoreProvider.of<AppState>(context).state.reportState.dailyStatisticsEntity;
    totalSubWarehouses.clear();
    if (Services.hasRole(context, superAdminRole)) {
      totalSubWarehouses.add(Center(
          child: Padding(padding: const EdgeInsets.all(8.0), child: Text('إحصائيات عامة', style: informationStyle))));
      totalSubWarehouses.add(Table(
        border: TableBorder.all(color: Colors.black, style: BorderStyle.solid, width: 2),
        children: [
          TableRow(children: [
            KTableElement(text: totalSales),
            KTableElement(text: shoppingProfits),
            KTableElement(text: deliveryProfits),
          ]),
          TableRow(
            children: [
              KTableElement(text: StringUtils().oCcy.format(response.generalStatistics.totalSales)),
              KTableElement(text: StringUtils().oCcy.format(response.generalStatistics.totalShoppingProfits)),
              KTableElement(text: StringUtils().oCcy.format(response.generalStatistics.totalDeliveryProfits)),
            ],
          ),
          const TableRow(children: [
            KTableElement(text: 'القيم المضافة'),
            KTableElement(text: 'الإكراميات'),
            KTableElement(text: 'عدد الطلبات')
          ]),
          TableRow(
            children: [
              KTableElement(text: StringUtils().oCcy.format(response.generalStatistics.totalIncreaseValueProfits)),
              KTableElement(text: StringUtils().oCcy.format(response.generalStatistics.sumTips)),
              KTableElement(text: StringUtils().oCcy.format(response.generalStatistics.totalOrders)),
            ],
          ),
        ],
      ));
    }
    if (!Services.hasRole(context, superAdminRole)) {
      response.warehouses.removeWhere(
          (warehouse) => warehouse.id != StoreProvider.of<AppState>(context).state.adminsState.admin.warehouseId);
    }
    for (int i = 0; i < response.warehouses.length; i++) {
      if (response.warehouses[i].statisticsWarehouses != null) {
        List<Widget> expanded = [];
        if (response.warehouses[i].statisticsSubWarehouses != null) {
          for (int j = 0; j < response.warehouses[i].statisticsSubWarehouses.length; j++) {
            expanded.add(Column(
              children: [
                KTableElement(text: response.warehouses[i].statisticsSubWarehouses[j].name),
                KTableRow(
                  children: [
                    const KTableElement(text: 'مجموع سعر المبيع'),
                    KTableElement(text: shoppingProfits),
                    const KTableElement(text: 'مجموع القيم المضافة'),
                  ],
                ),
                KTableRow(
                  children: [
                    KTableElement(
                        text: StringUtils()
                            .oCcy
                            .format(int.parse(response.warehouses[i].statisticsSubWarehouses[j].sumPurchasePrice))),
                    KTableElement(
                      text: StringUtils().oCcy.format(int.parse(
                          response.warehouses[i].statisticsSubWarehouses[j].totalShoppingProfits.split('.')[0])),
                    ),
                    KTableElement(
                        text: StringUtils()
                            .oCcy
                            .format(int.parse(response.warehouses[i].statisticsSubWarehouses[j].totalIncreaseValue))),
                  ],
                ),
              ],
            ));
          }
          expanded.add(const KTableElement(text: 'المناطق المدعومة'));
        }

        if (response.warehouses[i].statisticsSupportedCities != null) {
          for (int j = 0; j < response.warehouses[i].statisticsSupportedCities.length; j++) {
            expanded.add(KTableRow(
              children: [
                KTableElement(text: response.warehouses[i].statisticsSupportedCities[j].name),
                KTableElement(text: ordersCount),
                const KTableElement(text: 'تسعيرة التوصيل'),
              ],
            ));
            expanded.add(KTableRow(
              children: [
                KTableElement(
                    text: StringUtils().oCcy.format(
                        int.parse(response.warehouses[i].statisticsSupportedCities[j].deliveryIncome.split('.')[0]))),
                KTableElement(
                    text: StringUtils().oCcy.format(response.warehouses[i].statisticsSupportedCities[j].ordersCount)),
                KTableElement(
                    text: StringUtils().oCcy.format(
                        int.parse(response.warehouses[i].statisticsSupportedCities[j].deliveryPrice.split('.')[0]))),
              ],
            ));
          }
        }
        totalSubWarehouses.add(ExpandablePanel(
          collapsed: Column(
            children: [
              Table(
                border: TableBorder.all(color: Colors.black, style: BorderStyle.solid, width: 2),
                children: [
                  TableRow(children: [
                    KTableElement(text: totalSales),
                    const KTableElement(text: 'إجمالي التوصيل'),
                    const KTableElement(text: 'المجموع الكلي'),
                  ]),
                  TableRow(
                    children: [
                      KTableElement(
                          text: StringUtils().oCcy.format(response.warehouses[i].statisticsWarehouses.totalSales)),
                      KTableElement(
                          text: StringUtils().oCcy.format(response.warehouses[i].statisticsWarehouses.deliveryIncome)),
                      KTableElement(text: StringUtils().oCcy.format(response.warehouses[i].statisticsWarehouses.total)),
                    ],
                  ),
                  TableRow(children: [
                    KTableElement(text: ordersCount),
                    KTableElement(text: shoppingProfits),
                    KTableElement(text: deliveryProfits)
                  ]),
                  TableRow(
                    children: [
                      KTableElement(
                          text: StringUtils().oCcy.format(response.warehouses[i].statisticsWarehouses.orderCount)),
                      KTableElement(
                          text: StringUtils().oCcy.format(response.warehouses[i].statisticsWarehouses.shoppingProfits)),
                      KTableElement(
                          text: StringUtils().oCcy.format(response.warehouses[i].statisticsWarehouses.deliveryProfits)),
                    ],
                  ),
                ],
              ),
              Table(
                border: TableBorder.all(color: Colors.black, style: BorderStyle.solid, width: 2),
                children: [
                  const TableRow(children: [KTableElement(text: 'القيم المضافة'), KTableElement(text: 'الإكراميات')]),
                  TableRow(
                    children: [
                      KTableElement(
                          text: StringUtils()
                              .oCcy
                              .format(response.warehouses[i].statisticsWarehouses.increaseValueProfits)),
                      KTableElement(
                          text: StringUtils().oCcy.format(response.warehouses[i].statisticsWarehouses.sumTips)),
                    ],
                  ),
                ],
              ),
            ],
          ),
          expanded: Column(children: expanded),
          header: Center(
            child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(response.warehouses[i].name, style: mainStyle.copyWith(fontSize: 25))),
          ),
        ));
      }
    }
    return totalSubWarehouses;
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      distinct: true,
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(backgroundColor: primaryColor, title: Text('تقرير المبيعات', style: appBarStyle)),
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
                              .dispatch(GetSalesReportsAction(toDate: toDateTimeValue, fromDate: fromDateTimeValue));
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
        );
      },
    );
  }

  bool validDates() =>
      fromDateTimeValue != 'يرجى أختيار تاريخ البداية' && toDateTimeValue != 'يرجى إختيار تاريخ النهاية';
}
