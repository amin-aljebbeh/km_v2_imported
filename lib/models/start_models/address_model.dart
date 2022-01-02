class Address {
  Address(
      {this.id,
      this.supportedCityId,
      this.street,
      this.building,
      this.floor,
      this.description,
      this.pivot,
      this.supportedCityName,
      this.deliveryPrice,
      this.lat,
      this.lon,
      this.entrance});

  int id;
  String supportedCityId;
  String street;
  String building;
  String floor;
  String description;
  AddressPivot pivot;
  String supportedCityName;
  int deliveryPrice;
  String lat;
  String lon;
  String entrance;

  factory Address.fromJson(Map<String, dynamic> json) => Address(
        id: json["id"],
        supportedCityId: json["supported_city_id"].toString(),
        street: json["street"].toString(),
        building: json["building"].toString(),
        floor: json["floor"].toString(),
        description: json["description"].toString(),
        supportedCityName: json["supportedCityName"].toString(),
        deliveryPrice: json["deliveryPrice"],
        lat: json["lat"].toString(),
        lon: json["lon"].toString(),
        entrance: json["entrance"].toString(),
        pivot: AddressPivot.fromJson(json["pivot"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "supported_city_id": supportedCityId,
        "street": street,
        "building": building,
        "floor": floor,
        "description": description,
        "supportedCityName": supportedCityName,
        "deliveryPrice": deliveryPrice,
        "lat": lat,
        "lon": lon,
        "entrance": entrance,
        "pivot": pivot.toJson(),
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
        userId: json["user_id"].toString(),
        addressId: json["address_id"].toString(),
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "address_id": addressId,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}
