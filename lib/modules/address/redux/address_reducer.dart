import '../../../core/core_importer.dart';
import 'address_action.dart';
import 'address_state.dart';

Reducer<AddressState> addressReducer = combineReducers<AddressState>([
  TypedReducer<AddressState, AddressRemoved>(addressRemoved),
  TypedReducer<AddressState, EditAddress>(editAddress),
  TypedReducer<AddressState, AddressEditedSuccessfully>(addressEditedSuccessfully),
  TypedReducer<AddressState, SelectAddress>(selectAddress),
  TypedReducer<AddressState, AddressAddedSuccessfully>(addressAddedSuccessfully),
  TypedReducer<AddressState, SaveAddresses>(saveAddresses),
]);

AddressState addressRemoved(AddressState state, AddressRemoved action) {
  List<AddressModel> addresses = state.addresses;
  addresses.removeWhere((address) => address.id.toString() == action.addressId);
  return state.copyWith(addresses: addresses);
}

AddressState editAddress(AddressState state, EditAddress action) {
  return state.copyWith(editingIndex: action.selectedAddress);
}

AddressState addressEditedSuccessfully(AddressState state, AddressEditedSuccessfully action) {
  List<AddressModel> addresses = state.addresses;
  addresses[action.selectedAddress] = action.address;
  return state.copyWith(editingIndex: -1, addresses: addresses);
}

AddressState selectAddress(AddressState state, SelectAddress action) {
  return state.copyWith(selectedIndex: action.selectedAddress);
}

AddressState addressAddedSuccessfully(AddressState state, AddressAddedSuccessfully action) {
  List<AddressModel> addresses = [action.address];
  addresses.addAll(state.addresses);
  return state.copyWith(addresses: addresses);
}

AddressState saveAddresses(AddressState state, SaveAddresses action) {
  return state.copyWith(addresses: action.addresses);
}
