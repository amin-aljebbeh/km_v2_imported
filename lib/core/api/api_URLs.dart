String baseUrl = 'https://kammun.app';

const String appleBaseUrl = 'http://kmbe.kammun.com';
const String productionBaseUrl = 'https://kammun.app';

////////////////////////////////////////////////////////////////////

const String api = '/api/';

const String user = 'user/';

const String order = 'order/';

const String search = 'search/';

const String product = 'product/';

const String category = 'category/';

const String supportedCity = 'supported_city/';

////////////////////////////////////////////////////////////////////
const String getCategory = api + category;
const String searchProducts = api + product + search;
const String getProduct = api + product;
const String getUserOrder = api + user + 'user_orders';
const String syncCart = api + 'cart/sync_cart';
const String cancelOrder = api + order + 'change_order_status/';
const String favoritesProducts = api + user + 'my_favorite_products/';
const String deliveryMethods = api + supportedCity + 'get_delivery_methods/';
const String updateUserSupportedCity = api + user + 'update_supported_city';

const String addToFavorite = api + user + 'add_product_to_favorites/';
const String removeFromFavorite = api + user + 'remove_product_from_favorites/';
const String userAddress = api + 'address';
const String lockOrder = api + order + 'lock_order/';
const String rateOrder = api + order + 'rate_order/';

const String otpVerification = api + 'verification_code/verify_account/';

/// NEW Version ///

const String getStartRequest = api + 'mobile/startup';

const String getSupportedCities = api + supportedCity;

const String loginUrl = api + 'auth/user_signin';

const String updateFirebaseToken = api + user + 'update_firebase_token';

// BareCode

const String productBarcode = api + 'product_barcode/';

const String searchProductByBarcode = productBarcode + search;
