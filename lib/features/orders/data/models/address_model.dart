import 'package:kammun_app/core/core_importer.dart';

import '../../domain/entities/address_entity.dart';

class AddressModel extends AddressEntity {
  AddressModel({street, building, floor, description, lat, lon, entrance})
      : super(
          street: street,
          building: building,
          floor: floor,
          description: description,
          lat: lat,
          lon: lon,
          entrance: entrance,
        );

  factory AddressModel.fromJson(Map<String, dynamic> json) => AddressModel(
        street: json['street'].toString(),
        building: json['building'].toString(),
        floor: json['floor'].toString(),
        description: json['description'].toString(),
        lat: json['lat'] ?? -1.0,
        lon: json['lon'] ?? -1.0,
        entrance: json['entrance'].toString(),
      );

  Map<String, dynamic> toJson() => {
        'street': street,
        'building': building,
        'floor': floor,
        'description': description,
        'lat': lat,
        'lon': lon,
        'entrance': entrance
      };
}
