import 'package:kammun_app/features/shoppers_reports/presentation/redux/shoppers_reports_action.dart';

import '../../../../core/core_importer.dart';
import '../widgets/active_hours_widget.dart';

class ActivityHoursView extends StatefulWidget {
  const ActivityHoursView({Key key}) : super(key: key);

  @override
  _ActivityHoursViewState createState() => _ActivityHoursViewState();
}

class _ActivityHoursViewState extends State<ActivityHoursView> {
  String fromDateTimeValue;
  String toDateTimeValue;
  String shopperName;

  bool newDay(int index) {
    var activityHours = StoreProvider.of<AppState>(context).state.shoppersReportsState.activityHours;
    if (index == 0) return true;
    return activityHours[index].startWorkAt.toString().split(' ')[0] !=
        activityHours[index - 1].startWorkAt.toString().split(' ')[0];
  }

  @override
  void initState() {
    fromDateTimeValue = 'يرجى أختيار تاريخ البداية';
    toDateTimeValue = 'يرجى إختيار تاريخ النهاية';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      distinct: true,
      builder: (context, state) {
        return SafeArea(
          child: Scaffold(
            appBar: AppBar(backgroundColor: primaryColor, title: Text('أوقات تفعيل التطبيق', style: appBarStyle)),
            body: SafeArea(
              child: Container(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    if (!Services.hasRole(context, shopperRole))
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.75,
                        child: KSearchableDropdown(
                          hint: chooseShopper,
                          search: shopperName,
                          items: Services.shoppersNameList(context),
                          onChanged: (value) => setState(() {
                            shopperName = value;
                            if (validDates()) {
                              StoreProvider.of<AppState>(context).dispatch(GetActivityHoursAction(
                                  shopperId: Services.selectedShopperId(shopperName, context),
                                  fromDate: fromDateTimeValue,
                                  toDate: toDateTimeValue));
                            }
                          }),
                        ),
                      ),
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
                          if (validDates() && (Services.hasRole(context, shopperRole) || shopperName != null)) {
                            StoreProvider.of<AppState>(context).dispatch(GetActivityHoursAction(
                                shopperId: Services.hasRole(context, shopperRole)
                                    ? state.shoppersState.shopper.id.toString()
                                    : Services.selectedShopperId(shopperName, context),
                                fromDate: fromDateTimeValue,
                                toDate: toDateTimeValue));
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
                        : state.shoppersReportsState.activityHours.isEmpty
                            ? const Padding(padding: EdgeInsets.all(75), child: ScreenMessage(message: 'لا يوجد حركة'))
                            : Expanded(
                                child: ListView.builder(
                                scrollDirection: Axis.vertical,
                                itemCount: state.shoppersReportsState.activityHours.length,
                                physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
                                itemBuilder: (BuildContext context, int index) {
                                  return ActiveHoursWidget(
                                      activityHour: state.shoppersReportsState.activityHours[index],
                                      newDay: newDay(index));
                                },
                              ))
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  bool validDates() {
    return fromDateTimeValue != 'يرجى أختيار تاريخ البداية' && toDateTimeValue != 'يرجى إختيار تاريخ النهاية';
  }
}
