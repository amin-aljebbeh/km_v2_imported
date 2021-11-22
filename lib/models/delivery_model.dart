class DeliveryModel {
  DeliveryModel({
    this.id,
    this.username,
    this.name,
    this.phone,
    this.isSuperUser,
    this.warehouseId,
  });

  int id;
  String username;
  String name;
  dynamic phone;
  int isSuperUser;
  int warehouseId;

  factory DeliveryModel.fromJson(Map<String, dynamic> json) => DeliveryModel(
        id: json["id"] == null ? null : json["id"],
        username: json["username"] == null ? null : json["username"],
        name: json["name"] == null ? null : json["name"],
        phone: json["phone"],
        isSuperUser:
            json["is_super_user"] == null ? null : json["is_super_user"],
        warehouseId: json["warehouse_id"] == null ? null : json["warehouse_id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "username": username == null ? null : username,
        "name": name == null ? null : name,
        "phone": phone,
        "is_super_user": isSuperUser == null ? null : isSuperUser,
        "warehouse_id": warehouseId == null ? null : warehouseId,
      };
}
