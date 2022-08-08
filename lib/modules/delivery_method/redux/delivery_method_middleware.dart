import 'package:kammun_app/core/core_importer.dart';
import 'package:kammun_app/modules/delivery_method/services/delivery_method_services.dart';
import '../../invoice/redux/invoice_action.dart';
import 'delivery_method_action.dart';

Future<void> deliveryMethodMiddleware(Store<AppState> store, action, NextDispatcher next) async {
  if (action is GetDeliveryMethods) {
    store.dispatch(StartLoading());
    List<DeliveryMethodData> deliveryMethods =
        await DeliveryMethodServices.getUserDeliveryMethod(addressId: action.addressId);
    if (deliveryMethods.isNotEmpty) {
      store.dispatch(NoError());
      store.dispatch(DeliveryMethodsFetchedSuccessfully(deliveryMethods: deliveryMethods));
    } else {
      store.dispatch(CatchError(errorMessage: 'خطأ أثناء جلب البيانات'));
    }
  } else if (action is SelectDeliveryMethod) {
    store.dispatch(SetDeliveryMethodId(
        deliveryMethodId: store.state.deliveryMethodState.deliveryMethods[action.selectedDeliveryMethod].id));
  }
  next(action);
}
