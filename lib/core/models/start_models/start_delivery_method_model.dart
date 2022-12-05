import 'start_model_importer.dart';

class DeliveryMethod {
  DeliveryMethod({this.headers, this.original, this.exception});

  KHeaders headers;
  DeliveryMethodOriginal original;
  dynamic exception;

  factory DeliveryMethod.fromJson(Map<String, dynamic> json) => DeliveryMethod(
        headers: KHeaders.fromJson(json["headers"]),
        original: DeliveryMethodOriginal.fromJson(json["original"]),
        exception: json["exception"],
      );

  Map<String, dynamic> toJson() => {"headers": headers.toJson(), "original": original.toJson(), "exception": exception};
}

class DeliveryMethodOriginal {
  DeliveryMethodOriginal({this.success, this.data});

  bool success;
  List<DeliveryMethodOriginalData> data;

  factory DeliveryMethodOriginal.fromJson(Map<String, dynamic> json) => DeliveryMethodOriginal(
        success: json["success"],
        data: List<DeliveryMethodOriginalData>.from(json["data"].map((x) => DeliveryMethodOriginalData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {"success": success, "data": List<dynamic>.from(data.map((x) => x.toJson()))};
}

class DeliveryMethodOriginalData {
  DeliveryMethodOriginalData({this.id, this.name, this.price, this.isActive, this.message});

  int id;
  String name;
  String price;
  String isActive;
  String message;

  factory DeliveryMethodOriginalData.fromJson(Map<String, dynamic> json) => DeliveryMethodOriginalData(
        id: json["id"],
        name: json["name"],
        price: json["price"].toString(),
        isActive: json["is_active"].toString(),
        message: json["message"].toString(),
      );

  Map<String, dynamic> toJson() => {"id": id, "name": name, "price": price, "message": message, "is_active": isActive};
}
