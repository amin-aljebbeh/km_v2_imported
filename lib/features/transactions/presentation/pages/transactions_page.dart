import 'package:kammun_app/features/transactions/presentation/redux/transactions_action.dart';
import 'package:kammun_app/features/transactions/presentation/widgets/shopper_report_widget.dart';

import '../../../../core/core_importer.dart';
import '../../../admins/presentation/redux/admins_action.dart';
import '../../domain/entities/admin_transaction_entity.dart';
import '../widgets/transaction_widget.dart';
import 'add_transaction_page.dart';

class TransactionsPage extends StatefulWidget {
  final int adminId;
  final bool isShopper;
  final String shupperName;
  const TransactionsPage({Key key, this.adminId, this.isShopper = false, this.shupperName}) : super(key: key);

  @override
  _TransactionsPageState createState() => _TransactionsPageState();
}

class _TransactionsPageState extends State<TransactionsPage> {
  String adminId;
  String shupperName;
  String tempAdminId;
  int roleId;
  int warehouseId;

  bool myTransactions = false;

  @override
  void initState() {
    shupperName = widget.shupperName;
    adminId = widget.adminId.toString();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!Services.hasRole(context, mainCollectorRole)) roleId = 3;
      if (adminId != null && adminId != 'null') {
        StoreProvider.of<AppState>(context).dispatch(GetTransactionsAction(adminId: int.parse(adminId)));
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var store = StoreProvider.of<AppState>(context);
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      builder: (context, state) {
        List<DropdownMenuItem<int>> roles = [];
        if (Services.hasRole(context, mainCollectorRole)) {
          roles.addAll(state.adminsState.roles
              .map((role) => DropdownMenuItem<int>(
                  child: AutoSizeText(role.name, style: mainStyle, maxFontSize: 15), value: role.id))
              .toList());
          roles.add(DropdownMenuItem<int>(child: Text('الكل', style: mainStyle), value: null));
        }
        List<DropdownMenuItem<int>> warehouses = state.generalInformationState.warehouses
            .map((warehouse) => DropdownMenuItem<int>(
                child: AutoSizeText(warehouse.name, style: mainStyle, maxFontSize: 15), value: warehouse.id))
            .toList();
        warehouses.add(DropdownMenuItem<int>(child: Text('الكل', style: mainStyle), value: null));
        return TemporaryLoading(
          child: Scaffold(
            appBar: AppBar(backgroundColor: primaryColor, title: Text('المناقلات', style: appBarStyle), actions: [
              IconButton(
                  onPressed: () {
                    StoreProvider.of<AppState>(context).dispatch(RefreshTransactions());
                    StoreProvider.of<AppState>(context).dispatch(GetTransactionsAction(adminId: int.parse(adminId)));
                  },
                  icon: const Icon(Icons.refresh, size: 35))
            ]),
            body: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: Column(
                      children: [
                        if (Services.hasPermission(context, advancedTransactionPermission))
                          Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Row(
                                      children: [
                                        Checkbox(
                                            value: myTransactions,
                                            onChanged: (bool value) {
                                              setState(() => myTransactions = value);
                                              if (!value && (tempAdminId == null || tempAdminId == 'null')) {
                                                store.dispatch(FirstTransactionsPage());
                                                if (value) {
                                                  tempAdminId = adminId;
                                                  adminId = state.adminsState.admin.id.toString();
                                                } else {
                                                  adminId = tempAdminId;
                                                }
                                              } else {
                                                if (value) {
                                                  tempAdminId = adminId;
                                                  adminId = state.adminsState.admin.id.toString();
                                                } else {
                                                  adminId = tempAdminId;
                                                }
                                                store.dispatch(FirstTransactionsPage());
                                                store.dispatch(GetTransactionsAction(adminId: int.parse(adminId)));
                                                if (isShopper(state)) {
                                                  store.dispatch(GetShopperReportAction(shopperId: shopperId(state)));
                                                }
                                              }
                                            },
                                            activeColor: primaryColor),
                                        Text('مناقلاتي', style: decisionButtonStyle.copyWith(color: Colors.black)),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Row(
                                      children: [
                                        Checkbox(
                                            value: state.transactionsState.groupingTransactions,
                                            onChanged: (bool value) {
                                              store.dispatch(SetGrouping(grouping: value));
                                              if (adminId != null && adminId != 'null') {
                                                store.dispatch(FirstTransactionsPage());
                                                store.dispatch(GetTransactionsAction(adminId: int.parse(adminId)));
                                                if (isShopper(state)) {
                                                  store.dispatch(GetShopperReportAction(shopperId: shopperId(state)));
                                                }
                                              }
                                            },
                                            activeColor: primaryColor),
                                        Text('تجميع', style: decisionButtonStyle.copyWith(color: Colors.black)),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              if (Services.hasRole(context, mainCollectorRole) ||
                                  Services.hasRole(context, superAdminRole))
                                Padding(
                                  padding: const EdgeInsets.only(right: 40.0),
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        DropdownButton(
                                          items: warehouses,
                                          hint: Text('المستودع', style: mainStyle),
                                          value: warehouseId,
                                          onChanged: (value) {
                                            setState(() {
                                              adminId = null;
                                              warehouseId = value;
                                            });
                                            store.dispatch(GetAdminsWithoutDetailsAction(
                                                roleId: roleId, warehouseId: warehouseId));
                                          },
                                        ),
                                        DropdownButton(
                                            items: roles,
                                            hint: Text('منصب الأدمن', style: mainStyle),
                                            value: roleId,
                                            onChanged: (value) {
                                              setState(() {
                                                adminId = null;
                                                roleId = value;
                                              });
                                              store.dispatch(GetAdminsWithoutDetailsAction(
                                                  roleId: roleId, warehouseId: warehouseId));
                                            })
                                      ],
                                    ),
                                  ),
                                ),
                              Row(
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.arrow_back, size: 30, color: primaryColor),
                                    onPressed: () {
                                      if (((adminId != null && adminId != 'null')) &&
                                          state.transactionsState.hasNextTransactions) {
                                        store.dispatch(NextTransactionsPage());
                                        store.dispatch(GetTransactionsAction(adminId: int.parse(adminId)));
                                      }
                                    },
                                  ),
                                  Expanded(
                                    child: KSearchableDropdown(
                                      hint: shupperName ?? 'اختر أدمن',
                                      padding: 0,
                                      search: shupperName,
                                      items: state.adminsState.admins
                                          .map((admin) => DropdownMenuItem<String>(
                                              child: Center(child: Text(admin.name, style: dropdownItemStyle)),
                                              value: admin.name ?? shupperName))
                                          .toList(),
                                      onChanged: (value) {
                                        myTransactions = false;
                                        adminId = state.adminsState.admins
                                            .firstWhere((admin) => admin.name == value)
                                            .id
                                            .toString();
                                        store.dispatch(FirstTransactionsPage());
                                        store.dispatch(GetTransactionsAction(adminId: int.parse(adminId)));
                                        if (isShopper(state)) {
                                          store.dispatch(GetShopperReportAction(shopperId: shopperId(state)));
                                        }
                                      },
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.arrow_forward, size: 40, color: primaryColor),
                                    onPressed: () {
                                      if (((adminId != null && adminId != 'null')) &&
                                          state.transactionsState.transactionsPage > 1) {
                                        store.dispatch(PreviousTransactionsPage());
                                        store.dispatch(GetTransactionsAction(adminId: int.parse(adminId)));
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        if ((adminId != null && adminId != 'null') ||
                            (!Services.hasPermission(context, advancedTransactionPermission)))
                          if (isShopper(state)) const ShopperReportWidget(),
                        state.loadingState.loading.isNotEmpty
                            ? const Center(child: Loader())
                            : state.errorState.isError && state.transactionsState.transactions.isEmpty
                                ? Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Center(child: Text(state.errorState.errorMessage, style: paragraphStyle)))
                                : state.transactionsState.transactions.isEmpty && state.loadingState.loading.isEmpty
                                    ? Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Center(child: Text('لا يوجد مناقلات', style: paragraphStyle)))
                                    : Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 8),
                                          child: ListView.builder(
                                              physics:
                                                  const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
                                              primary: false,
                                              scrollDirection: Axis.vertical,
                                              shrinkWrap: true,
                                              itemCount: state.transactionsState.transactions.length,
                                              itemBuilder: (BuildContext ctx, int index) => TransactionWidget(
                                                    transaction: state.transactionsState.transactions[index],
                                                    ctx: context,
                                                    adminId: int.parse(adminId),
                                                    newTransaction:
                                                        newTransaction(index, state.transactionsState.transactions),
                                                  )),
                                        ),
                                      ),
                        if (!state.transactionsState.hasNextTransactions && state.loadingState.loading.isEmpty)
                          Center(child: Text('تم عرض جميع المناقلات', style: paragraphStyle)),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 16, top: 0, bottom: 16, right: 16),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          if (Services.hasRole(context, accountingRole) ||
                              Services.hasRole(context, agentRole) ||
                              Services.hasRole(context, collectorRole) ||
                              Services.hasRole(context, mainCollectorRole))
                            KammunButton(
                              width: MediaQuery.of(context).size.width / 3,
                              height: 50,
                              padding: EdgeInsets.zero,
                              text: addTransaction,
                              color: primaryColor,
                              onTap: () => Navigator.push(context,
                                  MaterialPageRoute(builder: (context) => const AddTransactionPage(orderRequired: 0))),
                            ),
                          if (adminId != null && adminId != 'null')
                            Expanded(
                              child: KammunButton(
                                width: MediaQuery.of(context).size.width / 3,
                                height: 50,
                                padding: const EdgeInsets.only(right: 5),
                                text: 'المستحقات المالية',
                                color: primaryColor,
                                onTap: () {
                                  store.dispatch(GetAdminBalanceAction(
                                      context: context,
                                      adminId: Services.hasPermission(context, advancedTransactionPermission)
                                          ? int.parse(adminId)
                                          : state.adminsState.admin.id));
                                },
                              ),
                            ),
                        ],
                      ),
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

  bool newTransaction(int index, List<AdminTransactionEntity> transactions) {
    if (index == 0) return true;
    return transactions[index].createdAt.toString().split(' ')[0] !=
        transactions[index - 1].createdAt.toString().split(' ')[0];
  }

  bool isShopper(AppState state) {
    if (widget.isShopper) return true;
    if (adminId == null || adminId == 'null') return false;
    if (myTransactions) return false;
    if (Services.hasRole(context, shopperRole)) return true;
    if (!Services.hasPermission(context, advancedTransactionPermission)) return false;
    return (state.adminsState.admins.firstWhere((admin) => admin.id.toString() == adminId).shopper != null);
  }

  int shopperId(AppState state) {
    return (state.adminsState.admins.firstWhere((admin) => admin.id.toString() == adminId).shopper.id);
  }
}
