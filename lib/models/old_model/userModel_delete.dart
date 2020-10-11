// // To parse this JSON data, do
// //
// //     final userSelf = userSelfFromJson(jsonString);

// import 'dart:convert';

// UserSelf userSelfFromJson(String str) => UserSelf.fromJson(json.decode(str));

// String userSelfToJson(UserSelf data) => json.encode(data.toJson());

// Data orderFromJson(String str) => Data.orderFromJson(json.decode(str));

// class UserSelf {
//   bool success;
//   Data data;

//   UserSelf({
//     this.success,
//     this.data,
//   });

//   factory UserSelf.fromJson(Map<String, dynamic> json) => UserSelf(
//         success: json["success"],
//         data: Data.fromJson(json["data"]),
//       );

//   Map<String, dynamic> toJson() => {
//         "success": success,
//         "data": data.toJson(),
//       };
// }

// class Data {
//   int id;
//   String phone;
//   List<Address> addresses;
//   List<Product> userFavoriteProducts;
//   List<Order> orders;

//   Data({
//     this.id,
//     this.phone,
//     this.addresses,
//     this.userFavoriteProducts,
//     this.orders,
//   });

//   factory Data.fromJson(Map<String, dynamic> json) {
//     return Data(
//       id: json["id"],
//       phone: json["phone"],
//       addresses:
//           List<Address>.from(json["addresses"].map((x) => Address.fromJson(x))),
//       userFavoriteProducts: json["user_favorite_products"].length > 0
//           ? List<Product>.from(
//               json["user_favorite_products"].map((x) => Product.fromJson(x)))
//           : [],
//       orders: List<Order>.from(json["orders"].map((x) => Order.fromJson(x))),
//     );
//   }

//   factory Data.orderFromJson(Map<String, dynamic> json) => Data(
//         orders: List<Order>.from(json["data"].map((x) => Order.fromJson(x))),
//       );

//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "phone": phone,
//         "addresses": List<dynamic>.from(addresses.map((x) => x.toJson())),
//         "user_favorite_products":
//             List<dynamic>.from(userFavoriteProducts.map((x) => x.toJson())),
//         "orders": List<dynamic>.from(orders.map((x) => x.toJson())),
//       };
// }

// class Address {
//   int id;
//   String supportedCityName;
//   int supportedCityId;
//   String street;
//   String building;
//   String floor;
//   String description;
//   int deliveryPrice;

//   Address(
//       {this.id,
//       this.supportedCityId,
//       this.street,
//       this.building,
//       this.floor,
//       this.description,
//       this.deliveryPrice,
//       this.supportedCityName});

//   factory Address.fromJson(Map<String, dynamic> json) => Address(
//       id: json["id"],
//       supportedCityId: json["supported_city_id"],
//       street: json["street"],
//       building: json["building"],
//       floor: json["floor"],
//       description: json["description"],
//       deliveryPrice: json["deliveryPrice"],
//       supportedCityName: json["supportedCityName"]);

//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "supported_city_id": supportedCityId,
//         "street": street,
//         "building": building,
//         "floor": floor,
//         "description": description,
//         "deliveryPrice": deliveryPrice,
//         "supportedCityName": supportedCityName,
//       };
// }

// class Order {
//   int id;
//   int expectedTimeMinutes;
//   DateTime dateTime;
//   int deliveryCost;
//   int supportedCityCost;
//   int orderStatusId;
//   int userId;
//   int total;
//   List<Product> products;

//   Order({
//     this.id,
//     this.expectedTimeMinutes,
//     this.dateTime,
//     this.deliveryCost,
//     this.supportedCityCost,
//     this.orderStatusId,
//     this.userId,
//     this.total,
//     this.products,
//   });

//   factory Order.fromJson(Map<String, dynamic> json) => Order(
//         id: json["id"],
//         expectedTimeMinutes: json["expected_time_minutes"],
//         dateTime: DateTime.parse(json["created_at"]),
//         deliveryCost: int.parse(json["delivery_cost"].toString().split(".")[0]),
//         supportedCityCost:
//             int.parse(json["supported_city_cost"].toString().split(".")[0]),
//         orderStatusId: json["order_status_id"],
//         userId: json["user_id"],
//         total: int.parse(json["total"].toString().split(".")[0]),
//         products: List<Product>.from(
//             json["products"].map((x) => Product.fromJson(x))),
//       );

//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "expected_time_minutes": expectedTimeMinutes,
//         "created_at": dateTime.toIso8601String(),
//         "delivery_cost": deliveryCost,
//         "supported_city_cost": supportedCityCost,
//         "order_status_id": orderStatusId,
//         "user_id": userId,
//         "total": total,
//         "products": List<dynamic>.from(products.map((x) => x.toJson())),
//       };
// }

// class Product {
//   int id;
//   String name;
//   String description;
//   int price;
//   int quantity;
//   String unit;
//   Pivot pivot;
//   List<ProductImages> images;
//   int isActive;

//   Product({
//     this.id,
//     this.name,
//     this.description,
//     this.price,
//     this.quantity,
//     this.unit,
//     this.pivot,
//     this.images,
//     this.isActive,
//   });

//   factory Product.fromJson(Map<String, dynamic> json) => Product(
//         id: json["id"],
//         name: json["name"],
//         isActive: json['is_active'],
//         description: json["description"],
//         price: int.parse(json["price"].toString().split(".")[0]),
//         quantity: json["quantity"] == null ? null : json["quantity"],
//         unit: json["unit"],
//         pivot: json["pivot"] == null ? null : Pivot.fromJson(json["pivot"]),
//         images: List<ProductImages>.from(
//             json["images"].map((x) => ProductImages.fromJson(x))),
//       );

//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "name": name,
//         "is_active": isActive,
//         "description": description,
//         "price": price,
//         "quantity": quantity == null ? null : quantity,
//         "unit": unit,
//         "pivot": pivot == null ? null : pivot.toJson(),
//         "images": List<dynamic>.from(images.map((x) => x.toJson())),
//       };
// }

// class ProductImages {
//   String imageFileName;

//   ProductImages({
//     this.imageFileName,
//   });

//   factory ProductImages.fromJson(Map<String, dynamic> json) => ProductImages(
//         imageFileName: json["image_file_name"],
//       );

//   Map<String, dynamic> toJson() => {
//         "image_file_name": imageFileName,
//       };
// }

// class Pivot {
//   int quantity;
//   int purchasePrice;

//   Pivot({
//     this.quantity,
//     this.purchasePrice,
//   });

//   factory Pivot.fromJson(Map<String, dynamic> json) {
//     print("-------------- purchase_price AMIN -----------");
//     print(json["purchase_price"]);
//     print(json["quantity"]);

//     if (json["purchase_price"] == null)
//       return Pivot(purchasePrice: 0, quantity: 0);
//     else {
//       return Pivot(
//         quantity: json["quantity"],
//         purchasePrice: json["purchase_price"].toString().contains(".")
//             ? int.parse(json["purchase_price"].toString().split(".")[0])
//             : int.parse(json["purchase_price"].toString()),
//       );
//     }
//   }
//   Map<String, dynamic> toJson() => {
//         "quantity": quantity,
//         "purchase_price": purchasePrice,
//       };
// }
