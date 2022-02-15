import 'package:kammun_app/core/core_importer.dart';

const String PRODUCT = 'product/';

const String ADMIN = 'admin/';

const String SHOPPER = 'shopper/';

const String WAREHOUSE = 'warehouse/';

const String SUB_WAREHOUSE = 'sub_warehouse/';

const String LEVEL = 'level/';

const String SHOPPER_TRANSACTION = 'transaction_shopper/';

const String GET_SUPPLIER_ORDER = API + ORDER + 'get_supplier_order';

const String LOGIN_ADMIN = API + 'auth/admin_login';

const String UPDATE_ADMIN_FIREBASE_TOKEN = API + ADMIN + 'update_firebase_token';

const String GET_INVENTORY_PRODUCTS = API + PRODUCT + 'product_under_check_availability';

const String UPDATE_PRICE_RATE_THRESHOLD = API + PRODUCT + 'products_price_rate';

const String FILTER_BY_NUMBER_OF_VISITS = API + PRODUCT + 'filter_by_number_of_visite';

const String FILTER_BY_LAST_ACTIVATION_DATE = API + PRODUCT + 'filter_by_last_activation_date';

const String FILTER_BY_NUMBER_OF_SALES = API + PRODUCT + 'filter_by_number_of_sale';

const String GET_PRICES_CHANGES = API + PRODUCT + 'products_price_change';

const String PRODUCT_IMAGE = API + 'product_image/';

const String ADD_PRODUCTS_TO_CATEGORY = API + PRODUCT + 'add_product_to_category/';

const String REMOVE_PRODUCT_FROM_CATEGORY = API + PRODUCT + 'delete_product_to_category/';

const String GET_DAILY_STATISTICS = API + 'get_daily_statistics';

const String GET_MATCHING_REPORT = API + 'matching_deliveried_products';

const String DELETE_PRODUCT = API + PRODUCT + '';

const String GET_ADDED_PRODUCTS_TO_WAREHOUSE = API + PRODUCT + 'show_Additional_Products_For_Warehouse';

const String GET_NOT_ADDED_PRODUCTS_TO_WAREHOUSE = API + PRODUCT + 'show_products_not_added_to_warehouse';

const String UN_ATTACH_PRODUCTS_TO_SUB_WAREHOUSE = API + PRODUCT + 'remove_product_from_sub_warehouse/';

const String ATTACH_PRODUCTS_TO_SUB_WAREHOUSE = API + PRODUCT + 'add_product_to_sub_warehouse';

const String GET_SUB_WAREHOUSE = API + ADMIN + 'get_sub_warehouses_admin';

const String GET_WAREHOUSE = API + WAREHOUSE;

const String UPDATE_SUB_WAREHOUSE_PRODUCTS = API + PRODUCT + 'update_product_warehouse/';

const String GET_ADMIN_INFO = API + ADMIN;

const String GET_SUB_WAREHOUSE_PRODUCTS = API + SUB_WAREHOUSE;

const String UPDATE_ORDER_PRODUCTS = API + ORDER + 'update_order_product/';

const String ADD_IMAGE_TO_ORDER = API + 'order_image';

const String DELETE_IMAGE_FROM_ORDER = API + 'order_image';

const String GET_SHOPPER = API + SHOPPER;

const String CHANGE_SHOPPER_STATUS = API + SHOPPER + 'change_shopper_status/';

const String GET_LEVEL = API + LEVEL;

const String GET_SHOPPER_TRANSACTIONS = API + SHOPPER + SHOPPER_TRANSACTION + 'shopper_transactions/';

const String GET_TRANSACTION_TYPES = API + 'transaction_type';

const String GET_MANUAL_TRANSACTION_TYPES = GET_TRANSACTION_TYPES + 'manual_transaction_type';

const String GET_STATISTICS_SHOPPER_TRANSACTION =
    API + SHOPPER + SHOPPER_TRANSACTION + 'statistics_shopper_transaction/';

const String SHOPPER_VIEWS_HIS_OWN_TRANSACTION =
    API + SHOPPER + SHOPPER_TRANSACTION + 'shopper_views_his_own_transaction';

const String GET_DAILY_SHOPPER_PROFIT = API + SHOPPER + SHOPPER_TRANSACTION + 'shopper_profits_for_today/';

const String ADD_TRANSACTION = API + SHOPPER + SHOPPER_TRANSACTION + 'add_transaction';

const String REMAINING_MONEY_FOR_SUPPLIER = API + SHOPPER + SHOPPER_TRANSACTION + 'remining_mony_for_supplier';

const String GET_SHOPPER_PROFIT_overOVER_DATE =
    API + SHOPPER + SHOPPER_TRANSACTION + 'get_shopper_profit_over_date';

const String GET_DELIVERIES = API + 'delivery';
