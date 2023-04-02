import 'package:kammun_app/features/transactions/presentation/redux/transactions_action.dart';
import 'package:kammun_app/features/transactions/presentation/widgets/shopper_report_widget.dart';

import '../../../../core/core_importer.dart';
import '../../../admins/presentation/redux/admins_action.dart';
import '../../domain/entities/admin_transaction_entity.dart';
import '../widgets/transaction_widget.dart';
import 'add_transaction_page.dart';

class TransactionsPage extends StatefulWidget {
  final int adminId;

  const TransactionsPage({Key key, this.adminId}) : super(key: key);

  @override
  _TransactionsPageState createState() => _TransactionsPageState();
}

class _TransactionsPageState extends State<TransactionsPage> {
  String adminId;
  String tempAdminId;
  int roleId;
  int warehouseId;
  bool grouping = false;
  bool myTransactions = false;

  @override
  void initState() {
    adminId = widget.adminId.toString();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (adminId != null && adminId != 'null') {
        StoreProvider.of<AppState>(context)
            .dispatch(GetTransactionsAction(adminId: int.parse(adminId), groupingByParent: grouping ? 1 : 0));
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
        List<DropdownMenuItem<int>> roles = state.adminsState.roles
            .map((role) => DropdownMenuItem<int>(
                child: AutoSizeText(role.name, style: mainStyle, maxFontSize: 15), value: role.id))
            .toList();
        roles.add(DropdownMenuItem<int>(child: Text('الكل', style: mainStyle), value: null));
        List<DropdownMenuItem<int>> warehouses = StaticVariables.warehouses
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
                    StoreProvider.of<AppState>(context).dispatch(
                        GetTransactionsAction(adminId: int.parse(adminId), groupingByParent: grouping ? 1 : 0));
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
                        if (state.adminsState.admin.permissions.contains('advanced-transaction-view'))
                          Column(
                            children: [
                              Container(
                                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                                width: MediaQuery.of(context).size.width,
                                child: Row(
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
                                                  store.dispatch(GetTransactionsAction(
                                                      adminId: int.parse(adminId), groupingByParent: grouping ? 1 : 0));
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
                                              value: grouping,
                                              onChanged: (bool value) {
                                                setState(() => grouping = value);
                                                store.dispatch(FirstTransactionsPage());
                                                store.dispatch(GetTransactionsAction(
                                                    adminId: int.parse(adminId), groupingByParent: grouping ? 1 : 0));
                                                if (isShopper(state)) {
                                                  store.dispatch(GetShopperReportAction(shopperId: shopperId(state)));
                                                }
                                              },
                                              activeColor: primaryColor),
                                          Text('تجميع', style: decisionButtonStyle.copyWith(color: Colors.black)),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                                width: MediaQuery.of(context).size.width,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    DropdownButton(
                                      items: warehouses,
                                      hint: Text('المستودع', style: mainStyle),
                                      value: warehouseId,
                                      onChanged: (value) {
                                        store.dispatch(
                                            GetAdminsWithoutDetailsAction(roleId: roleId, warehouseId: warehouseId));
                                        setState(() {
                                          adminId = null;
                                          warehouseId = value;
                                        });
                                      },
                                    ),
                                    DropdownButton(
                                        items: roles,
                                        hint: Text('منصب الأدمن', style: mainStyle),
                                        value: roleId,
                                        onChanged: (value) {
                                          store.dispatch(
                                              GetAdminsWithoutDetailsAction(roleId: roleId, warehouseId: warehouseId));
                                          setState(() {
                                            adminId = null;
                                            roleId = value;
                                          });
                                        })
                                  ],
                                ),
                              ),
                              KSearchableDropdown(
                                hint: 'اختر أدمن',
                                padding: 0,
                                search: adminId,
                                items: state.adminsState.admins
                                    .map((admin) => DropdownMenuItem<String>(
                                        child: Center(child: Text(admin.name, style: dropdownItemStyle)),
                                        value: admin.name))
                                    .toList(),
                                onChanged: (value) {
                                  myTransactions = false;
                                  adminId =
                                      state.adminsState.admins.firstWhere((admin) => admin.name == value).id.toString();
                                  store.dispatch(FirstTransactionsPage());
                                  store.dispatch(GetTransactionsAction(
                                      adminId: int.parse(adminId), groupingByParent: grouping ? 1 : 0));
                                  if (isShopper(state)) {
                                    store.dispatch(GetShopperReportAction(shopperId: shopperId(state)));
                                  }
                                },
                              ),
                            ],
                          ),
                        if ((adminId != null && adminId != 'null') ||
                            (!state.adminsState.admin.permissions.contains('advanced-transaction-view')))
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
                                        child: NotificationListener<ScrollEndNotification>(
                                          onNotification: (ScrollEndNotification scrollInfo) {
                                            if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent &&
                                                state.transactionsState.hasNextTransactions) {
                                              store.dispatch(NextTransactionsPage());
                                              store.dispatch(GetTransactionsAction(
                                                  adminId: int.parse(adminId), groupingByParent: grouping ? 1 : 0));
                                            }
                                            return;
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 8),
                                            child: ListView.builder(
                                                physics: const AlwaysScrollableScrollPhysics(
                                                    parent: BouncingScrollPhysics()),
                                                primary: false,
                                                scrollDirection: Axis.vertical,
                                                shrinkWrap: true,
                                                itemCount: state.transactionsState.transactions.length,
                                                itemBuilder: (BuildContext context, int index) => TransactionWidget(
                                                      transaction: state.transactionsState.transactions[index],
                                                      newTransaction:
                                                          newTransaction(index, state.transactionsState.transactions),
                                                    )),
                                          ),
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
                          KammunButton(
                            width: MediaQuery.of(context).size.width / 3,
                            height: 50,
                            padding: 0,
                            text: addTransaction,
                            color: primaryColor,
                            onTap: () => Navigator.push(context,
                                MaterialPageRoute(builder: (context) => const AddTransactionPage(orderRequired: 0))),
                          ),
                          if (adminId != null && adminId != 'null')
                            KammunButton(
                              width: MediaQuery.of(context).size.width / 3,
                              height: 50,
                              padding: 0,
                              text: 'المستحقات المالية',
                              color: primaryColor,
                              onTap: () {
                                store.dispatch(GetAdminBalanceAction(
                                    context: context,
                                    adminId: state.adminsState.admin.permissions.contains('advanced-transaction-view')
                                        ? int.parse(adminId)
                                        : state.adminsState.admin.id));
                              },
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
    if (adminId == null || adminId == 'null') return false;
    if (myTransactions) return false;
    if (Services.isShopper()) return true;
    if (!state.adminsState.admin.permissions.contains('advanced-transaction-view')) return false;
    return (state.adminsState.admins.firstWhere((admin) => admin.id.toString() == adminId).shopper != null);
  }

  int shopperId(AppState state) {
    return (state.adminsState.admins.firstWhere((admin) => admin.id.toString() == adminId).shopper.id);
  }
}
