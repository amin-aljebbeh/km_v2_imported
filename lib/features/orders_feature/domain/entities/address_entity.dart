class AddressEntity {
  int id;
  String supportedCityId;
  String street;
  String building;
  String floor;
  String description;
  int deliveryPrice;
  double lat;
  double lon;
  String entrance;

  AddressEntity({
    this.id,
    this.supportedCityId,
    this.street,
    this.building,
    this.floor,
    this.description,
    this.deliveryPrice,
    this.lat,
    this.lon,
    this.entrance,
  });
}
