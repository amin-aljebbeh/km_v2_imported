import 'package:kammun_app/views/complaints/presentation/pages/add_complaint_page.dart';

import 'core/core_importer.dart';
import 'views/complaints/presentation/pages/complaints_page.dart';
import 'views/supplier/presentation/pages/supplier_statement_accounts.dart';

final Map<String, WidgetBuilder> routes = {
  LoginScreen.routeName: (_) => const LoginScreen(),
  StoreView.routeName: (_) => const HomeView(routeIndex: 0),
  CartViewFinal.routeName: (_) => const CartViewFinal(),
  ServerUpdate.routeName: (_) => const ServerUpdate(),
  ShopperMonthReport.routeName: (_) => const ShopperMonthReport(),
  ShopperWorkingHoursView.routeName: (_) => const ShopperWorkingHoursView(),
  ActivityHoursView.routeName: (_) => const ActivityHoursView(),
  CartView.routeName: (_) => const HomeView(routeIndex: 1),
  CartView.fromUpdateRouteName: (_) => const HomeView(routeIndex: 1, isFromUpdateOrder: true),
  OrdersView.routeName: (_) => const HomeView(routeIndex: 2),
  ProfileScreen.routeName: (_) => const ProfileScreen(),
  SalesReport.routeName: (_) => const SalesReport(),
  SalesCharts.routeName: (_) => const SalesCharts(),
  GetSubWarehouse.routeName: (_) => const GetSubWarehouse(),
  AddedProductsToWarehouse.routeName: (_) => const AddedProductsToWarehouse(),
  NotAddedProductsToWarehouse.routeName: (_) => const NotAddedProductsToWarehouse(),
  AllProducts.routeName: (_) => const AllProducts(),
  Prices.routeName: (_) => const Prices(),
  Inventory.routeName: (_) => const Inventory(),
  AccountantTransactionView.routeName: (_) => const AccountantTransactionView(),
  ShopperTransactionView.routeName: (_) => const ShopperTransactionView(),
  AddTransactionView.routeName: (_) => const AddTransactionView(),
  ProductsFilterScreen.routeName: (_) => const ProductsFilterScreen(),
  SupplierRemainingAccounts.routeName: (_) => const SupplierRemainingAccounts(),
  SupplierAccounts.routeName: (_) => const SupplierAccounts(),
  ShopperManagementView.routeName: (_) => const ShopperManagementView(),
  FinancialReportView.routeName: (_) => const FinancialReportView(),
  InventoryPage.routeName: (_) => const InventoryPage(),
  ComplaintsPage.routeName: (_) => const ComplaintsPage(),
  AddComplaintPage.routeName: (_) => const AddComplaintPage(),
};
