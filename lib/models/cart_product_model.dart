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
        quantity: json["quantity"].toString(),
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
