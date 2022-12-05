import 'start_model_importer.dart';

class KBanner {
  KBanner({this.headers, this.original, this.exception});

  KHeaders headers;
  BannerOriginal original;
  dynamic exception;

  factory KBanner.fromJson(Map<String, dynamic> json) => KBanner(
        headers: KHeaders.fromJson(json['headers']),
        original: BannerOriginal.fromJson(json['original']),
        exception: json['exception'],
      );

  Map<String, dynamic> toJson() => {'headers': headers.toJson(), 'original': original.toJson(), 'exception': exception};
}

class BannerOriginal {
  BannerOriginal({this.success, this.data});

  bool success;
  List<PurpleDatum> data;

  factory BannerOriginal.fromJson(Map<String, dynamic> json) => BannerOriginal(
        success: json['success'],
        data: List<PurpleDatum>.from(json['data'].map((x) => PurpleDatum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {'success': success, 'data': List<dynamic>.from(data.map((x) => x.toJson()))};
}

class PurpleDatum {
  PurpleDatum({this.id, this.title, this.description, this.imageFileName, this.expirationDate, this.warehouseId});

  int id;
  String title;
  String description;
  String imageFileName;
  DateTime expirationDate;
  String warehouseId;

  factory PurpleDatum.fromJson(Map<String, dynamic> json) => PurpleDatum(
        id: json['id'],
        title: json['title'],
        description: json['description'],
        imageFileName: json['image_file_name'],
        expirationDate: DateTime.parse(json['expiration_date']),
        warehouseId: json['warehouse_id'].toString(),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'image_file_name': imageFileName,
        'expiration_date': expirationDate.toIso8601String(),
        'warehouse_id': warehouseId,
      };
}
