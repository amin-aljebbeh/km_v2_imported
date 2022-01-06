const String TEST_URL = 'http://test.kammun.com';
const String APP_URL = 'https://kammun.app';

const String API = '/api/';

const String USER = 'user/';

// ignore: non_constant_identifier_names
String BASE_URL = APP_URL;

const String APPLE_BASE_URL = 'https://kammun.app';
const String PRODUCTION_BASE_URL = APP_URL;

const String GET_COMPANY = API + 'company';
const String GET_MOBILE_VERSION = API + 'mob_v_config';
const String GET_PRODUCT = API + 'product/';

const String ADD_IMAGE_TO_PRODUCTS = API + 'product_image';
const String GET_CATEGORY = API + 'category/';
const String GET_BANNER = API + 'banner/';
const String GET_SUPPORTED_CITY = API + 'supported_city';
const String GET_USER = API + USER + 'self/';
const String GET_USER_ORDER = API + USER + 'user_orders';
const String SYNC_CART = API + 'cart/sync_cart';
const String FAVORITES_PRODUCTS = API + USER + 'my_favorite_products/';

const String DELIVERY_METHODS = API + 'supported_city/get_delivery_methods/';
const String UPDATE_USER_SUPPORTED_CITY = API + USER + 'update_supported_city';

const String ADD_TO_FAVORITE = API + USER + 'add_product_to_favorites/';
const String REMOVE_FROM_FAVORITE =
    API + USER + 'remove_`product`_from_favorites/';
const String USER_ADDRESS = API + 'address';

const String OTP_VERIFICATION = API + 'verification_code/verify_account/';
//Orders:
const String ORDER = 'order/';

const String ORDERS_NOT_ASSIGNED_TO_DELIVERIES =
    API + ORDER + 'get_orders_not_assigned_to_deliveries';

const String GET_ORDERS_ASSIGNED_TO_DELIVERIES =
    API + ORDER + 'get_orders_assigned_to_deliveries';

const String DELIVERY_VIEWS_HIS_OWN_ORDERS =
    API + ORDER + 'delivery_views_his_own_orders';

const String GET_ORDERS_NOT_ASSIGNED_TO_SHOPPERS =
    API + ORDER + 'get_orders_not_assigned_to_shoppers';

const String GET_ORDERS_ASSIGNED_TO_SHOPPERS =
    API + ORDER + 'get_orders_assigned_to_shoppers';

const String SHOPPER_VIEWS_HIS_OWN_ORDERS =
    API + ORDER + 'shopper_views_his_own_orders';

const String UNLOCK_ORDER = API + ORDER + 'unlock_order/';

const String CANCEL_ORDER = API + ORDER + 'change_order_status/';

const String LOCK_ORDER = API + ORDER + 'lock_order/';

const String RATE_ORDER = API + ORDER + 'rate_order/';

const String ASSIGN_DELIVERY_ORDER_HIMSELF =
    API + ORDER + 'assign_delivery_order_himself/';

const String ASSIGN_SHOPPER_ORDER_HIMSELF =
    API + ORDER + 'assign_shopper_order_himself/';

const String ASSIGN_ORDER_TO_SHOPPER = API + ORDER + 'assign_order_to_shopper';

const String ASSIGN_ORDER_TO_DELIVERY =
    API + ORDER + 'assign_order_to_delivery';

/// NEW Version ///

const String GET_START_REQUEST = API + 'mobile/startup';

const String GET_SUPPORTED_CITIES = API + 'supported_city';

const String LOGIN_URL = API + 'auth/user_signin';

const String UPDATE_FIREBASE_TOKEN = API + USER + 'update_firebase_token';
