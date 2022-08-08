import 'package:flutter/material.dart';
import 'package:kammun_app/modules/product/service/product_service.dart';
import 'package:kammun_app/modules/products/redux/products_action.dart';
import '../../../core/core_importer.dart';
import '../../authentication/view/login_view.dart';
import '../../error/services/error_services.dart';
import 'product_action.dart';

Future<void> productMiddleware(Store<AppState> store, action, NextDispatcher next) async {
  if (action is UserVisitProduct) {
    store.dispatch(NoError());
    int result = await ProductService.userVisitProduct(action.product.id.toString());
    if (result != successCode) {
      ErrorServices.logUserError(
          userId: store.state.startupState.startModel.user.id,
          url: getProduct + action.product.id.toString(),
          reason: 'could not save that user visited product',
          statusCode: result);
    }
  } else if (action is AddProductToFavorites) {
    store.dispatch(NoError());
    if (store.state.authenticationState.token.length > 5) {
      int result = await ProductService.addToFavorites(action.productId.toString());
      if (result == successCode) {
        store.dispatch(ProductAddedToFavoritesSuccessfully(productId: action.productId));
      } else {
        ErrorServices.logUserError(
            userId: store.state.startupState.startModel.user.id,
            url: addToFavorite + action.productId.toString(),
            reason: 'could not add product to favorite',
            statusCode: result);
      }
    } else {
      store.dispatch(PushAndReplace(routeName: LoginScreen.routeName));
    }
  } else if (action is RemoveProductFromFavorites) {
    store.dispatch(NoError());
    if (store.state.authenticationState.token.length > 5) {
      int result = await ProductService.removeFromFavorites(action.productId.toString());
      if (result == successCode) {
        store.dispatch(ProductRemovedFromFavoritesSuccessfully(productId: action.productId));
      } else {
        ErrorServices.logUserError(
            userId: store.state.startupState.startModel.user.id,
            url: removeFromFavorite + action.productId.toString(),
            reason: 'could not remove product from favorite',
            statusCode: result);
      }
    } else {
      store.dispatch(PushAndReplace(routeName: LoginScreen.routeName));
    }
  } else if (action is NotifyMe) {
    ProductAlert result =
        await ProductService.alertProductService(productId: action.productId, isAlways: action.isAlways);
    if (result != null) {
      store.dispatch(NotificationRequestSentSuccessfully(alertId: result.id, productId: action.productId));
      store.dispatch(StopLoading());
      flushbar(message: 'سيصلكم إشعار عند توفر المنتج', color: Colors.green, icon: Icons.notifications);
    } else {
      ErrorServices.logUserError(
          userId: store.state.startupState.startModel.user.id,
          url: alertProduct,
          reason: 'could not create alert',
          statusCode: 500);
    }
  } else if (action is DoNotNotifyMe) {
    store.dispatch(StartLoading());
    int result = await ProductService.deleteAlertProductService(alertId: action.alertId);
    if (result == successCode) {
      store.dispatch(NotificationRequestDeletedSuccessfully(productId: action.productId));
      if (store.state.productsState.productsType == ProductsViewTypes.alert) {
        List<ProductData> products = [];
        products.addAll(store.state.productsState.products);
        products.removeWhere((product) => product.id == action.productId);
        store.dispatch(SetAlertProducts(products: products));
      }
      store.dispatch(StopLoading());

      flushbar(message: 'تم إلغاء الإشعار', color: Colors.green, icon: Icons.notifications);
    } else {
      ErrorServices.logUserError(
          userId: store.state.startupState.startModel.user.id,
          url: alertProduct + action.productId.toString(),
          reason: 'could not remove alert',
          statusCode: result);
    }
    store.dispatch(StopLoading());
  } else if (action is UpdateNotify) {
    store.dispatch(StartLoading());
    bool result = await ProductService.updateAlertProductService(alertId: action.alertId);
    store.dispatch(StopLoading());
    if (result) {
      flushbar(message: 'تم تحديث حالة الإشعار', color: Colors.green, icon: Icons.notifications);
    }
  }
  next(action);
}
