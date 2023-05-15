import '../../../../core/core_importer.dart';
import '../redux/supplier_action.dart';

class SupplierRemainingAccounts extends StatefulWidget {
  static const String routeName = '/SupplierRemainingAccounts';

  const SupplierRemainingAccounts({Key key}) : super(key: key);

  @override
  _SupplierRemainingAccountsState createState() => _SupplierRemainingAccountsState();
}

class _SupplierRemainingAccountsState extends State<SupplierRemainingAccounts> {
  String fromDateTimeValue;
  String toDateTimeValue;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      distinct: true,
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(backgroundColor: primaryColor, title: Text('كشف حساب زوائد مورد', style: appBarStyle)),
          body: TemporaryLoading(
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    KDatePicker(
                        onConfirmStart: (date) => fromDateTimeValue = date,
                        onConfirmEnd: (date) => toDateTimeValue = date),
                    KammunButton(
                      text: send,
                      color: Theme.of(context).primaryColor,
                      onTap: () {
                        if (validDates()) {
                          StoreProvider.of<AppState>(context)
                              .dispatch(GetRemainingStatementAction(to: toDateTimeValue, from: fromDateTimeValue));
                        } else {
                          Toast.show('الرجاء إدخال كافة البيانات', context,
                              duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
                        }
                      },
                      height: 50,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.65,
                        child: state.supplierState.remaining.isNotEmpty
                            ? ListView.builder(
                                padding: const EdgeInsets.only(bottom: 25),
                                scrollDirection: Axis.vertical,
                                physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
                                itemCount: state.supplierState.remaining.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Column(
                                    children: [
                                      if (index == 0)
                                        KTableRow(
                                          children: [
                                            KTableElement(text: 'المورد', style: mainStyle),
                                            KTableElement(text: 'الرصيد', style: mainStyle),
                                          ],
                                        ),
                                      KTableRow(
                                        children: [
                                          KTableElement(
                                              text: state.supplierState.remaining[index].name, style: mainStyle),
                                          KTableElement(
                                            text: StringUtils().oCcy.format(int.parse(
                                                state.supplierState.remaining[index].remainingMonyForSupplier)),
                                            style: mainStyle,
                                          ),
                                        ],
                                      )
                                    ],
                                  );
                                },
                              )
                            : const ScreenMessage(message: 'لا يوجد حركة'),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  bool validDates() => fromDateTimeValue != null && toDateTimeValue != null;
}
