// To parse this JSON data, do
//
//     final cartModel = cartModelFromJson(jsonString);

import 'dart:convert';

SharedPrefCartModel cartModelFromJson(String str) => SharedPrefCartModel.fromJson(json.decode(str));

String cartModelToJson(SharedPrefCartModel data) => json.encode(data.toJson());

class SharedPrefCartModel {
    List<CartProduct> cartProducts;

    SharedPrefCartModel({
        this.cartProducts,
    });

    factory SharedPrefCartModel.fromJson(Map<String, dynamic> json) => SharedPrefCartModel(
        cartProducts: List<CartProduct>.from(json["cartProducts"].map((x) => CartProduct.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "cartProducts": List<dynamic>.from(cartProducts.map((x) => x.toJson())),
    };
}

class CartProduct {
    int id;
    String quantity;
    String price;

    CartProduct({
        this.id,
        this.quantity,
        this.price,
    });

    factory CartProduct.fromJson(Map<String, dynamic> json) => CartProduct(
        id: json["id"],
        quantity: json["quantity"] == null ? null : json["quantity"].toString(),
        price: json["price"] == null ? null : json["price"].toString(),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "quantity": quantity == null ? null : quantity,
        "price": price == null ? null : price,
    };
}
