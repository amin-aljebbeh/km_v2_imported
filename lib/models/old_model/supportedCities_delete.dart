// // To parse this JSON data, do
// //
// //     final supportedCities = supportedCitiesFromJson(jsonString);

// import 'dart:convert';

// SupportedCities supportedCitiesFromJson(String str) =>
//     SupportedCities.fromJson(json.decode(str));

// String supportedCitiesToJson(SupportedCities data) =>
//     json.encode(data.toJson());

// class SupportedCities {
//   bool success;
//   List<Datum> data;

//   SupportedCities({
//     this.success,
//     this.data,
//   });

//   factory SupportedCities.fromJson(Map<String, dynamic> json) =>
//       SupportedCities(
//         success: json["success"],
//         data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
//       );

//   Map<String, dynamic> toJson() => {
//         "success": success,
//         "data": List<dynamic>.from(data.map((x) => x.toJson())),
//       };
// }

// class Datum {
//   int id;
//   String name;
//   int deliveryPrice;

//   Datum({
//     this.id,
//     this.name,
//     this.deliveryPrice,
//   });

//   factory Datum.fromJson(Map<String, dynamic> json) => Datum(
//         id: json["id"],
//         name: json["name"],
//         deliveryPrice:
//             int.parse(json["delivery_price"].toString().split(".")[0]),
//       );

//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "name": name,
//         "delivery_price": deliveryPrice,
//       };
// }
