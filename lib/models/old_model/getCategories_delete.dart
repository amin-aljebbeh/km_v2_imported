// // To parse this JSON data, do
// //
// //     final category = categoryFromJson(jsonString);

// import 'dart:convert';

// Category categoryFromJson(String str) => Category.fromJson(json.decode(str));

// String categoryToJson(Category data) => json.encode(data.toJson());

// class Category {
//   bool success;
//   List<CategoryData> data;

//   Category({
//     this.success,
//     this.data,
//   });

//   factory Category.fromJson(Map<String, dynamic> json) => Category(
//         success: json["success"],
//         data: List<CategoryData>.from(json["data"].map((x) => CategoryData.fromJson(x))),
//       );

//   Map<String, dynamic> toJson() => {
//         "success": success,
//         "data": List<dynamic>.from(data.map((x) => x.toJson())),
//       };
// }

// class CategoryData {
//   int id;
//   String name;
//   int isActive;
//   int isFeatured;
//   String imageFileName;
//   int priority;
//   dynamic parentCategoryId;

//   CategoryData({
//     this.id,
//     this.name,
//     this.isActive,
//     this.isFeatured,
//     this.imageFileName,
//     this.priority,
//     this.parentCategoryId,
//   });

//   factory CategoryData.fromJson(Map<String, dynamic> json) => CategoryData(
//         id: json["id"],
//         name: json["name"],
//         isActive: json["is_active"],
//         isFeatured: json["is_featured"],
//         imageFileName: json["image_file_name"],
//         priority: json["priority"],
//         parentCategoryId: json["parent_category_id"],
//       );

//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "name": name,
//         "is_active": isActive,
//         "is_featured": isFeatured,
//         "image_file_name": imageFileName,
//         "priority": priority,
//         "parent_category_id": parentCategoryId,
//       };
// }
