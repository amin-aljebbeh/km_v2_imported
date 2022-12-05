import 'package:kammun_app/features/loading/loading_services.dart';

import '../../core/core_importer.dart';
import 'models/supplier_account_model.dart';
import 'services/reports_services.dart';

class SupplierRemainingAccounts extends StatefulWidget {
  static const String routeName = '/SupplierRemainingAccounts';
  const SupplierRemainingAccounts({Key key}) : super(key: key);

  @override
  _SupplierRemainingAccountsState createState() => _SupplierRemainingAccountsState();
}

class _SupplierRemainingAccountsState extends State<SupplierRemainingAccounts> {
  String fromDateTimeValue = 'يرجى أختيار تاريخ البداية';
  String toDateTimeValue = 'يرجى إختيار تاريخ النهاية';
  List<SupplierAccountModel> accounts;
  bool isLoading;
  bool isError;
  bool selected;

  getSupplierAccounts() async {
    setState(() {
      selected = true;
      isError = false;
      isLoading = true;
    });

    var response = await ReportsServices.getSupplierAccounts(fromDate: fromDateTimeValue, toDate: toDateTimeValue);
    if (response != null) {
      accounts = response;
      if (Services.isSupplierManager()) {
        accounts.removeWhere((account) => !LoadingScreenServices.subWarehouses
            .map((subWarehouse) => subWarehouse.id)
            .toList()
            .contains(account.subWarehouseId));
      }
      setState(() => isLoading = false);
    } else {
      setState(() {
        isLoading = false;
        isError = true;
      });
    }
  }

  @override
  void initState() {
    isLoading = false;
    isError = false;
    selected = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: primaryColor, title: Text('كشف حساب مورد', style: mainStyle)),
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
                    getSupplierAccounts();
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
                  child: isError
                      ? Center(
                          child: AlertMessages(text: errorMessage, messageType: 'internetError', headerText: 'حدث خطأ'))
                      : isLoading
                          ? const Loader()
                          : selected
                              ? ListView.builder(
                                  padding: const EdgeInsets.only(bottom: 25),
                                  scrollDirection: Axis.vertical,
                                  itemCount: accounts.length + 1,
                                  itemBuilder: (BuildContext context, int index) {
                                    if (index == 0) {
                                      return KTableRow(
                                        children: [
                                          KTableElement(text: 'المورد', style: mainStyle),
                                          KTableElement(text: 'الرصيد', style: mainStyle),
                                        ],
                                      );
                                    }
                                    return KTableRow(
                                      children: [
                                        KTableElement(text: accounts[index - 1].name, style: mainStyle),
                                        KTableElement(
                                          text: StringUtils()
                                              .oCcy
                                              .format(int.parse(accounts[index - 1].remainingMonyForSupplier)),
                                          style: mainStyle,
                                        ),
                                      ],
                                    );
                                  },
                                )
                              : Container(),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  bool validDates() =>
      fromDateTimeValue != 'يرجى أختيار تاريخ البداية' && toDateTimeValue != 'يرجى إختيار تاريخ النهاية';
}
