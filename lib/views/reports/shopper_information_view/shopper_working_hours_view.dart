import 'package:flutter/material.dart';
import 'package:kammun_app/views/reports/shopper_information_view/work_hour_widget.dart';

import '../../../service.dart';
import '../../../utils/utils_importer.dart';
import '../../widget/widgets_importer.dart';
import '../models/shopper_working_hours_model.dart';
import '../services/reports_services.dart';

class ShopperWorkingHoursView extends StatefulWidget {
  static const String routeName = '/ShopperWorkingHoursView';
  const ShopperWorkingHoursView({Key key}) : super(key: key);

  @override
  _ShopperWorkingHoursViewState createState() => _ShopperWorkingHoursViewState();
}

class _ShopperWorkingHoursViewState extends State<ShopperWorkingHoursView> {
  bool selected;
  bool error;
  bool empty;
  bool loading;
  String shopperName;
  List<ShopperWorkingHoursData> report;

  @override
  void initState() {
    error = false;
    empty = true;
    selected = Services.isShopper();
    loading = false;
    groupValue = DateFilter.day;
    if (Services.isShopper()) {
      loading = true;
      getWorkingHours(shopperId: Services.shopper.id.toString(), filter: DateFilter.day);
    }
    super.initState();
  }

  getWorkingHours({String shopperId, DateFilter filter}) async {
    setState(() {
      if (report != null) {
        error = false;
        report.clear();
      }
    });
    var tempReport =
        await ReportsServices.getShopperWorkingHours(shopperId: shopperId, filterBy: filter.toString());
    setState(() {
      loading = false;
      if (tempReport != null) {
        error = false;
        empty = false;
        report = tempReport;
        if (report.isEmpty) empty = true;
      } else {
        error = true;
      }
    });
  }

  DateFilter groupValue;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColorLight,
      resizeToAvoidBottomInset: false,
      appBar:
          AppBar(backgroundColor: ColorUtils.primaryColor, title: Text('ساعات دوام المتسوق', style: mainStyle)),
      body: SafeArea(
        child: Column(
          children: [
            if (!Services.isShopper())
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.75,
                child: KSearchableDropdown(
                  hint: StringUtils.chooseShopper,
                  search: shopperName,
                  items: Services.shoppersNameList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        shopperName = value;
                        selected = true;
                        loading = true;
                      });
                      getWorkingHours(shopperId: Services.selectedShopperId(shopperName), filter: groupValue);
                    }
                  },
                ),
              ),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: <Widget>[
                  RadioListTile<DateFilter>(
                    title: Text('يومياً', style: mainStyle),
                    value: DateFilter.day,
                    activeColor: ColorUtils.primaryColor,
                    groupValue: groupValue,
                    onChanged: (DateFilter value) {
                      setState(() {
                        groupValue = value;
                        if (shopperName != null || Services.isShopper()) {
                          loading = true;
                          getWorkingHours(
                              shopperId: Services.isShopper()
                                  ? Services.shopper.id.toString()
                                  : Services.selectedShopperId(shopperName),
                              filter: groupValue);
                        }
                      });
                    },
                  ),
                  RadioListTile<DateFilter>(
                    title: Text('شهرياً', style: mainStyle),
                    value: DateFilter.month,
                    activeColor: ColorUtils.primaryColor,
                    groupValue: groupValue,
                    onChanged: (DateFilter value) {
                      setState(() {
                        groupValue = value;
                        if (shopperName != null || Services.isShopper()) {
                          loading = true;
                          getWorkingHours(
                              shopperId: Services.isShopper()
                                  ? Services.shopper.id.toString()
                                  : Services.selectedShopperId(shopperName),
                              filter: groupValue);
                        }
                      });
                    },
                  ),
                  RadioListTile<DateFilter>(
                    title: Text('سنوياً', style: mainStyle),
                    activeColor: ColorUtils.primaryColor,
                    value: DateFilter.year,
                    groupValue: groupValue,
                    onChanged: (DateFilter value) {
                      setState(() {
                        groupValue = value;
                        if (shopperName != null || Services.isShopper()) {
                          loading = true;
                          getWorkingHours(
                              shopperId: Services.isShopper()
                                  ? Services.shopper.id.toString()
                                  : Services.selectedShopperId(shopperName),
                              filter: groupValue);
                        }
                      });
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: selected
                  ? error
                      ? Center(
                          child: AlertMessages(
                            text: StringUtils.errorMessage,
                            messageType: 'internetError',
                            headerText: 'حدث خطأ',
                          ),
                        )
                      : loading
                          ? const Loader()
                          : SizedBox(
                              height: MediaQuery.of(context).size.height * 0.56,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ListView.builder(
                                  scrollDirection: Axis.vertical,
                                  itemCount: report.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    return Column(
                                      children: [
                                        if (index == 0)
                                          const KTableRow(
                                            children: [
                                              KTableElement(text: 'التاريخ'),
                                              KTableElement(text: 'عدد الساعات')
                                            ],
                                          ),
                                        WorkHourWidget(workingHoursData: report[index]),
                                      ],
                                    );
                                  },
                                ),
                              ),
                            )
                  : const ScreenMessage(message: 'اختر متسوق'),
            ),
            const SizedBox(),
          ],
        ),
      ),
    );
  }
}
/*SfCartesianChart(
                              primaryXAxis: CategoryAxis(),
                              title: ChartTitle(text: 'عدد ساعات الدوام', textStyle: mainStyle),
                              tooltipBehavior: TooltipBehavior(enable: true, textStyle: mainStyle),
                              series: <ChartSeries<ShopperWorkingHoursData, String>>[
                                  ColumnSeries<ShopperWorkingHoursData, String>(
                                      dataSource: report,
                                      xValueMapper: (ShopperWorkingHoursData report, _) => report.date,
                                      yValueMapper: (ShopperWorkingHoursData report, _) => report.sum,
                                      name: 'ساعات الدوام',
                                      color: ColorUtils.primaryColor),
                                ])*/
