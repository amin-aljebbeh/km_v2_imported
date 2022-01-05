import 'api_importer.dart';

const String PRODUCT = 'product/';

const String ADMIN = 'admin/';

const String SHOPPER = 'admin/';

const String WAREHOUSE = 'warehouse/';

const String SUB_WAREHOUSE = 'sub_warehouse/';

const String LEVEL = 'level/';

const String GET_SUPPLIER_ORDER = API + ORDER + 'get_supplier_order';

const String LOGIN_ADMIN = API + 'auth/admin_login';

const String UPDATE_ADMIN_FIREBASE_TOKEN =
    API + ADMIN + 'update_firebase_token';

const String GET_INVENTORY_PRODUCTS =
    API + PRODUCT + 'product_under_check_availability';

const String GET_PRICES_CHANGES = API + PRODUCT + 'products_price_change';

const String PRODUCT_IMAGE = API + 'product_image/';

const String ADD_PRODUCTS_TO_CATEGORY =
    API + PRODUCT + 'add_product_to_category/';

const String REMOVE_PRODUCT_FROM_CATEGORY =
    API + PRODUCT + 'delete_product_to_category/';

const String GET_DAILY_STATISTICS = API + 'get_daily_statistics';

const String GET_MATCHING_REPORT = API + 'matching_deliveried_products';

const String DELETE_PRODUCT = API + PRODUCT + '';

const String GET_ADDED_PRODUCTS_TO_WAREHOUSE =
    API + PRODUCT + 'show_Additional_Products_For_Warehouse';

const String GET_NOT_ADDED_PRODUCTS_TO_WAREHOUSE =
    API + PRODUCT + 'show_products_not_added_to_warehouse';

const String UN_ATTACH_PRODUCTS_TO_SUB_WAREHOUSE =
    API + PRODUCT + 'remove_product_from_sub_warehouse/';

const String ATTACH_PRODUCTS_TO_SUB_WAREHOUSE =
    API + PRODUCT + 'add_product_to_sub_warehouse';

const String GET_SUB_WAREHOUSE = API + ADMIN + 'get_sub_warehouses_admin';

const String GET_WAREHOUSE = API + WAREHOUSE;

const String UPDATE_SUB_WAREHOUSE_PRODUCTS =
    API + PRODUCT + 'update_product_warehouse/';

const String GET_ADMIN_INFO = API + ADMIN;

const String GET_SUB_WAREHOUSE_PRODUCTS = API + SUB_WAREHOUSE;

const String UPDATE_ORDER_PRODUCTS = API + ORDER + 'update_order_product/';

const String ADD_IMAGE_TO_ORDER = API + 'order_image';

const String DELETE_IMAGE_FROM_ORDER = API + 'order_image';

const String GET_SHOPPER = API + SHOPPER;

const String CHANGE_SHOPPER_STATUS = API + SHOPPER + 'change_shopper_status/';

const String GET_LEVEL = API + LEVEL;

const String GET_DELIVERIES = API + 'delivery';
