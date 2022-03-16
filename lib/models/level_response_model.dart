import 'models_importer.dart';

class LevelModelResponse {
  LevelModelResponse({
    this.success,
    this.data,
  });

  bool success;
  Level data;

  factory LevelModelResponse.fromJson(Map<String, dynamic> json) => LevelModelResponse(
        success: json["success"] == null ? null : json["success"],
        data: json["data"] == null ? null : Level.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success == null ? null : success,
        "data": data == null ? null : data.toJson(),
      };
}

LevelsResponse levelsResponseFromJson(String str) => LevelsResponse.fromJson(json.decode(str));

String levelsResponseToJson(LevelsResponse data) => json.encode(data.toJson());

class LevelsResponse {
  LevelsResponse({
    this.success,
    this.levels,
  });

  bool success;
  List<Level> levels;

  factory LevelsResponse.fromJson(Map<String, dynamic> json) => LevelsResponse(
        success: json["success"] == null ? null : json["success"],
        levels: json["data"] == null ? null : List<Level>.from(json["data"].map((x) => Level.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success == null ? null : success,
        "data": levels == null ? null : List<dynamic>.from(levels.map((x) => x.toJson())),
      };
}
