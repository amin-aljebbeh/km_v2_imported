import 'package:kammun_app/core/core_importer.dart';

const String product = 'product/';

const String admin = 'admin/';

const String shopper = 'shopper/';

const String warehouse = 'warehouse/';

const String subWarehouse = 'sub_warehouse/';

const String level = 'level/';

const String shopperTransaction = 'transaction_shopper/';

const String getSupplierOrder = api + order + 'get_supplier_order';

const String login = api + 'auth/admin_login';

const String updateFirebaseToken = api + admin + 'update_firebase_token';

const String getInventoryProducts = api + product + 'product_under_check_availability';

const String updatePriceRateThreshold = api + product + 'products_price_rate';

const String filterByNumberOfVisits = api + product + 'filter_by_number_of_visite';

const String filterByLastActivationDate = api + product + 'filter_by_last_activation_date';

const String productsDeletedFromOrders = api + product + 'filter_deleted_products_from_orders';

const String filterByNumberOfSales = api + product + 'filter_by_number_of_sale';

const String getPriceChanged = api + product + 'products_price_change';

const String productImage = api + 'product_image/';

const String addProductToCategory = api + product + 'add_product_to_category/';

const String removeProductFromCategory = api + product + 'delete_product_to_category/';

const String getDailyStatistics = api + 'get_daily_statistics';

const String getMatchingReport = api + 'matching_deliveried_products';

const String importProductActivationInWarehouse = api + 'import_product_activation_in_warehouse';

const String importProductPricesInWareHouse = api + 'import_product_prices_in_warehouse';

const String deleteProduct = api + product + '';

const String getAddedProductsToWarehouse = api + product + 'show_Additional_Products_For_Warehouse';

const String getNotAddedProductsToWarehouse = api + product + 'show_products_not_added_to_warehouse';

const String unAttachProductsToSubWarehouse = api + product + 'remove_product_from_sub_warehouse/';

const String attachProductsToSubWarehouse = api + product + 'add_product_to_sub_warehouse';

const String getWarehouses = api + warehouse;

const String updateSubWarehouseProducts = api + product + 'update_product_warehouse/';

const String getAdminInfo = api + admin;

const String getSubWarehouseProducts = api + subWarehouse;

const String updateOrderProducts = api + order + 'update_order_product/';

const String addImageToOrder = api + 'order_image';

const String deleteImageFromOrder = api + 'order_image';

const String getShopper = api + shopper;

const String changeShopperStatus = api + shopper + 'change_shopper_status/';

const String getLevel = api + level;

const String getShopperTransactions = api + shopper + shopperTransaction + 'shopper_transactions/';

const String getTransactionType = api + 'transaction_type';

const String getStatisticsShopperTransaction =
    api + shopper + shopperTransaction + 'statistics_shopper_transaction/';

const String shopperViewsHisOwnTransactions =
    api + shopper + shopperTransaction + 'shopper_views_his_own_transaction';

const String getShopperMonthProfit = api + shopper + shopperTransaction + 'shopper_profits_for_today/';

const String addTransaction = api + shopper + shopperTransaction + 'add_transaction';

const String remainingMoneyForSupplier = api + shopper + shopperTransaction + 'remining_mony_for_supplier';
