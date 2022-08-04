const String testUrl = 'http://test.kammun.com';
const String appUrl = 'https://kammun.app';

const String user = 'user/';

const String search = 'search/';

const String address = 'address/';

const String supportedCity = 'supported_city/';

String baseUrl = appUrl;

const String appleBaseUrl = 'https://kammun.app';
const String productionBaseUrl = appUrl;

const String getCompany = 'company';
const String getMobileVersion = 'mob_v_config';
const String getProduct = product;

const String addImageToProduct = 'product_image';
const String getCategory = 'category/';
const String getBanner = 'banner/';
const String getSupportedCities = supportedCity;
const String getUser = user + 'self/';
const String getUserOrder = user + 'user_orders';
const String syncCart = 'cart/sync_cart';
const String favoritesProducts = user + 'my_favorite_products/';

const String deliveryMethods = supportedCity + 'get_delivery_methods/';
const String updateUserSupportedCity = user + 'update_supported_city';

const String addToFavorite = user + 'add_product_to_favorites/';
const String removeFromFavorite = user + 'remove_`product`_from_favorites/';
const String userAddress = address;

const String otpVerification = 'verification_code/verify_account/';
//Orders:
const String order = 'order/';

const String deliveryViewsHisOwnOrders = order + 'delivery_views_his_own_orders';

const String shopperViewsHisOwnOrders = order + 'shopper_views_his_own_orders';

const String unlockOrder = order + 'unlock_order/';

const String cancelOrder = order + 'change_order_status/';

const String lockOrder = order + 'lock_order/';

const String assignOrderToShopper = order + 'assign_order_to_shopper';

const String changeOrderStatus = order + 'change_order_status/';

const String getOrdersByUserPhoneNumber = order + 'get_order_by_phone/';

// BareCode

const String productBarcode = 'product_barcode/';

const String searchProductByBarcode = productBarcode + search;

const String checkProductBarcode = productBarcode + 'search_in_products/';

// Products:

const String searchProducts = product + search;
//// admin

const String product = 'product/';

const String admin = 'admin/';

const String shopper = 'shopper/';

const String warehouse = 'warehouse/';

const String subWarehouse = 'sub_warehouse/';

const String level = 'level/';

const String shopperTransaction = 'transaction_shopper/';

const String getSupplierOrder = order + 'get_supplier_order';

const String login = 'auth/admin_login';

const String updateFirebaseToken = admin + 'update_firebase_token';

const String getInventoryProducts = product + 'product_under_check_availability';

const String updatePriceRateThreshold = product + 'products_price_rate';

const String filterByNumberOfVisits = product + 'filter_by_number_of_visite';

const String filterByLastActivationDate = product + 'filter_by_last_activation_date';

const String productsDeletedFromOrders = product + 'filter_deleted_products_from_orders';

const String filterByNumberOfSales = product + 'filter_by_number_of_sale';

const String getPriceChanged = product + 'products_price_change';

const String productImage = 'product_image/';

const String addProductToCategory = product + 'add_product_to_category/';

const String removeProductFromCategory = product + 'delete_product_to_category/';

const String getDailyStatistics = 'get_daily_statistics';

const String getMatchingReport = 'matching_deliveried_products';

const String importProductActivationInWarehouse = 'import_product_activation_in_warehouse';

const String importProductPricesInWareHouse = 'import_product_prices_in_warehouse';

const String deleteProduct = product;

const String getAddedProductsToWarehouse = product + 'show_Additional_Products_For_Warehouse';

const String getNotAddedProductsToWarehouse = product + 'show_products_not_added_to_warehouse';

const String unAttachProductsToSubWarehouse = product + 'remove_product_from_sub_warehouse/';

const String attachProductsToSubWarehouse = product + 'add_product_to_sub_warehouse';

const String getWarehouses = warehouse;

const String updateSubWarehouseProducts = product + 'update_product_warehouse/';

const String getAdminInfo = admin;

const String updateOrderProducts = order + 'update_order_product/';

const String addImageToOrder = 'order_image';

const String deleteImageFromOrder = 'order_image';

const String getShopper = shopper;

const String changeShopperStatus = shopper + 'change_shopper_status/';

const String getLevel = level;

const String getShopperTransactions = shopper + shopperTransaction + 'shopper_transactions/';

const String getTransactionType = 'transaction_type';

const String getStatisticsShopperTransaction = shopper + shopperTransaction + 'statistics_shopper_transaction/';

const String shopperViewsHisOwnTransactions = shopper + shopperTransaction + 'shopper_views_his_own_transaction';

const String getShopperMonthProfit = shopper + shopperTransaction + 'shopper_profits_for_today/';

const String addTransaction = shopper + shopperTransaction + 'add_transaction';

const String remainingMoneyForSupplier = shopper + shopperTransaction + 'remining_mony_for_supplier';

const String financialReportUrl = shopper + shopperTransaction + 'statistics_financial_transactions_with_shoppers';

const String getWorkingHour = shopper + 'get_working_hour/';

const String monthlyShopperReports = shopper + 'monthly_shopper_reports/';

const String shopperActivityHours = shopper + 'shopper_activity_hours/';
