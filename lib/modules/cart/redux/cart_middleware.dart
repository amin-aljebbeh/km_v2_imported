import 'package:kammun_app/modules/cart/redux/cart_action.dart';
import 'package:kammun_app/modules/cart/view/cart_view.dart';
import '../../../core/core_importer.dart';
import '../../order/redux/order_action.dart';
import '../service/cart_services.dart';

Future<void> cartMiddleware(Store<AppState> store, action, NextDispatcher next) async {
  if (action is SaveCart) {
    CartServices.cartChanged(cartProducts: action.cartProducts);
    store.dispatch(CartLoadedSuccessfully(cartProducts: action.cartProducts));
  } else if (action is LoadCart) {
    List<ProductData> result = await CartServices.getUserCart();
    if (result != null) {
      store.dispatch(CartLoadedSuccessfully(cartProducts: result));
      if (action.goToCart) store.dispatch(PushAndReplace(routeName: CartView.routeName));
    } else {
      store.dispatch(CatchError(errorMessage: 'حدث خطأ أثناء محاولة جلب السلة'));
    }
    store.dispatch(StopLoading());
  } else if (action is CartLoadedSuccessfully) {
    store.dispatch(NoError());
  } else if (action is AddProductToCart) {
    List<ProductData> cartProducts = [];
    cartProducts.addAll(store.state.cartState.cartProducts);
    if (cartProducts.map((product) => product.id).toList().contains(action.product.id)) {
      int count = cartProducts.firstWhere((product) => product.id == action.product.id).productCount +
          action.product.productCount;
      store.dispatch(UpdateCartProduct(productId: action.product.id, count: count));
      if (action.sync) {
        store.dispatch(SyncAddProduct(product: ProductData(id: action.product.id, productCount: count)));
      }
    } else {
      cartProducts.add(action.product);
      store.dispatch(SaveCart(cartProducts: cartProducts));
      store.dispatch(SyncAddProduct(product: action.product));
    }
  } else if (action is RemoveProduct) {
    List<ProductData> cartProducts = [];
    cartProducts.addAll(store.state.cartState.cartProducts);
    cartProducts.removeWhere((product) => product.id == action.productId);
    store.dispatch(SaveCart(cartProducts: cartProducts));
  } else if (action is ClearCart) {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('userCart');
  } else if (action is UpdateOrderPrices) {
    List<ProductData> products = [];
    products.addAll(store.state.orderState.notActiveProducts);
    for (int i = 0; i < products.length; i++) {
      var product = products[i];
      store.dispatch(RemoveProduct(productId: product.id));
    }
    store.dispatch(StartLoading());
    store.dispatch(LoadCart(goToCart: true));
    store.dispatch(SetOrderProblemProducts(notActiveProducts: [], priceProducts: []));
  } else if (action is UpdateCartProduct) {
    List<ProductData> cartProducts = [];
    cartProducts.addAll(store.state.cartState.cartProducts);
    cartProducts.firstWhere((product) => product.id == action.productId).productCount = action.count;
    store.dispatch(SaveCart(cartProducts: cartProducts));
  } else if (action is CheckLimitTotalCost) {
    if (store.state.startupState.startModel.user.limitTotalCost < store.state.cartState.subtotal) {
      showMyDialog(
          title: 'لا يمكن الاستمرار',
          dialogButtons: [const CloseWidget()],
          text: 'إن قيمة المنتجات التي تحاول طلبها تتجاوز الحد الأعلى المسموح به ' +
              StringUtils().oCcy.format(store.state.startupState.startModel.user.limitTotalCost) +
              ' ' +
              store.state.startupState.startModel.company.currency +
              '\n' +
              'بإمكانك تعديل الطلب من سلة المشتريات');
    } else if (action.pop) {
      store.dispatch(Pop());
    }
  } else if (action is SyncAddProduct) {
    CartServices.syncAddProduct(product: action.product);
  }
  next(action);
}
