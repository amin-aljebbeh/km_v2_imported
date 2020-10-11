// To parse this JSON data, do
//
//     final addNewAddre = addNewAddreFromJson(jsonString);

import 'dart:convert';

AddNewAddre addNewAddreFromJson(String str) => AddNewAddre.fromJson(json.decode(str));

String addNewAddreToJson(AddNewAddre data) => json.encode(data.toJson());

class AddNewAddre {
    bool success;
    AddressId addressId;

    AddNewAddre({
        this.success,
        this.addressId,
    });

    factory AddNewAddre.fromJson(Map<String, dynamic> json) => AddNewAddre(
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
