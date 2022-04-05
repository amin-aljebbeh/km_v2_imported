// To parse this JSON data, do
//
//     final addNewAddress = addNewAddressFromJson(jsonString);

import 'dart:convert';

AddNewAddress addNewAddressFromJson(String str) =>
    AddNewAddress.fromJson(json.decode(str));

String addNewAddressToJson(AddNewAddress data) => json.encode(data.toJson());

class AddNewAddress {
  bool success;
  AddressId addressId;

  AddNewAddress({
    this.success,
    this.addressId,
  });

  factory AddNewAddress.fromJson(Map<String, dynamic> json) => AddNewAddress(
        success: json["success"],
        addressId: AddressId.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": addressId.toJson(),
      };
}

class AddressId {
  int id;

  AddressId({
    this.id,
  });

  factory AddressId.fromJson(Map<String, dynamic> json) => AddressId(
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
      };
}
