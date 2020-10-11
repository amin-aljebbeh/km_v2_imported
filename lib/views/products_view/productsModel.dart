// // To parse this JSON data, do
// //
// //     final products = productsFromJson(jsonString);

// import 'dart:convert';

// Products productsFromJson(String str) => Products.fromJson(json.decode(str));

// String productsToJson(Products data) => json.encode(data.toJson());

// class Products {
//   String productsCount;
//   List<Product> products;

//   Products({
//     this.productsCount,
//     this.products,
//   });

//   factory Products.fromJson(Map<String, dynamic> json) => Products(
//         productsCount: json["products_count"],
//         products: List<Product>.from(
//             json["products"].map((x) => Product.fromJson(x))),
//       );

//   Map<String, dynamic> toJson() => {
//         "products_count": productsCount,
//         "products": List<dynamic>.from(products.map((x) => x.toJson())),
//       };
// }

// class Product {
//   String title;
//   String brandName;
//   String subName;
//   List<String> photos;
//   String productId;

//   Product({
//     this.title,
//     this.brandName,
//     this.subName,
//     this.photos,
//     this.productId,
//   });

//   factory Product.fromJson(Map<String, dynamic> json) => Product(
//         title: json["title"],
//         brandName: json["brand_name"],
//         subName: json["sub_name"],
//         photos: List<String>.from(json["photos"].map((x) => x)),
//         productId: json["product_id"],
//       );

//   Map<String, dynamic> toJson() => {
//         "title": title,
//         "brand_name": brandName,
//         "sub_name": subName,
//         "photos": List<dynamic>.from(photos.map((x) => x)),
//         "product_id": productId,
//       };
// }
