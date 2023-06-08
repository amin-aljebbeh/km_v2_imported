import 'core/core_importer.dart';
import 'features/cart/presentation/pages/cart_page.dart';
import 'features/orders/presentation/pages/orders_page.dart';
import 'features/supplier/presentation/pages/supplier_remaining_statment.dart';

final Map<String, WidgetBuilder> routes = {
  Prices.routeName: (_) => const Prices(),
  CartPage.routeName: (_) => const HomePage(),
  StoreView.routeName: (_) => const HomePage(),
  OrdersPage.routeName: (_) => const HomePage(),
  CouponsPage.routeName: (_) => const CouponsPage(),
  SalesReport.routeName: (_) => const SalesReport(),
  SalesCharts.routeName: (_) => const SalesCharts(),
  LoginScreen.routeName: (_) => const LoginScreen(),
  AllProducts.routeName: (_) => const AllProducts(),
  UserCouponsPage.routeName: (_) => UserCouponsPage(),
  InventoryPage.routeName: (_) => const InventoryPage(),
  ProfileScreen.routeName: (_) => const ProfileScreen(),
  ComplaintsPage.routeName: (_) => const ComplaintsPage(),
  GetSubWarehouse.routeName: (_) => const GetSubWarehouse(),
  AddComplaintPage.routeName: (_) => const AddComplaintPage(),
  SupplierAccounts.routeName: (_) => const SupplierAccounts(),
  ActivityHoursView.routeName: (_) => const ActivityHoursView(),
  ShopperMonthReport.routeName: (_) => const ShopperMonthReport(),
  FinancialReportView.routeName: (_) => const FinancialReportView(),
  TransactionRequestsPage.routeName: (_) => TransactionRequestsPage(),
  ProductsFilterScreen.routeName: (_) => const ProductsFilterScreen(),
  ShopperManagementView.routeName: (_) => const ShopperManagementView(),
  ShopperInformationView.routeName: (_) => const ShopperInformationView(),
  ShopperWorkingHoursView.routeName: (_) => const ShopperWorkingHoursView(),
  AddedProductsToWarehouse.routeName: (_) => const AddedProductsToWarehouse(),
  SupplierRemainingAccounts.routeName: (_) => const SupplierRemainingAccounts(),
  NotAddedProductsToWarehouse.routeName: (_) => const NotAddedProductsToWarehouse(),
};
