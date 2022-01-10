class OrderAddress {
  OrderAddress(
      {this.id,
      this.supportedCityId,
      this.street,
      this.building,
      this.floor,
      this.description,
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
  int deliveryPrice;
  String lat;
  String lon;
  String entrance;

  factory OrderAddress.fromJson(Map<String, dynamic> json) => OrderAddress(
        id: json["id"],
        supportedCityId: json["supported_city_id"].toString(),
        street: json["street"].toString(),
        building: json["building"].toString(),
        floor: json["floor"].toString(),
        description: json["description"].toString(),
        deliveryPrice: json["deliveryPrice"],
        lat: json["lat"].toString(),
        lon: json["lon"].toString(),
        entrance: json["entrance"].toString(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "supported_city_id": supportedCityId,
        "street": street,
        "building": building,
        "floor": floor,
        "description": description,
        "deliveryPrice": deliveryPrice,
        "lat": lat,
        "lon": lon,
        "entrance": entrance,
      };
}
