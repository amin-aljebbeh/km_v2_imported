import '../../../core/core_importer.dart';

class User {
  User({
    this.id,
    this.name,
    this.phone,
    this.email,
    this.firebaseToken,
    this.isBanned,
    this.isActivated,
    this.couponId,
    this.rememberToken,
    this.createdAt,
    this.supportedCityId,
    this.warehouseId,
    this.platformType,
    this.lastActivityAt,
    this.balance,
    this.orderCount,
    this.addresses,
    this.limitTotalCost,
  });

  int id;
  dynamic name;
  String phone;
  dynamic email;
  dynamic firebaseToken;
  int isBanned;
  int isActivated;
  dynamic couponId;
  dynamic rememberToken;
  DateTime createdAt;
  int supportedCityId;
  int warehouseId;
  String platformType;
  DateTime lastActivityAt;
  String balance;
  int orderCount;
  List<AddressModel> addresses;
  int limitTotalCost;

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json['id'],
        name: json['name'],
        phone: json['phone'],
        email: json['email'],
        firebaseToken: json['firebase_token'],
        isBanned: json['is_banned'],
        isActivated: json['is_activated'],
        couponId: json['coupon_id'],
        rememberToken: json['remember_token'],
        createdAt: DateTime.parse(json['created_at']),
        supportedCityId: json['supported_city_id'],
        warehouseId: json['warehouse_id'],
        platformType: json['platform_type'],
        lastActivityAt: DateTime.parse(json['last_activity_at']),
        balance: json['balance'],
        orderCount: json['order_count'],
        addresses: List<AddressModel>.from(json['addresses'].map((x) => AddressModel.fromJson(x))),
        limitTotalCost: json['limit_total_cost'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'phone': phone,
        'email': email,
        'firebase_token': firebaseToken,
        'is_banned': isBanned,
        'is_activated': isActivated,
        'coupon_id': couponId,
        'remember_token': rememberToken,
        'created_at': createdAt.toIso8601String(),
        'supported_city_id': supportedCityId,
        'warehouse_id': warehouseId,
        'platform_type': platformType,
        'last_activity_at': lastActivityAt.toIso8601String(),
        'balance': balance,
        'order_count': orderCount,
        'addresses': List<dynamic>.from(addresses.map((x) => x.toJson())),
      };
}
