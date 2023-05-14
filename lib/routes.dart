import 'package:kammun_app/features/supplier/presentation/redux/supplier_action.dart';

import 'core/core_importer.dart';
import 'features/supplier/presentation/pages/supplier_remaining_statment.dart';

final Map<String, WidgetBuilder> routes = {
  LoginScreen.routeName: (_) => const LoginScreen(),
  StoreView.routeName: (_) => const HomeView(routeIndex: 0),
  CartViewFinal.routeName: (_) => const CartViewFinal(),
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
  ProductsFilterScreen.routeName: (_) => const ProductsFilterScreen(),
  SupplierRemainingAccounts.routeName: (context) {
    StoreProvider.of<AppState>(context).dispatch(SetRemainingStatment(remaining: []));
    return SupplierRemainingAccounts();
  },
  SupplierAccounts.routeName: (_) => const SupplierAccounts(),
  ShopperManagementView.routeName: (_) => const ShopperManagementView(),
  FinancialReportView.routeName: (_) => const FinancialReportView(),
  InventoryPage.routeName: (_) => const InventoryPage(),
  ComplaintsPage.routeName: (_) => const ComplaintsPage(),
  AddComplaintPage.routeName: (_) => const AddComplaintPage(),
  TransactionRequestsPage.routeName: (_) => const TransactionRequestsPage(),
  CouponsPage.routeName: (_) => const CouponsPage(),
  UserCouponsPage.routeName: (_) => const UserCouponsPage(),
  ShopperInformationView.routeName: (_) => const ShopperInformationView(),
};
