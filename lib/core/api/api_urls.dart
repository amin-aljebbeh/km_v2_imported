String baseUrl = 'https://kammun.app';

const String appleBaseUrl = 'http://test.kammun.com';
const String productionBaseUrl = 'https://kammun.app';

////////////////////////////////////////////////////////////////////

const String user = 'user/';

const String cart = 'cart/';

const String order = 'order/';

const String coupon = 'coupon/';

const String search = 'search/';

const String product = 'product/';

const String category = 'category/';

const String supportedCity = 'supported_city/';

const String address = 'address/';

const String alertProduct = 'alert_product/';

const String paymentMethod = 'payment_method/';

////////////////////////////////////////////////////////////////////
const String searchProducts = product + search;
const String getProduct = product;
const String newlyAddedProducts = product + 'newly_added_products/';
const String featuredProducts = product + 'get_featured_products/';

const String getUserOrder = user + 'user_orders';
const String favoritesProducts = user + 'my_favorite_products/';
const String deliveryMethods = address + 'get_delivery_methods/';
const String updateUserSupportedCity = user + 'update_supported_city';
const String addToFavorite = user + 'add_product_to_favorites/';
const String removeFromFavorite = user + 'remove_product_from_favorites/';
const String storeUserError = user + 'store_user_error/';
const String updateFirebaseToken = user + 'update_firebase_token';
const String getMyAlertProductsList = user + 'get_my_alert_products_list';

const String cancelOrder = order + 'change_order_status/';
const String lockOrder = order + 'lock_order/';
const String rateOrder = order + 'rate_order/';
const String checkInvoiceUrl = order + 'check_invoice_create_order/';
const String checkInvoiceOnUpdateUrl = order + 'check_invoice_update_order/';
const String cancelCouponOnOrder = order + 'cancel_coupon_on_order/';

const String otpVerification = 'verification_code/verify_account/';

/// NEW Version ///

const String getStartRequest = 'mobile/startup_mobile';

const String loginUrl = 'auth/user_signin';

// BareCode

const String productBarcode = 'product_barcode/';

const String searchProductByBarcode = productBarcode + search;

const String syncCart = cart + 'sync_cart/';

const String addProductToCart = cart + 'add_product_to_cart/';

const String voteSupportedCity = supportedCity + 'vote';
