import '../../../core/core_importer.dart';
import '../models/shopper_monthly_report_model.dart';
import '../services/reports_services.dart';

class ShopperMonthReport extends StatefulWidget {
  static const String routeName = '/ShopperMonthReport';
  const ShopperMonthReport({Key key}) : super(key: key);

  @override
  _ShopperMonthReportState createState() => _ShopperMonthReportState();
}

class _ShopperMonthReportState extends State<ShopperMonthReport> {
  bool selected;
  bool error;
  bool empty;
  bool loading;
  String shopperName;
  List<ShopperMonthlyReport> report;

  @override
  void initState() {
    error = false;
    empty = true;
    selected = Services.isShopper();
    loading = false;
    if (Services.isShopper()) {
      loading = true;
      getMonthlyReports(shopperId: Services.shopper.id.toString());
    }
    super.initState();
  }

  getMonthlyReports({String shopperId}) async {
    setState(() {
      if (report != null) {
        error = false;
        report.clear();
      }
    });
    var tempReport = await ReportsServices.getMonthlyShopperReports(shopperId: shopperId);
    setState(() {
      loading = false;
      if (tempReport != null) {
        error = false;
        empty = false;
        report = tempReport.shopperMonthlyReport;
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
      appBar: AppBar(backgroundColor: primaryColor, title: Text('معلومات المتسوق الشهرية', style: mainStyle)),
      body: SafeArea(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: ListView(
            children: [
              if (!Services.isShopper())
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.75,
                    child: KSearchableDropdown(
                      hint: chooseShopper,
                      search: shopperName,
                      items: Services.shoppersNameList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            shopperName = value;
                            selected = true;
                            loading = true;
                          });
                          getMonthlyReports(shopperId: Services.selectedShopperId(value));
                        }
                      },
                    ),
                  ),
                ),
              selected
                  ? error
                      ? Center(
                          child: AlertMessages(text: errorMessage, messageType: 'internetError', headerText: 'حدث خطأ'))
                      : loading
                          ? const Loader()
                          : SizedBox(
                              height: MediaQuery.of(context).size.height,
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
                                              KTableElement(text: 'عدد الطلبات'),
                                              KTableElement(text: 'مرابح الشهر'),
                                              KTableElement(text: 'مسافة التوصيل')
                                            ],
                                          ),
                                        MonthReportWidget(monthData: report[index])
                                      ],
                                    );
                                  },
                                ),
                              ),
                            )
                  : const ScreenMessage(message: 'اختر متسوق'),
            ],
          ),
        ),
      ),
    );
  }
}
