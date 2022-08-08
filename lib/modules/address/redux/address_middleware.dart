// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kammun_app/modules/address/services/address_service.dart';
import 'package:kammun_app/modules/delivery_method/redux/delivery_method_action.dart';
import '../../../core/core_importer.dart';
import '../../home_page/redux/home_page_action.dart';
import '../../invoice/redux/invoice_action.dart';
import 'address_action.dart';

Future<void> addressMiddleware(Store<AppState> store, action, NextDispatcher next) async {
  if (action is AddAddress) {
    store.dispatch(StartLoading());
    GetAddressModel result = await AddressService.addNewAddress(
      lon: action.address.lon,
      lat: action.address.lat,
      supportedCityId: action.address.supportedCityId,
      description: action.address.description,
      floor: action.address.floor,
      building: action.address.building,
      street: action.address.street,
      city: action.address.supportedCityName,
      entrance: action.address.entrance,
    );
    if (result != null) {
      if (!result.success) {
        store.dispatch(CatchError(
            errorMessage: result.message ?? 'خطأ أثناء إضافة العنوان',
            reason: result.reason ?? result.message ?? 'خطأ أثناء إضافة العنوان'));
      } else {
        store.dispatch(StopLoading());
        if (action.getDeliveryMethods) {
          store.dispatch(GetDeliveryMethods(addressId: result.address.id));
        }
        result.address.supportedCityName = store.state.supportedCityState.supportedCities
            .firstWhere((city) => city.id.toString() == result.address.supportedCityId)
            .name;
        store.dispatch(AddressAddedSuccessfully(address: result.address));
        store.dispatch(
            SelectAddress(selectedAddress: 0, firebaseToken: store.state.startupState.startModel.user.firebaseToken));
        store.dispatch(Pop());
        flushbar(message: 'تم إضافة العنوان بنجاح', color: Colors.green, icon: Icons.location_on);
        store.dispatch(NoError());
      }
    } else {
      store.dispatch(CatchError(errorMessage: 'خطأ أثناء إضافة العنوان', reason: 'خطأ أثناء إضافة العنوان'));
    }
    store.dispatch(StopLoading());
  } else if (action is UpdateAddress) {
    store.dispatch(StartLoading());
    bool result = await AddressService.updateAddress(
      entrance: action.address.entrance,
      city: action.address.supportedCityName,
      street: action.address.street,
      building: action.address.building,
      floor: action.address.floor,
      description: action.address.description,
      supportedCityId: action.address.supportedCityId,
      lat: action.address.lat,
      lon: action.address.lon,
      addressId: action.address.id.toString(),
    );
    store.dispatch(Pop());
    if (result) {
      store.dispatch(AddressEditedSuccessfully(address: action.address, selectedAddress: action.selectedAddress));
      store.dispatch(NoError());
    } else {
      store.dispatch(CatchError(errorMessage: 'خطأ أثناء تعديل العنوان', reason: 'خطأ أثناء تعديل العنوان'));
    }
    store.dispatch(StopLoading());
  } else if (action is RemoveAddress) {
    store.dispatch(StartLoading());
    bool result = await AddressService.removeUserAddress(addressId: action.addressId);
    if (result) {
      store.dispatch(AddressRemoved(addressId: action.addressId));
      flushbar(message: 'تم حذف العنوان بنجاح', color: Colors.green, icon: Icons.location_off);
      store.dispatch(NoError());
      int index = store.state.addressState.selectedIndex;
      if (index != -1 && index > 0 && index < store.state.addressState.addresses.length) {
        store.dispatch(SelectAddress(
            selectedAddress: index, firebaseToken: store.state.startupState.startModel.user.firebaseToken));
      } else {
        store.dispatch(
            SelectAddress(selectedAddress: 0, firebaseToken: store.state.startupState.startModel.user.firebaseToken));
      }
    } else {
      store.dispatch(CatchError(errorMessage: 'خطأ أثناء حذف العنوان', reason: 'خطأ أثناء حذف العنوان'));
    }
    store.dispatch(StopLoading());
  } else if (action is SelectAddress) {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('selectedAddressId', store.state.addressState.addresses[action.selectedAddress].id);
    store.dispatch(SetAddressId(addressId: store.state.addressState.addresses[action.selectedAddress].id));
    String supportedCityId = store.state.addressState.addresses[action.selectedAddress].supportedCityId;
    FirebaseFirestore.instance.collection('topics').get().then((value) {
      for (var doc in value.docs) {
        doc.data().keys.toList().forEach((key) => store.dispatch(UnSubscribe(topic: key)));
      }
    });
    store.dispatch(Subscribe(topic: 'supported_city_id_' + supportedCityId));
    store.dispatch(Subscribe(
        topic: 'warehouse_id_' +
            store.state.supportedCityState.supportedCities
                .firstWhere((city) => city.id.toString() == supportedCityId)
                .warehouseId
                .toString()));
  }
  next(action);
}
