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
        id: json["id"],
        username: json["username"],
        name: json["name"],
        phone: json["phone"],
        isSuperUser: json["is_super_user"],
        warehouseId: json["warehouse_id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "username": username,
        "name": name,
        "phone": phone,
        "is_super_user": isSuperUser,
        "warehouse_id": warehouseId,
      };
}
