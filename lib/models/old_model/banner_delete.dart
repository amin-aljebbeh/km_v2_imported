// // To parse this JSON data, do
// //
// //     final banner = bannerFromJson(jsonString);

// import 'dart:convert';

// Banner bannerFromJson(String str) => Banner.fromJson(json.decode(str));

// String bannerToJson(Banner data) => json.encode(data.toJson());

// class Banner {
//     bool success;
//     List<Datum> data;

//     Banner({
//         this.success,
//         this.data,
//     });

//     factory Banner.fromJson(Map<String, dynamic> json) => Banner(
//         success: json["success"],
//         data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
//     );

//     Map<String, dynamic> toJson() => {
//         "success": success,
//         "data": List<dynamic>.from(data.map((x) => x.toJson())),
//     };
// }

// class Datum {
//     int id;
//     String title;
//     String description;
//     String imageFileName;
//     DateTime expirationDate;

//     Datum({
//         this.id,
//         this.title,
//         this.description,
//         this.imageFileName,
//         this.expirationDate,
//     });

//     factory Datum.fromJson(Map<String, dynamic> json) => Datum(
//         id: json["id"],
//         title: json["title"],
//         description: json["description"],
//         imageFileName: json["image_file_name"],
//         expirationDate: DateTime.parse(json["expiration_date"]),
//     );

//     Map<String, dynamic> toJson() => {
//         "id": id,
//         "title": title,
//         "description": description,
//         "image_file_name": imageFileName,
//         "expiration_date": "${expirationDate.year.toString().padLeft(4, '0')}-${expirationDate.month.toString().padLeft(2, '0')}-${expirationDate.day.toString().padLeft(2, '0')}",
//     };
// }
