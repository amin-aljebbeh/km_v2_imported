import 'models_importer.dart';

class ModelResponse {
  ModelResponse({
    this.success,
    this.data,
  });

  bool success;
  Level data;

  factory ModelResponse.fromJson(Map<String, dynamic> json) => ModelResponse(
        success: json["success"] == null ? null : json["success"],
        data: json["data"] == null ? null : Level.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success == null ? null : success,
        "data": data == null ? null : data.toJson(),
      };
}
