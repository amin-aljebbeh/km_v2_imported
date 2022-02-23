// ignore: non_constant_identifier_names
String BASE_URL = 'https://kammun.app';

const String APPLE_BASE_URL = 'http://kmbe.kammun.com';
const String PRODUCTION_BASE_URL = 'https://kammun.app';

////////////////////////////////////////////////////////////////////

const String API = '/api/';

const String USER = 'user/';

const String ORDER = 'order/';

const String SEARCH = 'search/';

const String PRODUCT = 'product/';

const String CATEGORY = 'category/';

const String SUPPORTED_CITY = 'supported_city/';

////////////////////////////////////////////////////////////////////
const String GET_CATEGORY = API + CATEGORY;
const String SEARCH_PRODUCTS = API + PRODUCT + SEARCH;
const String GET_PRODUCT = API + PRODUCT;
const String GET_USER_ORDER = API + USER + 'user_orders';
const String SYNC_CART = API + 'cart/sync_cart';
const String CANCEL_ORDER = API + ORDER + 'change_order_status/';
const String FAVORAITES_PRODUCTS = API + USER + 'my_favorite_products/';
const String DELIVERY_METHODS = API + SUPPORTED_CITY + 'get_delivery_methods/';
const String UPDATE_USER_SUPPORTED_CITY = API + USER + 'update_supported_city';

const String ADD_TO_FAVORITE = API + USER + 'add_product_to_favorites/';
const String REMOVE_FROM_FAVORITE = API + USER + 'remove_product_from_favorites/';
const String USER_ADDRESS = API + 'address';
const String LOCK_ORDER = API + ORDER + 'lock_order/';
const String RATE_ORDER = API + ORDER + 'rate_order/';

const String OTP_VERIFICATION = API + 'verification_code/verify_account/';

/// NEW Version ///

const String GET_START_REQUEST = API + 'mobile/startup';

const String GET_SUPPORTED_CITIES = API + SUPPORTED_CITY;

const String LOGIN_URL = API + 'auth/user_signin';

const String UPDATE_FIREBASE_TOKEN = API + USER + 'update_firebase_token';

// BareCode

const String PRODUCT_BARCODE = API + 'product_barcode/';

const String SEARCH_PRODUCT_BY_BARCODE = PRODUCT_BARCODE + SEARCH;
