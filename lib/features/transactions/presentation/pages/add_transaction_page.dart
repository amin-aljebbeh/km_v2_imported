import 'package:kammun_app/features/transactions/presentation/redux/transactions_action.dart';

import '../../../../core/core_importer.dart';
import '../../../admins/presentation/redux/admins_action.dart';
import '../../domain/entities/admin_transaction_entity.dart';
import '../../domain/entities/transaction_category_entity.dart';

class AddTransactionPage extends StatefulWidget {
  final int orderRequired;
  final int orderId;
  final int userId;

  const AddTransactionPage({Key key, this.orderRequired, this.orderId, this.userId}) : super(key: key);

  @override
  _AddTransactionPageState createState() => _AddTransactionPageState();
}

class _AddTransactionPageState extends State<AddTransactionPage> {
  TransactionCategoryEntity category;
  int categoryId;
  String adminId;
  String shupperName;
  final moneyController = TextEditingController();
  final descriptionController = TextEditingController();

  @override
  void initState() {
    WidgetsBinding.instance
        .addPostFrameCallback((_) => StoreProvider.of<AppState>(context).dispatch(SetTransactionsActors(admins: [])));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var store = StoreProvider.of<AppState>(context);
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      distinct: true,
      builder: (context, state) {
        return TemporaryLoading(
          child: SafeArea(
            child: Scaffold(
              appBar: AppBar(backgroundColor: primaryColor, title: Text('إضافة مناقلة', style: appBarStyle)),
              body: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('نوع المناقلة: ', style: paragraphStyle),
                                      DropdownButton(
                                          items: state.transactionsState.categories
                                              .where((category) =>
                                                  category.orderRequired == widget.orderRequired ||
                                                  category.orderRequired == 2)
                                              .map((category) => DropdownMenuItem<int>(
                                                  child: AutoSizeText(category.name, style: mainStyle, maxFontSize: 15),
                                                  value: category.id))
                                              .toList(),
                                          hint: Text('اختر نوع المناقلة', style: mainStyle),
                                          value: categoryId,
                                          onChanged: (value) {
                                            setState(() {
                                              adminId = null;
                                              category = state.transactionsState.categories
                                                  .firstWhere((category) => category.id == value);
                                              categoryId = value;
                                            });
                                            if (chooseAdmin()) {
                                              store.dispatch(GetTransactionsActorsAction(categoryId: value));
                                            }
                                          }),
                                    ],
                                  ),
                                ),
                              ),
                              if (chooseAdmin())
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: SizedBox(
                                   // width: MediaQuery.of(context).size.width,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('الأدمن: ', style: paragraphStyle),
                                        Expanded(
                                          child: KSearchableDropdown(
                                            hint: 'اختر أدمن',
                                            padding: 0,
                                            disableHint: 'اختر نوع مناقلة أولاً',
                                            search: adminId,
                                            items: state.adminsState.transactionsActors
                                                .map((actor) => DropdownMenuItem<String>(
                                                    child: AutoSizeText(actor.name, style: mainStyle, maxFontSize: 15),
                                                    value: actor.name))
                                                .toList(),
                                            onChanged: (value)  {

                                                adminId = state.adminsState.transactionsActors
                                                    .firstWhere((admin) => admin.name == value)
                                                    .id
                                                    .toString();
                                                shupperName =  value;


                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8),
                                child: TextFieldRow(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  controller: moneyController,
                                  onChange: () => setState(() {}),
                                  text: 'المبلغ :',
                                  inputType: TextInputType.number,
                                    width: MediaQuery.of(context).size.width * 0.65,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8),
                                child: TextFieldRow(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  onChange: () => setState(() {}),
                                  controller: descriptionController,
                                  text: 'الوصف :',
                                  inputType: TextInputType.text,
                                  width: MediaQuery.of(context).size.width * 0.65,
                                ),
                              ),
                            ],
                          ),
                        ),
                        physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      child: Column(
                        children: [
                          KammunButton(
                            color: primaryColor,
                            onTap: () {
                              int id;

                              if (!Services.hasPermission(context, advancedTransactionPermission)) {
                                id = state.adminsState.admin.id;

                                if (Services.hasRole(context, shopperRole)) {
                                  store.dispatch(GetShopperReportAction(shopperId: state.adminsState.admin.shopper.id));
                                }
                              } else {
                                if (store.state.adminsState.admins.isEmpty) {
                                  store.dispatch(GetAdminsWithoutDetailsAction(
                                      roleId: Services.hasRole(context, mainCollectorRole) ? null : 3));
                                }
                                if (store.state.adminsState.roles.isEmpty) store.dispatch(GetRolesAction());
                                if (adminId != null) {
                                  id = int.parse(adminId);
                                  if (state.adminsState.admins
                                          .firstWhere((admin) => admin.id.toString() == adminId)
                                          .shopper !=
                                      null) {
                                    store.dispatch(GetShopperReportAction(
                                        shopperId: state.adminsState.admins
                                            .firstWhere((admin) => admin.id.toString() == adminId)
                                            .shopper
                                            .id));
                                  }
                                }
                              }
                              Navigator.push(
                                  context, MaterialPageRoute(builder: (context) => TransactionsPage(adminId: id , shupperName: shupperName,)));
                            },
                            height: 50,
                            text: 'كشف حساب',
                          ),
                          if(!Services.hasRole(context,productsControllerRole ) || !Services.hasRole(context,operationManagerRole )|| !Services.hasRole(context,superAdminRole)  )

                            KammunButton(
                            height: 50,
                            text: addTransaction,
                            color: !completeData() ? searchGreyColor : primaryColor,
                            onTap: () async {
                              if (!completeData()) {
                                Toast.show('يرجى إدخال كافة البيانات',
                                    duration: Toast.lengthLong, gravity: Toast.center);
                              } else {
                                print(adminId);
                                List<DialogButton> decisionButton = [
                                  DialogButton(
                                    text: 'نعم',
                                    onTap: () async {
                                      Navigator.of(context).pop();
                                      store.dispatch(CreateTransactionAction(
                                          context: context,
                                          transactionEntity: AdminTransactionEntity(
                                              transactionCategoryId: category.id,
                                              actorId: chooseAdmin() ? int.parse(adminId) : null,
                                              userId: widget.userId,
                                              adminId: chooseAdmin() ? int.parse(adminId) : null,
                                              value: int.parse(moneyController.text).abs(),
                                              description: descriptionController.text,
                                              orderId: widget.orderId)));
                                      moneyController.clear() ;
                                      descriptionController.clear();
                                    },
                                  ),
                                  DialogButton(text: 'لا', onTap: () => Navigator.of(context).pop()),
                                ];
                                showMyDialog(
                                  context: context,
                                  title: category.name,
                                  text: 'هل تريد تأكيد إتمام العملية ؟',
                                  dialogButtons: decisionButton,
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
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
    if (category.transactionOperation.affectUser == 1) return false;
    if (category.selfTransaction == 1) {
      if ([30, 31].contains(category.id)) {
        return true;
      }
      return false;
    }
    return ((category.requestRequired == 0 && category.transactionOperation.affectActor == 0) ||
        (category.requestRequired != 0 && category.transactionOperation.affectActor != 0));
  }

  bool completeData() {
    return (descriptionController.text.isNotEmpty &&
            moneyController.text.isNotEmpty &&
            adminId != null &&
            category != null) ||
        (descriptionController.text.isNotEmpty &&
            moneyController.text.isNotEmpty &&
            category != null &&
            !chooseAdmin());
  }
}
