import 'package:kammun_app/core/core_importer.dart';

import '../../domain/entities/address_entity.dart';

class AddressModel extends AddressEntity {
  AddressModel({
    id,
    supportedCityId,
    street,
    building,
    floor,
    description,
    deliveryPrice,
    lat,
    lon,
    entrance,
  }) : super(
          id: id,
          supportedCityId: supportedCityId,
          street: street,
          building: building,
          floor: floor,
          description: description,
          deliveryPrice: deliveryPrice,
          lat: lat,
          lon: lon,
          entrance: entrance,
        );

  factory AddressModel.fromJson(Map<String, dynamic> json) => AddressModel(
        id: json['id'],
        supportedCityId: json['supported_city_id'].toString(),
        street: json['street'].toString(),
        building: json['building'].toString(),
        floor: json['floor'].toString(),
        description: json['description'].toString(),
        deliveryPrice: json['deliveryPrice'] ?? 0,
        lat: json['lat'] ?? -1.0,
        lon: json['lon'] ?? -1.0,
        entrance: json['entrance'].toString(),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'supported_city_id': supportedCityId,
        'street': street,
        'building': building,
        'floor': floor,
        'description': description,
        'deliveryPrice': deliveryPrice,
        'lat': lat,
        'lon': lon,
        'entrance': entrance,
      };
}
