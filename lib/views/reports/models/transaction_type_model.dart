// To parse this JSON data, do
//
//     final empty = emptyFromJson(jsonString);

import 'dart:convert';

TransactionTypeResponse transactionTypeResponseFromJson(String str) =>
    TransactionTypeResponse.fromJson(json.decode(str));

String transactionTypeResponseToJson(TransactionTypeResponse data) => json.encode(data.toJson());

class TransactionTypeResponse {
  TransactionTypeResponse({
    this.success,
    this.data,
  });

  bool success;
  List<TransactionTypeModel> data;

  factory TransactionTypeResponse.fromJson(Map<String, dynamic> json) => TransactionTypeResponse(
        success: json["success"] == null ? null : json["success"],
        data: json["data"] == null
            ? null
            : List<TransactionTypeModel>.from(json["data"].map((x) => TransactionTypeModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success == null ? null : success,
        "data": data == null ? null : List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class TransactionTypeModel {
  TransactionTypeModel({
    this.id,
    this.name,
    this.arabicName,
    this.slug,
    this.description,
    this.automatic,
  });

  int id;
  String name;
  String arabicName;
  String slug;
  String description;
  int automatic;

  factory TransactionTypeModel.fromJson(Map<String, dynamic> json) => TransactionTypeModel(
        id: json["id"] == null ? 'null' : json["id"],
        name: json["name"] == null ? 'null' : json["name"],
        arabicName: json["name_ar"] == null ? 'null' : json["name_ar"],
        slug: json["slug"] == null ? 'null' : json["slug"],
        description: json["description"] == null ? 'null' : json["description"],
        automatic: json["automatic"] == null ? 'null' : json["automatic"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "name": name == null ? null : name,
        "slug": slug == null ? null : slug,
        "description": description == null ? null : description,
        "automatic": automatic == null ? null : automatic,
      };
}
