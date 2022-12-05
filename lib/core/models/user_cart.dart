// To parse this JSON data, do
//
//     final userCart = userCartFromJson(jsonString);

import 'models_importer.dart';

UserCart userCartFromJson(String str) => UserCart.fromJson(json.decode(str));

String userCartToJson(UserCart data) => json.encode(data.toJson());

class UserCart {
  bool success;
  Data data;

  UserCart({
    this.success,
    this.data,
  });

  factory UserCart.fromJson(Map<String, dynamic> json) => UserCart(
        success: json["success"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": data.toJson(),
      };
}

class Data {
  int id;
  String name;
  int price;
  int quantity;
  String unit;
  int isActive;

  List<ProductImage> images;

  Data({this.id, this.name, this.price, this.quantity, this.unit, this.images, this.isActive});

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        name: json["name"],
        price: int.parse(json["price"].toString().split(".")[0]),
        quantity: json["quantity"],
        unit: json["unit"].toString(),
        isActive: json["is_active"],
        images: List<ProductImage>.from(json["images"].map((x) => ProductImage.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "price": price,
        "quantity": quantity,
        "unit": unit,
        "is_active": isActive,
        "images": List<dynamic>.from(images.map((x) => x.toJson())),
      };
}
