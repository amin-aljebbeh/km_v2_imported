import 'package:intl/intl.dart' as intl;
import 'package:kammun_app/features/transactions/presentation/redux/transactions_action.dart';

import '../../../../core/core_importer.dart';
import '../../domain/entities/admin_transaction_entity.dart';

class AddTransactionPage extends StatefulWidget {
  final int orderRequired;
  final int orderId;

  const AddTransactionPage({Key key, this.orderRequired, this.orderId}) : super(key: key);

  @override
  _AddTransactionPageState createState() => _AddTransactionPageState();
}

class _AddTransactionPageState extends State<AddTransactionPage> {
  int categoryId;
  int actorId;
  String deliveryDate;
  final moneyController = TextEditingController();
  final descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      distinct: true,
      builder: (context, state) {
        return SafeArea(
          child: Scaffold(
            appBar: AppBar(backgroundColor: primaryColor, title: Text('إضافة مناقلة', style: appBarStyle)),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: DropdownButton(
                                items: state.transactionsState.categories
                                    .where((category) => category.orderRequired == widget.orderRequired)
                                    .map((category) => DropdownMenuItem<int>(
                                        child: Text(category.name, style: mainStyle), value: category.id))
                                    .toList(),
                                onChanged: (value) {}),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: DropdownButton(
                                items: state.adminsState.transactionsActors
                                    .map((actor) => DropdownMenuItem<int>(
                                        child: Text(actor.name, style: mainStyle), value: actor.id))
                                    .toList(),
                                onChanged: (value) {}),
                          ),
                          IconButton(
                              onPressed: () {
                                showDatePicker(
                                        firstDate: DateTime(2022, 1, 1),
                                        initialDate: DateTime.now(),
                                        lastDate: DateTime.now(),
                                        context: context)
                                    .then((date) {
                                  if (date != null) deliveryDate = intl.DateFormat('yyyy-MM-dd ').format(date);
                                });
                              },
                              icon: Icon(Icons.date_range_rounded, color: primaryColor)),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFieldRow(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              controller: moneyController,
                              text: 'المبلغ :         ',
                              inputType: TextInputType.text,
                              width: 150,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFieldRow(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              controller: descriptionController,
                              text: 'الوصف :',
                              inputType: TextInputType.text,
                              width: MediaQuery.of(context).size.width * 0.65,
                            ),
                          ),
                          KammunButton(
                            color: primaryColor,
                            onTap: () => Navigator.push(
                                context, MaterialPageRoute(builder: (context) => const TransactionsPage())),
                            height: 50,
                            text: 'كشف حساب',
                          ),
                        ],
                      ),
                      physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    child: KammunButton(
                      height: 50,
                      text: addTransaction,
                      color: !completeData() ? searchGreyColor : primaryColor,
                      onTap: () async {
                        if (!completeData()) {
                          Toast.show('يرجى إدخال كافة البيانات', context,
                              duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
                        } else {
                          List<DialogButton> decisionButton = [
                            DialogButton(
                              text: 'نعم',
                              onTap: () async {
                                Navigator.of(context).pop();
                                StoreProvider.of<AppState>(context).dispatch(CreateTransactionAction(
                                    transactionEntity: AdminTransactionEntity(
                                        transactionCategoryId: categoryId,
                                        actorId: actorId,
                                        date: deliveryDate,
                                        value: int.parse(moneyController.text),
                                        description: descriptionController.text,
                                        orderId: widget.orderId)));
                              },
                            ),
                            DialogButton(text: 'لا', onTap: () => Navigator.of(context).pop()),
                          ];
                          showMyDialog(
                            context: context,
                            title: state.transactionsState.categories
                                .firstWhere((category) => category.id == categoryId)
                                .name,
                            text: 'هل تريد تأكيد إتمام العملية ؟',
                            dialogButtons: decisionButton,
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  bool completeData() {
    return shopperName != null &&
        descriptionController.text.isNotEmpty &&
        moneyController.text.isNotEmpty &&
        categoryId != null;
  }
}
