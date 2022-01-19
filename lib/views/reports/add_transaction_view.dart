import 'package:flutter/material.dart';
import 'package:kammun_app/utils/utils_importer.dart';
import 'package:kammun_app/views/Wedgit/widgets_importer.dart';
import 'package:intl/intl.dart';
import 'package:kammun_app/views/loading/LoadingServices.dart';
import 'services/reports_services.dart';
import '../../Services.dart';

// ignore: must_be_immutable
class AddTransactionView extends StatefulWidget {
  String shopperName;

  AddTransactionView({Key key, this.shopperName}) : super(key: key);

  @override
  _AddTransactionViewState createState() => _AddTransactionViewState();
}

class _AddTransactionViewState extends State<AddTransactionView> {
  bool start;
  int transactionTypeIndex;
  String transactionTypeString;
  final DateFormat fullDateFormatter = DateFormat('yyyy-MM-dd HH:mm:ss');
  final moneyController = TextEditingController();
  final orderIdController = TextEditingController();
  final descriptionController = TextEditingController();
  String shopperName;
  String shopperId;

  @override
  void initState() {
    start = true;
    shopperName = widget.shopperName;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String shopperFilter;
    if (start && widget.shopperName != null) shopperFilter = shopperName;
    start = false;
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColorLight,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          'إضافة مناقلة',
          style: mainStyle,
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(left: 20, top: 0, right: 20, bottom: 10),
          child: Container(
            height: MediaQuery.of(context).size.height,
            child: ListView(
              children: [
                SizedBox(
                  height: 20,
                ),
                KSearchableDropdown(
                  hint: StringUtils.chooseShopper,
                  search: shopperFilter,
                  items: Services.shoppersNameList(),
                  onChanged: (value) {
                    setState(
                      () {
                        shopperFilter = value;
                        shopperName = value;
                      },
                    );
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: DropdownButton(
                    underline: Container(),
                    isExpanded: true,
                    hint: Center(
                      child: Text(
                        'نوع المناقلة',
                        style: dropdownItemStyle,
                      ),
                    ),
                    value: transactionTypeIndex,
                    items: Services.transactionTypesNames(),
                    onChanged: (value) {
                      setState(() {
                        transactionTypeIndex = value;
                        transactionTypeString = StringUtils.transactionTypesMap[LoadingScreenServices
                            .transactionTypes
                            .where((type) => type.automatic == 0)
                            .toList()[transactionTypeIndex]
                            .slug];
                      });
                    },
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                TextFieldRow(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  controller: moneyController,
                  text: 'المبلغ :         ',
                  inputType: TextInputType.number,
                  width: 150,
                ),
                SizedBox(
                  height: 40,
                ),
                if (transactionTypeString == 'خصم')
                  Column(
                    children: [
                      TextFieldRow(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        controller: orderIdController,
                        text: 'رقم الطلب :',
                        inputType: TextInputType.number,
                        width: 150,
                      ),
                      SizedBox(
                        height: 40,
                      ),
                    ],
                  ),
                TextFieldRow(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  controller: descriptionController,
                  text: 'الوصف :',
                  inputType: TextInputType.text,
                  width: MediaQuery.of(context).size.width * 0.65,
                ),
                SizedBox(
                  height: 20,
                ),
                KammunButton(
                  height: 50,
                  text: 'حفظ المناقلة',
                  color: !completeData() ? ColorUtils.searchGreyColor : ColorUtils.primaryColor,
                  onTap: () async {
                    if (!completeData()) {
                      Toast.show("يرجى إدخال كافة البيانات", context,
                          duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
                    } else {
                      List<DialogButton> decisionButton = [
                        DialogButton(
                          text: 'نعم',
                          onTap: () async {
                            Navigator.of(context).pop();
                            String description =
                                descriptionController.text.isNotEmpty ? descriptionController.text : ' ';
                            shopperId = Services.selectedShopperId(shopperName);
                            Tools.logToConsole('message from add transaction');
                            Tools.logToConsole(shopperId);
                            Tools.logToConsole(LoadingScreenServices.transactionTypes
                                .where((type) => type.automatic == 0)
                                .toList()[transactionTypeIndex]
                                .id
                                .toString());
                            Tools.logToConsole(moneyController.text);
                            bool result = await ReportsServices.addTransaction(
                              shopperId: shopperId,
                              value: moneyController.text,
                              transactionTypeId: LoadingScreenServices.transactionTypes
                                  .where((type) => type.automatic == 0)
                                  .toList()[transactionTypeIndex]
                                  .id
                                  .toString(),
                              description: description,
                              orderId: orderIdController.text,
                            );
                            Services.resultFlushBar(context: context, result: result);
                          },
                        ),
                        DialogButton(
                          text: 'لا',
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ];
                      showMyDialog(
                        title: transactionTypeString,
                        context: context,
                        text: 'هل تريد تأكيد إتمام العملية ؟',
                        dialogButtons: decisionButton,
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool completeData() {
    if (transactionTypeIndex != null) {
      if (StringUtils.transactionTypesMap[LoadingScreenServices.transactionTypes
              .where((type) => type.automatic == 0)
              .toList()[transactionTypeIndex]
              .slug] ==
          'خصم')
        return shopperName != null && moneyController.text.isNotEmpty && descriptionController.text.isNotEmpty;
      else
        return shopperName != null && moneyController.text.isNotEmpty;
    } else {
      return false;
    }
  }
}
