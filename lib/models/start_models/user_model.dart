import 'start_model_importer.dart';

class User {
  User({
    this.headers,
    this.original,
    this.exception,
  });

  KHeaders headers;
  UserOriginal original;
  dynamic exception;

  factory User.fromJson(Map<String, dynamic> json) => User(
        headers: KHeaders.fromJson(json["headers"]),
        original: UserOriginal.fromJson(json["original"]),
        exception: json["exception"],
      );

  Map<String, dynamic> toJson() => {
        "headers": headers.toJson(),
        "original": original.toJson(),
        "exception": exception,
      };
}

class UserOriginal {
  UserOriginal({
    this.success,
    this.data,
  });

  bool success;
  UserData data;

  factory UserOriginal.fromJson(Map<String, dynamic> json) => UserOriginal(
        success: json["success"],
        data: UserData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": data.toJson(),
      };
}

class UserData {
  UserData({
    this.id,
    this.name,
    this.phone,
    this.email,
    this.firebaseToken,
    this.isBanned,
    this.isActivated,
    this.couponId,
    this.rememberToken,
    this.warehouseId,
    this.supportedCityId,
    this.coupon,
    this.orderCount,
  });

  int id;
  String name;
  String phone;
  dynamic email;
  dynamic firebaseToken;
  String isBanned;
  String isActivated;
  dynamic couponId;
  dynamic rememberToken;

  String warehouseId;
  dynamic supportedCityId;

  dynamic coupon;
  int orderCount;

  factory UserData.fromJson(Map<String, dynamic> json) => UserData(
        id: json["id"],
        name: json["name"],
        phone: json["phone"],
        email: json["email"],
        firebaseToken: json["firebase_token"],
        isBanned: json["is_banned"].toString(),
        isActivated: json["is_activated"].toString(),
        couponId: json["coupon_id"].toString(),
        rememberToken: json["remember_token"].toString(),
        warehouseId: json["warehouse_id"].toString(),
        supportedCityId: json["supported_city_id"].toString(),
        coupon: json["coupon"] == null ? null : json['coupon'],
        orderCount: json['order_count'] ?? -1,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "phone": phone,
        "email": email,
        "firebase_token": firebaseToken,
        "is_banned": isBanned,
        "is_activated": isActivated,
        "coupon_id": couponId,
        "remember_token": rememberToken,
        "warehouse_id": warehouseId,
        "supported_city_id": supportedCityId,
        "coupon": coupon,
      };
}
