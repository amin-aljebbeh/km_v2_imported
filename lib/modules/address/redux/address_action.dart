import '../../../core/core_importer.dart';

class AddAddress {
  final AddressModel address;
  final bool getDeliveryMethods;

  AddAddress({this.getDeliveryMethods, this.address});
}

class RemoveAddress {
  final String addressId;

  RemoveAddress({this.addressId});
}

class AddressRemoved {
  final String addressId;

  AddressRemoved({this.addressId});
}

class EditAddress {
  final int selectedAddress;

  EditAddress({this.selectedAddress});
}

class UpdateAddress {
  final AddressModel address;
  final int selectedAddress;

  UpdateAddress({this.selectedAddress, this.address});
}

class AddressEditedSuccessfully {
  final int selectedAddress;
  final AddressModel address;

  AddressEditedSuccessfully({this.address, this.selectedAddress});
}

class AddressAddedSuccessfully {
  final AddressModel address;

  AddressAddedSuccessfully({this.address});
}

class SelectAddress {
  final int selectedAddress;
  final String firebaseToken;

  SelectAddress({this.firebaseToken, this.selectedAddress});
}

class SaveAddresses {
  final List<AddressModel> addresses;

  SaveAddresses({this.addresses});
}
