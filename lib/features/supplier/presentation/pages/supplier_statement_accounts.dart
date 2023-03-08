import 'package:kammun_app/features/supplier/presentation/redux/supplier_action.dart';

import '../../../../core/core_importer.dart';

class SupplierAccounts extends StatefulWidget {
  static const String routeName = '/SupplierAccounts';
  const SupplierAccounts({Key key}) : super(key: key);

  @override
  _SupplierAccountsState createState() => _SupplierAccountsState();
}

class _SupplierAccountsState extends State<SupplierAccounts> {
  String fromDateTimeValue = 'يرجى أختيار تاريخ البداية';
  String toDateTimeValue = 'يرجى إختيار تاريخ النهاية';

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      distinct: true,
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(backgroundColor: primaryColor, title: Text('كشف حساب مورد', style: appBarStyle)),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView(
                shrinkWrap: true,
                children: [
                  KDatePicker(
                    onConfirmStart: (date) => setState(() => fromDateTimeValue = date),
                    onConfirmEnd: (date) => setState(() => toDateTimeValue = date),
                  ),
                  KammunButton(
                    text: send,
                    color: validDates() ? Theme.of(context).primaryColor : searchGreyColor,
                    onTap: () {
                      if (validDates()) {
                        StoreProvider.of<AppState>(context)
                            .dispatch(GetAccountStatement(from: fromDateTimeValue, to: toDateTimeValue));
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
                      child: state.errorState.isError
                          ? Center(
                              child: AlertMessages(
                                  text: errorMessage, messageType: 'internetError', headerText: 'حدث خطأ'))
                          : state.loadingState.isLoading
                              ? const Loader()
                              : state.supplierState.accountStatement.accountStatement.isEmpty
                                  ? Container()
                                  : ListView.builder(
                                      padding: const EdgeInsets.only(bottom: 25),
                                      scrollDirection: Axis.vertical,
                                      itemCount: state.supplierState.accountStatement.accountStatement.length,
                                      itemBuilder: (BuildContext context, int index) => KTableRow(
                                          children: state.supplierState.accountStatement.accountStatement[index]
                                              .asMap()
                                              .map((key, value) => index == 0
                                                  ? MapEntry(key, KTableElement(text: value, style: mainStyle))
                                                  : key == 0
                                                      ? MapEntry(key, KTableElement(text: value, style: mainStyle))
                                                      : MapEntry(
                                                          key,
                                                          KTableElement(
                                                              text: StringUtils().oCcy.format(int.parse(value)),
                                                              style: mainStyle)))
                                              .values
                                              .toList()),
                                    ),
                    ),
                  )
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
