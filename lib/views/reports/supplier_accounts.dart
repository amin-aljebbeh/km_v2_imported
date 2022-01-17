import 'package:flutter/material.dart';
import 'package:kammun_app/utils/Styles.dart';
import 'package:kammun_app/utils/utils_importer.dart';
import 'package:kammun_app/views/Wedgit/widgets_importer.dart';
import 'package:intl/intl.dart';

import 'models/supplier_account_model.dart';
import 'services/reports_services.dart';

class SupplierAccounts extends StatefulWidget {
  @override
  _SupplierAccountsState createState() => _SupplierAccountsState();
}

class _SupplierAccountsState extends State<SupplierAccounts> {
  String fromDateTimeValue = "يرجى أختيار تاريخ البداية";
  String toDateTimeValue = "يرجى إختيار تاريخ النهاية";
  final DateFormat fullDateFormatter = DateFormat('yyyy-MM-dd HH:mm:ss');
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

    var response = await ReportsServices.getSupplierAccounts(
      fromDate: fromDateTimeValue,
      toDate: toDateTimeValue,
    );
    if (response != null) {
      accounts = response;
      setState(() {
        isLoading = false;
      });
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
      appBar: AppBar(
        title: Text(
          'أرصدة الموردين',
          style: mainStyle,
        ),
      ),
      body: SafeArea(
        child: Container(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView(
              shrinkWrap: true,
              children: [
                KDatePicker(
                  onConfirmStart: (date) {
                    setState(() {
                      fromDateTimeValue = date;
                    });
                  },
                  onConfirmEnd: (date) {
                    setState(() {
                      toDateTimeValue = date;
                    });
                  },
                ),
                KammunButton(
                  text: StringUtils.send,
                  color: validDates() ? Theme.of(context).primaryColor : ColorUtils.searchGreyColor,
                  onTap: () {
                    if (validDates())
                      getSupplierAccounts();
                    else
                      Toast.show('الرجاء إدخال كافة البيانات', context,
                          duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
                  },
                  height: 50,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.65,
                    child: isError
                        ? Center(
                            child: AlertMessages(
                              text: "حطأ أثناء جلب البيانات",
                              messageType: "internetError",
                              headerText: "حدث خطأ",
                            ),
                          )
                        : isLoading
                            ? Loader()
                            : selected
                                ? ListView.builder(
                                    scrollDirection: Axis.vertical,
                                    itemCount: accounts.length + 1,
                                    itemBuilder: (BuildContext context, int index) {
                                      if (index == 0)
                                        return KTableRow(
                                          children: [
                                            KTableElement(
                                              text: 'المورد',
                                              style: mainStyle,
                                            ),
                                            KTableElement(
                                              text: 'الرصيد',
                                              style: mainStyle,
                                            ),
                                          ],
                                        );
                                      return KTableRow(
                                        children: [
                                          KTableElement(
                                            text: accounts[index - 1].name,
                                            style: mainStyle,
                                          ),
                                          KTableElement(
                                            text: StringUtils()
                                                .oCcy
                                                .format(int.parse(accounts[index - 1].remainingMonyForSupplier))
                                                .toString(),
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
      ),
    );
  }

  bool validDates() {
    return fromDateTimeValue != "يرجى أختيار تاريخ البداية" && toDateTimeValue != "يرجى إختيار تاريخ النهاية";
  }
}
