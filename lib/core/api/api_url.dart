import 'package:kammun_app/core/core_importer.dart';

const String testUrl = 'http://test.kammun.com';
const String appUrl = 'https://kammun.app';

const String api = '/api/';

const String user = 'user/';

const String search = 'search/';

const String address = 'address/';

const String supportedCity = 'supported_city/';

String baseUrl = appUrl;

const String appleBaseUrl = 'https://kammun.app';
const String productionBaseUrl = appUrl;

const String getCompany = api + 'company';
const String getMobileVersion = api + 'mob_v_config';
const String getProduct = api + product;

const String addImageToProduct = api + 'product_image';
const String getCategory = api + 'category/';
const String getBanner = api + 'banner/';
const String getSupportedCities = api + supportedCity;
const String getUser = api + user + 'self/';
const String getUserOrder = api + user + 'user_orders';
const String syncCart = api + 'cart/sync_cart';
const String favoritesProducts = api + user + 'my_favorite_products/';

const String deliveryMethods = api + supportedCity + 'get_delivery_methods/';
const String updateUserSupportedCity = api + user + 'update_supported_city';

const String addToFavorite = api + user + 'add_product_to_favorites/';
const String removeFromFavorite = api + user + 'remove_`product`_from_favorites/';
const String userAddress = api + address;

const String otpVerification = api + 'verification_code/verify_account/';
//Orders:
const String order = 'order/';

const String deliveryViewsHisOwnOrders = api + order + 'delivery_views_his_own_orders';

const String shopperViewsHisOwnOrders = api + order + 'shopper_views_his_own_orders';

const String unlockOrder = api + order + 'unlock_order/';

const String cancelOrder = api + order + 'change_order_status/';

const String lockOrder = api + order + 'lock_order/';

const String assignOrderToShopper = api + order + 'assign_order_to_shopper';

const String changeOrderStatus = api + order + 'change_order_status/';

const String getOrdersByUserPhoneNumber = api + order + 'get_order_by_phone/';

// BareCode

const String productBarcode = api + 'product_barcode/';

const String searchProductByBarcode = productBarcode + search;

const String checkProductBarcode = productBarcode + 'search_in_products/';

// Products:

const String searchProducts = api + product + search;
