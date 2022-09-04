import 'package:intl/intl.dart';
import 'package:kammun_app/views/loading/loading_services.dart';

import '../../core/core_importer.dart';
import 'services/reports_services.dart';

class AddTransactionView extends StatefulWidget {
  static const String routeName = '/AddTransactionView';
  final String shopperName;
  final int orderId;

  const AddTransactionView({Key key, this.shopperName, this.orderId}) : super(key: key);

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
    if (widget.orderId != null) orderIdController.text = widget.orderId.toString();
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
      appBar: AppBar(backgroundColor: primaryColor, title: Text('إضافة مناقلة', style: mainStyle)),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 20, top: 0, right: 20, bottom: 10),
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: ListView(
              children: [
                const SizedBox(height: 20),
                KSearchableDropdown(
                  hint: chooseShopper,
                  search: shopperFilter,
                  items: Services.shoppersNameList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        shopperFilter = value;
                        shopperName = value;
                      });
                    }
                  },
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: DropdownButton(
                    underline: Container(),
                    isExpanded: true,
                    hint: Center(child: Text('نوع المناقلة', style: dropdownItemStyle)),
                    value: transactionTypeIndex,
                    items: Services.transactionTypesNames(),
                    onChanged: (value) => setState(() {
                      transactionTypeIndex = value;
                      transactionTypeString = LoadingScreenServices.transactionTypes
                          .where((type) => type.automatic == 0)
                          .toList()[transactionTypeIndex]
                          .arabicName;
                    }),
                  ),
                ),
                const SizedBox(height: 30),
                TextFieldRow(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  controller: moneyController,
                  text: 'المبلغ :         ',
                  inputType: TextInputType.text,
                  width: 150,
                ),
                const SizedBox(height: 40),
                TextFieldRow(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  controller: orderIdController,
                  text: 'رقم الطلب :',
                  inputType: TextInputType.text,
                  width: 150,
                ),
                const SizedBox(height: 40),
                TextFieldRow(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  controller: descriptionController,
                  text: 'الوصف :',
                  inputType: TextInputType.text,
                  width: MediaQuery.of(context).size.width * 0.65,
                ),
                const SizedBox(height: 20),
                KammunButton(
                  height: 50,
                  text: addTransaction,
                  color: !completeData() ? searchGreyColor : primaryColor,
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
                            bool result = await ReportsServices.addTransactionService(
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
                        DialogButton(text: 'لا', onTap: () => Navigator.of(context).pop()),
                      ];
                      showMyDialog(
                        context: context,
                        title: transactionTypeString,
                        text: 'هل تريد تأكيد إتمام العملية ؟',
                        dialogButtons: decisionButton,
                      );
                    }
                  },
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.6),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool completeData() {
    if (transactionTypeIndex != null) {
      if (LoadingScreenServices.transactionTypes
              .where((type) => type.automatic == 0)
              .toList()[transactionTypeIndex]
              .arabicName ==
          'خصم') {
        return shopperName != null && moneyController.text.isNotEmpty && descriptionController.text.isNotEmpty;
      } else {
        return shopperName != null && moneyController.text.isNotEmpty;
      }
    } else {
      return false;
    }
  }
}
