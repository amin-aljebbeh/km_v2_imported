import 'dart:convert';

GetAddressModel getAddressFromJson(String str) => GetAddressModel.fromJson(json.decode(str));

String getAddressToJson(GetAddressModel data) => json.encode(data.toJson());

class GetAddressModel {
  GetAddressModel({
    this.success,
    this.address,
    this.message,
    this.reason,
  });

  bool success;
  AddressModel address;
  String message;
  String reason;

  factory GetAddressModel.fromJson(Map<String, dynamic> json) => GetAddressModel(
        success: json['success'],
        address: json['data'] == null ? null : AddressModel.fromJson(json['data']),
        message: json['message'].toString(),
        reason: json['reason'],
      );

  Map<String, dynamic> toJson() => {
        'success': success,
        'data': address.toJson(),
      };
}

class AddressModel {
  AddressModel({
    this.id,
    this.supportedCityId,
    this.street,
    this.building,
    this.floor,
    this.description,
    this.pivot,
    this.supportedCityName,
    this.lat,
    this.lon,
    this.entrance,
  });

  int id;
  String supportedCityId;
  String street;
  String building;
  String floor;
  String description;
  AddressPivot pivot;
  String supportedCityName;
  double lat;
  double lon;
  String entrance;

  factory AddressModel.fromJson(Map<String, dynamic> json) => AddressModel(
        id: json['id'],
        supportedCityId: json['supported_city_id'].toString(),
        street: json['street'],
        building: json['building'],
        floor: json['floor'],
        description: json['description'],
        supportedCityName: json['supportedCityName'].toString(),
        lat: json['lat'],
        lon: json['lon'],
        entrance: json['entrance'].toString(),
        pivot: json['pivot'] == null ? null : AddressPivot.fromJson(json['pivot']),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'supported_city_id': supportedCityId,
        'street': street,
        'building': building,
        'floor': floor,
        'description': description,
        'supportedCityName': supportedCityName,
        'lat': lat,
        'lon': lon,
        'entrance': entrance,
        'pivot': pivot.toJson(),
      };
}

class AddressPivot {
  AddressPivot({
    this.userId,
    this.addressId,
  });

  String userId;
  String addressId;
  dynamic createdAt;
  dynamic updatedAt;

  factory AddressPivot.fromJson(Map<String, dynamic> json) => AddressPivot(
        userId: json['user_id'].toString(),
        addressId: json['address_id'].toString(),
      );

  Map<String, dynamic> toJson() => {
        'user_id': userId,
        'address_id': addressId,
        'created_at': createdAt,
        'updated_at': updatedAt,
      };
}
