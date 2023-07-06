import '../../../../core/core_importer.dart';
import '../redux/shoppers_reports_action.dart';
import '../widgets/work_hour_widget.dart';

class ShopperWorkingHoursView extends StatefulWidget {
  const ShopperWorkingHoursView({Key key}) : super(key: key);

  @override
  _ShopperWorkingHoursViewState createState() => _ShopperWorkingHoursViewState();
}

class _ShopperWorkingHoursViewState extends State<ShopperWorkingHoursView> {
  DateFilter groupValue;
  bool selected = false;
  String shopperName;

  @override
  void initState() {
    groupValue = DateFilter.day;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      selected = Services.hasRole(context, shopperRole);
      if (Services.hasRole(context, shopperRole)) {
        getWorkingHours(
            shopperId: StoreProvider.of<AppState>(context).state.shoppersState.shopper.id.toString(),
            filter: DateFilter.day);
      }
    });

    super.initState();
  }

  getWorkingHours({String shopperId, DateFilter filter}) async {
    StoreProvider.of<AppState>(context)
        .dispatch(GetWorkingHoursAction(shopperId: shopperId, filterBy: filter.toString()));
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
                          });
                          getWorkingHours(
                              shopperId: Services.selectedShopperId(shopperName, context), filter: groupValue);
                        }
                      },
                    ),
                  ),
                Column(
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
                            getWorkingHours(
                                shopperId: Services.hasRole(context, shopperRole)
                                    ? state.shoppersState.shopper.id.toString()
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
                            getWorkingHours(
                                shopperId: Services.hasRole(context, shopperRole)
                                    ? state.shoppersState.shopper.id.toString()
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
                            getWorkingHours(
                                shopperId: Services.hasRole(context, shopperRole)
                                    ? state.shoppersState.shopper.id.toString()
                                    : Services.selectedShopperId(shopperName, context),
                                filter: groupValue);
                          }
                        });
                      },
                    ),
                  ],
                ),
                Expanded(
                  child: selected
                      ? state.errorState.isError
                          ? Center(
                              child: AlertMessages(
                                  text: errorMessage, messageType: 'internetError', headerText: 'حدث خطأ'))
                          : state.loadingState.loading.isNotEmpty
                              ? const Loader()
                              : SizedBox(
                                  height: MediaQuery.of(context).size.height * 0.56,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ListView.builder(
                                      physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
                                      scrollDirection: Axis.vertical,
                                      itemCount: state.shoppersReportsState.workingHours.length,
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
                                            WorkHourWidget(
                                                workingHoursData: state.shoppersReportsState.workingHours[index]),
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
      },
    );
  }
}
