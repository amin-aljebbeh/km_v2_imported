import '../../../core/core_importer.dart';
import 'delivery_method_action.dart';
import 'delivery_method_state.dart';

Reducer<DeliveryMethodState> deliveryMethodReducer = combineReducers<DeliveryMethodState>([
  TypedReducer<DeliveryMethodState, DeliveryMethodsFetchedSuccessfully>(deliveryMethodsFetchedSuccessfully),
  TypedReducer<DeliveryMethodState, SelectDeliveryMethod>(selectDeliveryMethod),
  TypedReducer<DeliveryMethodState, InitialDeliveryMethod>(initialDeliveryMethod),
]);

DeliveryMethodState deliveryMethodsFetchedSuccessfully(
    DeliveryMethodState state, DeliveryMethodsFetchedSuccessfully action) {
  return state.copyWith(deliveryMethods: action.deliveryMethods);
}

DeliveryMethodState selectDeliveryMethod(DeliveryMethodState state, SelectDeliveryMethod action) {
  return state.copyWith(selectedDeliveryMethod: action.selectedDeliveryMethod);
}

DeliveryMethodState initialDeliveryMethod(DeliveryMethodState state, InitialDeliveryMethod action) {
  return DeliveryMethodState.initial();
}
