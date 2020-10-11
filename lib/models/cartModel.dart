// To parse this JSON data, do
//
//     final cartModel = cartModelFromJson(jsonString);

import 'dart:convert';

CartModel cartModelFromJson(String str) => CartModel.fromJson(json.decode(str));

String cartModelToJson(CartModel data) => json.encode(data.toJson());

class CartModel {
  List<CartProduct> cartProducts;

  CartModel({
    this.cartProducts,
  });

  factory CartModel.fromJson(Map<String, dynamic> json) => CartModel(
        cartProducts: List<CartProduct>.from(
            json["cartProducts"].map((x) => CartProduct.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "cartProducts": List<dynamic>.from(cartProducts.map((x) => x.toJson())),
      };
}

class CartProduct {
  int id;
  int count;
  String name;
  int price;
  String imageName;
  String unit;
  String quantity;

  CartProduct({
    this.id,
    this.count,
    this.name,
    this.price,
    this.imageName,
    this.unit,
    this.quantity,
  });

  factory CartProduct.fromJson(Map<String, dynamic> json) => CartProduct(
        id: json["id"],
        count: json["count"],
        name: json["name"],
        price: int.parse(json["price"].toString().split(".")[0]),
        imageName: json["image_name"],
        unit: json["unit"],
        quantity: json["quantity"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "count": count,
        "name": name,
        "price": price,
        "image_name": imageName,
        "unit": unit,
        "quantity": quantity,
      };
}
