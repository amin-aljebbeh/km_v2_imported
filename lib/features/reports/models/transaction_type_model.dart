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
        success: json['success'],
        data: json['data'] == null
            ? null
            : List<TransactionTypeModel>.from(json['data'].map((x) => TransactionTypeModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        'success': success,
        'data': data == null ? null : List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class TransactionTypeModel {
  TransactionTypeModel({this.id, this.arabicName, this.automatic});

  int id;
  String arabicName;
  int automatic;

  factory TransactionTypeModel.fromJson(Map<String, dynamic> json) => TransactionTypeModel(
      id: json['id'] ?? 'null', arabicName: json['name_ar'] ?? 'null', automatic: json['automatic'] ?? 'null');

  Map<String, dynamic> toJson() => {'id': id, 'automatic': automatic};
}
