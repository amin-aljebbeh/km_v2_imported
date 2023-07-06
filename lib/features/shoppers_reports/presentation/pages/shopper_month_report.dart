import 'package:kammun_app/features/shoppers_reports/presentation/redux/shoppers_reports_action.dart';

import '../../../../core/core_importer.dart';
import '../widgets/month_report_widget.dart';

class ShopperMonthReport extends StatefulWidget {
  const ShopperMonthReport({Key key}) : super(key: key);

  @override
  _ShopperMonthReportState createState() => _ShopperMonthReportState();
}

class _ShopperMonthReportState extends State<ShopperMonthReport> {
  bool selected = false;
  String shopperName;

  @override
  void initState() {
    if (mounted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        selected = Services.hasRole(context, shopperRole);
        if (Services.hasRole(context, shopperRole)) {
          getMonthlyReports(shopperId: StoreProvider.of<AppState>(context).state.shoppersState.shopper.id.toString());
        }
      });
    }

    super.initState();
  }

  getMonthlyReports({String shopperId}) async {
    StoreProvider.of<AppState>(context).dispatch(GetMonthlyReportAction(shopperId: shopperId));
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      distinct: true,
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Theme.of(context).primaryColorLight,
          resizeToAvoidBottomInset: false,
          appBar: AppBar(backgroundColor: primaryColor, title: Text('معلومات المتسوق الشهرية', style: appBarStyle)),
          body: SafeArea(
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: ListView(
                children: [
                  if (!Services.hasRole(context, shopperRole))
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: SizedBox(
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
                              });
                              getMonthlyReports(shopperId: Services.selectedShopperId(value, context));
                            }
                          },
                        ),
                      ),
                    ),
                  selected
                      ? state.errorState.isError
                          ? Center(
                              child: AlertMessages(
                                  text: errorMessage, messageType: 'internetError', headerText: 'حدث خطأ'))
                          : state.loadingState.loading.isNotEmpty
                              ? const Loader()
                              : SizedBox(
                                  height: MediaQuery.of(context).size.height,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ListView.builder(
                                      physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
                                      scrollDirection: Axis.vertical,
                                      itemCount: state.shoppersReportsState.monthlyReport.length,
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
                                            MonthReportWidget(monthData: state.shoppersReportsState.monthlyReport[index])
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
      },
    );
  }
}
