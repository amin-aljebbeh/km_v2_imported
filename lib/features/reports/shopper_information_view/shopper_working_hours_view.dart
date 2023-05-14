import '../../../core/core_importer.dart';
import '../models/shopper_working_hours_model.dart';
import '../services/reports_services.dart';

class ShopperWorkingHoursView extends StatefulWidget {
  static const String routeName = '/ShopperWorkingHoursView';
  const ShopperWorkingHoursView({Key key}) : super(key: key);

  @override
  _ShopperWorkingHoursViewState createState() => _ShopperWorkingHoursViewState();
}

class _ShopperWorkingHoursViewState extends State<ShopperWorkingHoursView> {
  DateFilter groupValue;
  bool selected = false;
  bool error;
  bool empty;
  bool loading;
  String shopperName;
  List<ShopperWorkingHoursData> report;

  @override
  void initState() {
    error = false;
    empty = true;
    loading = false;
    groupValue = DateFilter.day;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      selected = Services.hasRole(context, shopperRole);
      if (Services.hasRole(context, shopperRole)) {
        loading = true;
        getWorkingHours(shopperId: StaticVariables.shopper.id.toString(), filter: DateFilter.day);
      }
    });

    super.initState();
  }

  getWorkingHours({String shopperId, DateFilter filter}) async {
    setState(() {
      if (report != null) {
        error = false;
        report.clear();
      }
    });
    var tempReport = await ReportsServices.getShopperWorkingHours(shopperId: shopperId, filterBy: filter.toString());
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColorLight,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(backgroundColor: primaryColor, title: Text('ساعات دوام المتسوق', style: appBarStyle)),
      body: SafeArea(
        child: Column(
          children: [
            if (!Services.hasRole(context, shopperRole))
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.75,
                child: KSearchableDropdown(
                  hint: chooseShopper,
                  search: shopperName,
                  items: Services.shoppersNameList(context),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        shopperName = value;
                        selected = true;
                        loading = true;
                      });
                      getWorkingHours(shopperId: Services.selectedShopperId(shopperName, context), filter: groupValue);
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
                    activeColor: primaryColor,
                    groupValue: groupValue,
                    onChanged: (DateFilter value) {
                      setState(() {
                        groupValue = value;
                        if (shopperName != null || Services.hasRole(context, shopperRole)) {
                          loading = true;
                          getWorkingHours(
                              shopperId: Services.hasRole(context, shopperRole)
                                  ? StaticVariables.shopper.id.toString()
                                  : Services.selectedShopperId(shopperName, context),
                              filter: groupValue);
                        }
                      });
                    },
                  ),
                  RadioListTile<DateFilter>(
                    title: Text('شهرياً', style: mainStyle),
                    value: DateFilter.month,
                    activeColor: primaryColor,
                    groupValue: groupValue,
                    onChanged: (DateFilter value) {
                      setState(() {
                        groupValue = value;
                        if (shopperName != null || Services.hasRole(context, shopperRole)) {
                          loading = true;
                          getWorkingHours(
                              shopperId: Services.hasRole(context, shopperRole)
                                  ? StaticVariables.shopper.id.toString()
                                  : Services.selectedShopperId(shopperName, context),
                              filter: groupValue);
                        }
                      });
                    },
                  ),
                  RadioListTile<DateFilter>(
                    title: Text('سنوياً', style: mainStyle),
                    activeColor: primaryColor,
                    value: DateFilter.year,
                    groupValue: groupValue,
                    onChanged: (DateFilter value) {
                      setState(() {
                        groupValue = value;
                        if (shopperName != null || Services.hasRole(context, shopperRole)) {
                          loading = true;
                          getWorkingHours(
                              shopperId: Services.hasRole(context, shopperRole)
                                  ? StaticVariables.shopper.id.toString()
                                  : Services.selectedShopperId(shopperName, context),
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
                          child: AlertMessages(text: errorMessage, messageType: 'internetError', headerText: 'حدث خطأ'))
                      : loading
                          ? const Loader()
                          : SizedBox(
                              height: MediaQuery.of(context).size.height * 0.56,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ListView.builder(
                                  physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
                                  scrollDirection: Axis.vertical,
                                  itemCount: report.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    return Column(
                                      children: [
                                        if (index == 0)
                                          const KTableRow(
                                            children: [
                                              KTableElement(text: 'التاريخ'),
                                              KTableElement(text: 'عدد الساعات'),
                                              KTableElement(text: 'عدد الطلبات'),
                                              KTableElement(text: 'مسافة التوصيل'),
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
          ],
        ),
      ),
    );
  }
}
