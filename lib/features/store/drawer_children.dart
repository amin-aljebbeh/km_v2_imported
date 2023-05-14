import 'package:kammun_app/features/complaints/presentation/redux/complaints_action.dart';
import 'package:kammun_app/features/inventory_feature/presentation/redux/inventory_action.dart';

import '../../core/core_importer.dart';
import '../admins/presentation/redux/admins_action.dart';
import '../login/Services/login_services.dart';
import '../management_view/management_view.dart';
import '../supplier/presentation/pages/supplier_remaining_statment.dart';
import '../transactions/presentation/pages/add_transaction_page.dart';
import '../transactions/presentation/redux/transactions_action.dart';

List<Widget> getDrawerChildren(BuildContext context) {
  var store = StoreProvider.of<AppState>(context);
  return [
    SideBarRow(icon: Icons.phone, text: 'الإتصال بكمون', onTap: () => Services.openUrl('number')),
    SideBarRow(icon: Icons.share, text: 'إرسال التطبيق للأصدقاء', onTap: () => Services.shareApp()),
    SideBarRow(pushedRoute: ProfileScreen.routeName, icon: Icons.person, text: profile),
    if (Services.hasRole(context, operationManagerRole))
      const SideBarRow(
          pushedRoute: ShopperManagementView.routeName, icon: Icons.supervisor_account_sharp, text: 'فريق التوصيل'),
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
                      Navigator.pushNamed(context, TransactionRequestsPage.routeName);
                    },
                    icon: Icons.list_rounded,
                    text: 'طلبات مالية'),
                SideBarRow(
                    onTap: () => Navigator.push(
                        context, MaterialPageRoute(builder: (context) => const AddTransactionPage(orderRequired: 0))),
                    icon: Icons.money,
                    text: addTransaction),
                if (Services.hasRole(context, shopperRole))
                  const SideBarRow(
                    icon: Icons.delivery_dining_rounded,
                    text: 'إحصائيات عامة',
                    pushedRoute: ShopperInformationView.routeName,
                  ),
                if (Services.hasRole(context, accountingRole))
                  Column(
                    children: const [
                      SideBarRow(
                          pushedRoute: SupplierRemainingAccounts.routeName,
                          icon: Icons.account_balance_wallet_outlined,
                          text: 'أرصدة الموردين'),
                      SideBarRow(
                        icon: Icons.delivery_dining_rounded,
                        text: 'معلومات المتسوقين',
                        pushedRoute: ShopperInformationView.routeName,
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    //todo clean
    if (Services.hasRole(context, supplierRole))
      const SideBarRow(pushedRoute: SupplierRemainingAccounts.routeName, icon: KIcons.coins, text: 'كشف حساب الزوائد'),
    if (Services.hasRole(context, supplierRole))
      const SideBarRow(pushedRoute: SupplierAccounts.routeName, icon: Icons.account_balance, text: 'كشف حساب المورد'),
    if (Services.hasRole(context, supplierRole) ||
        Services.hasRole(context, productsControllerRole) ||
        Services.hasRole(context, adminRole))
      const SideBarRow(pushedRoute: GetSubWarehouse.routeName, icon: Icons.inventory, text: 'إدارة المستودعات'),
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
                        const SideBarRow(
                            pushedRoute: AddedProductsToWarehouse.routeName,
                            icon: Icons.category,
                            text: 'المنتجات المضافة للمستودع'),
                        const SideBarRow(
                            pushedRoute: NotAddedProductsToWarehouse.routeName,
                            icon: Icons.category_outlined,
                            text: 'المنتجات الغير مضافة للمستودع'),
                        if (Services.hasRole(context, adminRole))
                          const SideBarRow(
                              pushedRoute: AllProducts.routeName, icon: Icons.category_rounded, text: 'جميع المنتجات'),
                        const SideBarRow(
                          icon: Icons.filter_list_sharp,
                          text: 'فلترة المنتجات',
                          pushedRoute: ProductsFilterScreen.routeName,
                        ),
                      ],
                    ),
                  SideBarRow(
                      onTap: () {
                        store.dispatch(SetSearchFilter(searchFilter: ''));
                        store.dispatch(SetIsActive(isActive: 0));
                        store.dispatch(NoError());
                        store.dispatch(SetInventoryType(inventoryType: InventoryTypes.underCheckAvailability));
                        store.dispatch(SetSubWarehouseId(subWarehouseId: -1));
                        Navigator.pushNamed(context, InventoryPage.routeName);
                      },
                      icon: Icons.fact_check,
                      text: inventory),
                  SideBarRow(
                      onTap: () {
                        store.dispatch(SetSearchFilter(searchFilter: ''));
                        store.dispatch(SetIsActive(isActive: 0));
                        store.dispatch(NoError());
                        store.dispatch(SetInventoryType(inventoryType: InventoryTypes.notification));
                        store.dispatch(SetSubWarehouseId(subWarehouseId: -1));
                        Navigator.pushNamed(context, InventoryPage.routeName);
                      },
                      icon: Icons.notifications_active_rounded,
                      text: 'المنتجات على قائمة الانتظار'),
                  SideBarRow(
                      onTap: () {
                        store.dispatch(SetSearchFilter(searchFilter: ''));
                        store.dispatch(SetIsActive(isActive: 0));
                        store.dispatch(NoError());
                        store.dispatch(SetInventoryType(inventoryType: InventoryTypes.prime));
                        store.dispatch(SetSubWarehouseId(subWarehouseId: -1));
                        Navigator.pushNamed(context, InventoryPage.routeName);
                      },
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
                      const SideBarRow(
                          pushedRoute: SalesReport.routeName, icon: Icons.table_view_rounded, text: 'تقرير المبيعات'),
                      if (Services.hasPermission(context, advancedAdminPanelPermission))
                        Column(
                          children: const [
                            SideBarRow(
                                pushedRoute: SalesCharts.routeName,
                                icon: Icons.insert_chart_outlined_rounded,
                                text: 'إحصائيات المبيعات'),
                            SideBarRow(
                                pushedRoute: FinancialReportView.routeName,
                                icon: Icons.payment,
                                text: 'الأرباح والمستحقات المالية'),
                            SideBarRow(pushedRoute: Prices.routeName, icon: Icons.attach_money, text: 'تغير الأسعار'),
                          ],
                        ),
                    ],
                  )),
        ),
      ),
    if (Services.hasRole(context, agentRole))
      const SideBarRow(icon: Icons.report_problem_rounded, text: 'إضافة شكوى', pushedRoute: AddComplaintPage.routeName),
    if (Services.hasRole(context, agentRole))
      SideBarRow(
        icon: Icons.report_problem_rounded,
        text: 'الشكاوى',
        onTap: () {
          store.dispatch(GetComplaintAction(context: context));
          Navigator.of(context).pushNamed(ComplaintsPage.routeName);
        },
      ),
    SideBarRow(icon: Icons.logout, text: 'تسجيل الخروج', onTap: () async => await LoginServices.logOutAdmin(context)),
  ];
}
