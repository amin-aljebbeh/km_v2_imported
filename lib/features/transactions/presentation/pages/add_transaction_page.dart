import 'package:intl/intl.dart' as intl;
import 'package:kammun_app/features/transactions/presentation/redux/transactions_action.dart';

import '../../../../core/core_importer.dart';
import '../../domain/entities/admin_transaction_entity.dart';
import '../../domain/entities/transaction_category_entity.dart';

class AddTransactionPage extends StatefulWidget {
  final int orderRequired;
  final int orderId;
  final int userId;
  final int adminId;

  const AddTransactionPage({Key key, this.orderRequired, this.orderId, this.userId, this.adminId}) : super(key: key);

  @override
  _AddTransactionPageState createState() => _AddTransactionPageState();
}

class _AddTransactionPageState extends State<AddTransactionPage> {
  TransactionCategoryEntity category;
  int categoryId;
  int actorId;
  int adminId;
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
                                    .where((category) =>
                                        category.orderRequired == widget.orderRequired || category.orderRequired == 2)
                                    .map((category) => DropdownMenuItem<int>(
                                        child: Text(category.name, style: mainStyle), value: category.id))
                                    .toList(),
                                hint: Text('اختر نوع المناقلة', style: mainStyle),
                                value: categoryId,
                                onChanged: (value) => setState(() {
                                      category = state.transactionsState.categories
                                          .firstWhere((category) => category.id == value);
                                      categoryId = value;
                                    })),
                          ),
                          if (chooseAdmin())
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
                                        transactionCategoryId: category.id,
                                        actorId: actorId,
                                        userId: widget.userId,
                                        adminId: adminId,
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
                                .firstWhere((category) => category.id == category.id)
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

  bool chooseAdmin() {
    TransactionCategoryEntity category = this.category ??
        StoreProvider.of<AppState>(context)
            .state
            .transactionsState
            .categories
            .firstWhere((category) => category.orderRequired == widget.orderRequired || category.orderRequired == 2);
    return ((category.requestRequired == 0 && category.transactionOperation.affectActor == 0) ||
            (category.requestRequired != 0 && category.transactionOperation.affectActor != 0)) &&
        category.transactionOperation.affectUser == 0;
  }

  bool completeData() {
    return shopperName != null &&
        descriptionController.text.isNotEmpty &&
        moneyController.text.isNotEmpty &&
        category != null;
  }
}
