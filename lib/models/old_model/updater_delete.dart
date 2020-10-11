// // To parse this JSON data, do
// //
// //     final updater = updaterFromJson(jsonString);

// import 'dart:convert';

// Updater updaterFromJson(String str) => Updater.fromJson(json.decode(str));

// String updaterToJson(Updater data) => json.encode(data.toJson());

// class Updater {
//   bool success;
//   List<Datum> data;

//   Updater({
//     this.success,
//     this.data,
//   });

//   factory Updater.fromJson(Map<String, dynamic> json) => Updater(
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
//   String iosCurrentVersion;
//   String iosLastSupportedVersion;
//   String androidCurrentVersion;
//   String androidLastSupportedVersion;
//   String googlePlayUrl;
//   String appStoreUrl;

//   Datum({
//     this.id,
//     this.iosCurrentVersion,
//     this.iosLastSupportedVersion,
//     this.androidCurrentVersion,
//     this.androidLastSupportedVersion,
//     this.googlePlayUrl,
//     this.appStoreUrl,
//   });

//   factory Datum.fromJson(Map<String, dynamic> json) => Datum(
//         id: json["id"],
//         iosCurrentVersion: json["ios_current_version"],
//         iosLastSupportedVersion: json["ios_last_supported_version"],
//         androidCurrentVersion: json["android_current_version"],
//         androidLastSupportedVersion: json["android_last_supported_version"],
//         googlePlayUrl: json["google_play_url"],
//         appStoreUrl: json["app_store_url"],
//       );

//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "ios_current_version": iosCurrentVersion,
//         "ios_last_supported_version": iosLastSupportedVersion,
//         "android_current_version": androidCurrentVersion,
//         "android_last_supported_version": androidLastSupportedVersion,
//         "google_play_url": googlePlayUrl,
//         "app_store_url": appStoreUrl,
//       };
// }
