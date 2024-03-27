import 'package:kammun_app/features/complaints/presentation/redux/complaints_action.dart';
import 'package:kammun_app/features/inventory/presentation/redux/inventory_action.dart';
import 'package:kammun_app/features/reports/presentation/redux/reports_action.dart';
import 'package:kammun_app/features/sub_warehouse_manager/presentation/redux/sub_warehouse_manager_action.dart';

import '../../../core/core_importer.dart';
import '../../../core/widget/management_view.dart';
import '../../admins/presentation/redux/admins_action.dart';
import '../../authentication/presentation/redux/authentication_action.dart';
import '../../products_filter/presentation/pages/products_filter_page.dart';
import '../../reports/presentation/pages/financial_report_page.dart';
import '../../reports/presentation/pages/sales_charts.dart';
import '../../reports/presentation/pages/sales_report.dart';
import '../../shoppers/presentation/pages/shoppers_management_page.dart';
import '../../shoppers_reports/presentation/pages/shopper_information_view.dart';
import '../../sub_warehouse_manager/presentation/pages/sub_warehouse_manager_page.dart';
import '../../supplier/presentation/pages/supplier_remaining_statment.dart';
import '../../supplier/presentation/redux/supplier_action.dart';
import '../../transactions/presentation/pages/add_transaction_page.dart';
import '../../transactions/presentation/redux/transactions_action.dart';

List<Widget> getDrawerChildren(BuildContext context) {
  var store = StoreProvider.of<AppState>(context);
  return [
    SideBarRow(icon: Icons.phone, text: 'الإتصال بكمون', onTap: () => Services.openUrl('number', context)),
    SideBarRow(icon: Icons.share, text: 'إرسال التطبيق للأصدقاء', onTap: () => Services.shareApp(context)),
    SideBarRow(pushedRoute: const ProfileScreen(), icon: Icons.person, text: profile),
    if (Services.hasRole(context, operationManagerRole))
      const SideBarRow(
          pushedRoute: ShopperManagementPage(), icon: Icons.supervisor_account_sharp, text: 'فريق التوصيل'),
    if (Services.hasPermission(context, transactionPermission))
      SideBarRow(
        text: financial,
        icon: Icons.account_balance,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ManagementView(
              title: financial,
              children: [
                SideBarRow(
                    onTap: () {
                      int adminId;
                      store.dispatch(NoError());
                      store.dispatch(FirstTransactionsPage());
                      if (!Services.hasPermission(context, advancedTransactionPermission)) {
                        adminId = store.state.adminsState.admin.id;
                        if (Services.hasRole(context, shopperRole)) {
                          store.dispatch(GetShopperReportAction(shopperId: store.state.adminsState.admin.shopper.id));
                        }
                      } else {
                        if (store.state.adminsState.admins.isEmpty) {
                          store.dispatch(GetAdminsWithoutDetailsAction(
                              roleId: Services.hasRole(context, mainCollectorRole) ? null : 3));
                        }
                        if (store.state.adminsState.roles.isEmpty && Services.hasRole(context, mainCollectorRole)) {
                          store.dispatch(GetRolesAction());
                        }
                      }
                      Navigator.push(
                          context, MaterialPageRoute(builder: (context) => TransactionsPage(adminId: adminId)));
                    },
                    icon: Icons.featured_play_list,
                    text: 'كشف حساب '),
                SideBarRow(
                    onTap: () {
                      store.dispatch(NoError());
                      store.dispatch(FirstRequestsPage());
                      store.dispatch(GetTransactionRequestsAction());
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const TransactionRequestsPage()));
                    },
                    icon: Icons.list_rounded,
                    text: 'طلبات مالية'),
                if(!Services.hasRole(context,productsControllerRole ) || !Services.hasRole(context,operationManagerRole )|| !Services.hasRole(context,superAdminRole)  )

                    SideBarRow(
                      onTap: () => Navigator.push(
                          context, MaterialPageRoute(builder: (context) => const AddTransactionPage(orderRequired: 0))),
                      icon: Icons.money,
                      text: addTransaction),
                if (Services.hasRole(context, shopperRole))
                  const SideBarRow(
                    icon: Icons.delivery_dining_rounded,
                    text: 'إحصائيات عامة',
                    pushedRoute: ShopperInformationView(),
                  ),
                if (Services.hasRole(context, accountingRole))
                  Column(
                    children: [
                      SideBarRow(
                        icon: Icons.account_balance_wallet_outlined,
                        onTap: () {
                          store.dispatch(SetRemainingStatment(remaining: []));
                          Navigator.push(context, MaterialPageRoute(builder: (_) => const SupplierRemainingAccounts()));
                        },
                        text: 'أرصدة الموردين',
                      ),
                      const SideBarRow(
                        icon: Icons.delivery_dining_rounded,
                        text: 'معلومات المتسوقين',
                        pushedRoute: ShopperInformationView(),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    if (Services.hasRole(context, supplierRole))
      SideBarRow(
        onTap: () {
          store.dispatch(SetRemainingStatment(remaining: []));
          Navigator.push(context, MaterialPageRoute(builder: (_) => const SupplierRemainingAccounts()));
        },
        icon: KIcons.coins,
        text: 'كشف حساب الزوائد',
      ),
    if (Services.hasRole(context, supplierRole))
      const SideBarRow(pushedRoute: SupplierAccounts(), icon: Icons.account_balance, text: 'كشف حساب المورد'),
    if (Services.hasRole(context, supplierRole) ||
        Services.hasRole(context, productsControllerRole) ||
        Services.hasRole(context, adminRole))
      SideBarRow(
          onTap: () {
            store.dispatch(InitExcelInventory());
            Navigator.push(context, MaterialPageRoute(builder: (context) => const SubWarehouseManagerPage()));
          },
          icon: Icons.inventory,
          text: 'إدارة المستودعات'),
    if (Services.hasRole(context, productsControllerRole) || Services.hasRole(context, supplierRole))
      SideBarRow(
        text: productManagement,
        icon: Icons.category,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ManagementView(
                title: productManagement,
                children: [
                  if (!Services.hasRole(context, supplierRole))
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SideBarRow(
                            onTap: () => store
                                .dispatch(GoToInventoryPage(context: context, inventoryType: InventoryTypes.added)),
                            icon: Icons.category,
                            text: 'المنتجات المضافة للمستودع'),
                        SideBarRow(
                            onTap: () => store
                                .dispatch(GoToInventoryPage(context: context, inventoryType: InventoryTypes.notAdded)),
                            icon: Icons.category_outlined,
                            text: 'المنتجات الغير مضافة للمستودع'),
                        if (Services.hasRole(context, adminRole))
                          SideBarRow(
                              onTap: () => store
                                  .dispatch(GoToInventoryPage(context: context, inventoryType: InventoryTypes.all)),
                              icon: Icons.category_rounded,
                              text: 'جميع المنتجات'),
                        const SideBarRow(
                          icon: Icons.filter_list_sharp,
                          text: 'فلترة المنتجات',
                          pushedRoute: ProductsFilterPage(),
                        ),
                      ],
                    ),
                  SideBarRow(
                      onTap: () => store.dispatch(
                          GoToInventoryPage(inventoryType: InventoryTypes.underCheckAvailability, context: context)),
                      icon: Icons.fact_check,
                      text: inventory),
                  SideBarRow(
                      onTap: () => store
                          .dispatch(GoToInventoryPage(inventoryType: InventoryTypes.notification, context: context)),
                      icon: Icons.notifications_active_rounded,
                      text: 'المنتجات على قائمة الانتظار'),
                  SideBarRow(
                      onTap: () =>
                          store.dispatch(GoToInventoryPage(inventoryType: InventoryTypes.prime, context: context)),
                      icon: Icons.label_important_rounded,
                      text: 'المنتجات الأساسية'),
                ],
              ),
            ),
          );
        },
      ),
    if (Services.hasPermission(context, viewAdminPanelPermission))
      SideBarRow(
        text: adminPanel,
        icon: Icons.admin_panel_settings,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ManagementView(
                    title: adminPanel,
                    children: [
                      SideBarRow(
                          onTap: () {
                            store.dispatch(InitReport());
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const SalesReport()));
                          },
                          icon: Icons.table_view_rounded,
                          text: 'تقرير المبيعات'),
                      if (Services.hasPermission(context, advancedAdminPanelPermission))
                        Column(
                          children: [
                            SideBarRow(
                                onTap: () {
                                  store.dispatch(InitReport());
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => const SalesCharts()));
                                },
                                icon: Icons.insert_chart_outlined_rounded,
                                text: 'إحصائيات المبيعات'),
                            SideBarRow(
                                onTap: () {
                                  store.dispatch(InitReport());
                                  Navigator.push(
                                      context, MaterialPageRoute(builder: (context) => const FinancialReportPage()));
                                },
                                icon: Icons.payment,
                                text: 'الأرباح والمستحقات المالية'),
                            SideBarRow(
                                onTap: () => store.dispatch(
                                    GoToInventoryPage(inventoryType: InventoryTypes.prices, context: context)),
                                icon: Icons.attach_money,
                                text: 'تغير الأسعار'),
                          ],
                        ),
                    ],
                  )),
        ),
      ),
    if (Services.hasRole(context, agentRole))
      const SideBarRow(icon: Icons.report_problem_rounded, text: 'إضافة شكوى', pushedRoute: AddComplaintPage()),
    if (Services.hasRole(context, agentRole))
      SideBarRow(
        icon: Icons.report_problem_rounded,
        text: 'الشكاوى',
        onTap: () {
          store.dispatch(GetComplaintAction(context: context));
          Navigator.push(context, MaterialPageRoute(builder: (_) => const ComplaintsPage()));
        },
      ),
    SideBarRow(
        icon: Icons.logout,
        text: 'تسجيل الخروج',
        onTap: () => StoreProvider.of<AppState>(context).dispatch(LogoutAction(context: context))),
  ];
}
