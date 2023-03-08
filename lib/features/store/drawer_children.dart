import 'package:kammun_app/features/complaints/presentation/redux/complaints_action.dart';
import 'package:kammun_app/features/inventory_feature/presentation/redux/inventory_action.dart';

import '../../core/core_importer.dart';
import '../login/Services/login_services.dart';
import '../management_view/management_view.dart';

List<Widget> getDrawerChildren(BuildContext context) {
  var store = StoreProvider.of<AppState>(context);
  return [
    SideBarRow(icon: Icons.phone, text: 'الإتصال بكمون', onTap: () => Services.openUrl('number')),
    SideBarRow(icon: Icons.share, text: 'إرسال التطبيق للأصدقاء', onTap: () => Services.shareApp()),
    SideBarRow(pushedRoute: ProfileScreen.routeName, icon: Icons.person, text: profile),
    if (Services.isOperationManager())
      const SideBarRow(
          pushedRoute: ShopperManagementView.routeName, icon: Icons.supervisor_account_sharp, text: 'فريق التوصيل'),
    if (Services.isShopper())
      const SideBarRow(
          pushedRoute: ShopperTransactionView.routeName, icon: Icons.featured_play_list, text: 'كشف حساب المتسوق'),
    if (Services.isAccounting())
      SideBarRow(
        text: financial,
        icon: Icons.account_balance,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ManagementView(
              title: financial,
              children: [
                const SideBarRow(
                    pushedRoute: AccountantTransactionView.routeName,
                    icon: Icons.featured_play_list,
                    text: 'كشف حساب المتسوق'),
                SideBarRow(pushedRoute: AddTransactionView.routeName, icon: Icons.money, text: addTransaction),
                const SideBarRow(
                    pushedRoute: SupplierRemainingAccounts.routeName,
                    icon: Icons.account_balance_wallet_outlined,
                    text: 'أرصدة الموردين'),
                SideBarRow(
                    icon: Icons.delivery_dining_rounded,
                    text: 'معلومات المتسوقين',
                    onTap: () =>
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const ShopperInformation()))),
              ],
            ),
          ),
        ),
      ),
    if (Services.isSupplierManager())
      const SideBarRow(pushedRoute: SupplierRemainingAccounts.routeName, icon: KIcons.coins, text: 'كشف حساب الزوائد'),
    if (Services.isSupplierManager())
      const SideBarRow(pushedRoute: SupplierAccounts.routeName, icon: Icons.account_balance, text: 'كشف حساب المورد'),
    if (Services.isSupplierManager() || Services.isProductsController() || Services.isAdmin())
      const SideBarRow(pushedRoute: GetSubWarehouse.routeName, icon: Icons.inventory, text: 'إدارة المستودعات'),
    if (Services.isProductsController() || Services.isSupplierManager())
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
                  if (!Services.isSupplierManager())
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
                        if (Services.isAdmin())
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
    if (Services.isAdmin() || Services.isSuperAdmin())
      SideBarRow(
        text: adminPanel,
        icon: Icons.admin_panel_settings,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ManagementView(
                    title: adminPanel,
                    children: const [
                      SideBarRow(
                          pushedRoute: SalesReport.routeName, icon: Icons.table_view_rounded, text: 'تقرير المبيعات'),
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
                  )),
        ),
      ),
    if (Services.isAgent())
      const SideBarRow(icon: Icons.report_problem_rounded, text: 'إضافة شكوى', pushedRoute: AddComplaintPage.routeName),
    if (Services.isAgent())
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
