import 'dart:convert';

LogInResponse logInResponseFromJson(String str) => LogInResponse.fromJson(json.decode(str));

String logInResponseToJson(LogInResponse data) => json.encode(data.toJson());

class LogInResponse {
  LogInResponse({this.success, this.message, this.data, this.reason});

  bool success;
  String message;
  Data data;
  String reason;

  factory LogInResponse.fromJson(Map<String, dynamic> json) => LogInResponse(
        success: json['success'],
        message: json['message'].toString(),
        reason: json['reason'].toString(),
        data: json['data'] == null ? null : Data.fromJson(json['data']),
      );

  Map<String, dynamic> toJson() => {
        'success': success,
        'message': message,
        'data': data.toJson(),
      };
}

class Data {
  Data({this.id});

  int id;

  factory Data.fromJson(Map<String, dynamic> json) => Data(id: json['id']);

  Map<String, dynamic> toJson() => {'id': id};
}
