// // To parse this JSON data, do
// //
// //     final searchProducts = searchProductsFromJson(jsonString);

// import 'dart:convert';
// import 'package:kammun_app/models/start_model.dart';

// SearchProductsResponse searchProductsFromJson(String str) =>
//     SearchProductsResponse.fromJson(json.decode(str));

// String searchProductsToJson(SearchProductsResponse data) =>
//     json.encode(data.toJson());

// class SearchProductsResponse {
//   bool success;
//   Data data;

//   SearchProductsResponse({
//     this.success,
//     this.data,
//   });

//   factory SearchProductsResponse.fromJson(Map<String, dynamic> json) =>
//       SearchProductsResponse(
//         success: json["success"],
//         data: Data.fromJson(json["data"]),
//       );

//   Map<String, dynamic> toJson() => {
//         "success": success,
//         "data": data.toJson(),
//       };
// }

// class Data {
//   List<SearchProductsList> data;
//   int lastPage;

//   Data({
//     this.data,
//     this.lastPage,
//   });

//   factory Data.fromJson(Map<String, dynamic> json) => Data(
//         data: List<SearchProductsList>.from(
//             json["data"].map((x) => SearchProductsList.fromJson(x))),
//         lastPage: json["last_page"],
//       );

//   Map<String, dynamic> toJson() => {
//         "data": List<dynamic>.from(data.map((x) => x.toJson())),
//         "last_page": lastPage,
//       };
// }

// class SearchProductsList {
//   int id;
//   String name;
//   String description;
//   int price;
//   int quantity;
//   int isActive;
//   int isFeatured;
//   int priority;
//   String unit;
//   List<ProductImage> images;
//   int productCount;

//   SearchProductsList({
//     this.id,
//     this.name,
//     this.description,
//     this.price,
//     this.quantity,
//     this.isActive,
//     this.isFeatured,
//     this.priority,
//     this.unit,
//     this.images,
//     this.productCount,
//   });

//   factory SearchProductsList.fromJson(Map<String, dynamic> json) {
//     List<ProductImage> images = new List<ProductImage>();

//     return SearchProductsList(
//       id: json["id"],
//       name: json["name"],
//       description: json["description"],
//       price: int.parse(json["price"].toString().split(".")[0]),
//       quantity: json["quantity"],
//       isActive: json["is_active"],
//       isFeatured: json["is_featured"],
//       priority: json["priority"],
//       unit: json["unit"] == null ? null : json["unit"],
//       images: json["images"] == null
//           ? images
//           : List<ProductImage>.from(
//               json["images"].map((x) => ProductImage.fromJson(x))),
//       productCount: json["productCount"],
//     );
//   }

//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "name": name,
//         "description": description,
//         "price": price,
//         "quantity": quantity,
//         "is_active": isActive,
//         "is_featured": isFeatured,
//         "priority": priority,
//         "unit": unit == null ? null : unit,
//         "images": List<dynamic>.from(images.map((x) => x.toJson())),
//         "productCount": productCount,
//       };
// }
