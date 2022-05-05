import 'models_importer.dart';

OrdersOriginal ordersFromJson(String str) => OrdersOriginal.fromJson(json.decode(str));

class Orders {
  Orders({
    this.headers,
    this.original,
    this.exception,
  });

  Headers headers;
  OrdersOriginal original;
  dynamic exception;

  factory Orders.fromJson(Map<String, dynamic> json) => Orders(
        headers: Headers.fromJson(json["headers"]),
        original: OrdersOriginal.fromJson(json["original"]),
        exception: json["exception"],
      );

  Map<String, dynamic> toJson() => {
        "headers": headers.toJson(),
        "original": original.toJson(),
        "exception": exception,
      };
}

class OrdersOriginal {
  OrdersOriginal({
    this.success,
    this.data,
  });

  bool success;
  PageData data;

  factory OrdersOriginal.fromJson(Map<String, dynamic> json) => OrdersOriginal(
        success: json["success"],
        data: PageData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": data.toJson(),
      };
}

class PageData {
  PageData({
    this.data,
  });

  List<OrdersOriginalData> data;

  factory PageData.fromJson(Map<String, dynamic> json) => PageData(
        data: List<OrdersOriginalData>.from(json["data"].map((x) => OrdersOriginalData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class OrdersOriginalData {
  OrdersOriginalData({
    this.id,
    this.expectedTimeMinutes,
    this.deliveryCost,
    this.supportedCityCost,
    this.orderStatusId,
    this.paymentMethodId,
    this.deliveryMethodId,
    this.warehouseId,
    this.addressId,
    this.userId,
    this.couponId,
    this.userDeliveryRating,
    this.userPriceRating,
    this.userComment,
    this.total,
    this.userNotes,
    this.supportedCityId,
    this.underUpdate,
    this.deliveryStaffId,
    this.products,
    this.createdAt,
  });

  int id;
  String expectedTimeMinutes;
  String deliveryCost;
  String supportedCityCost;
  String orderStatusId;
  String paymentMethodId;
  String deliveryMethodId;
  String warehouseId;
  String addressId;
  String userId;
  dynamic couponId;
  dynamic userDeliveryRating;
  dynamic userPriceRating;
  dynamic userComment;
  String total;
  DateTime createdAt;

  String userNotes;
  String supportedCityId;
  String underUpdate;
  dynamic deliveryStaffId;
  List<OrderProducts> products;

  factory OrdersOriginalData.fromJson(Map<String, dynamic> json) => OrdersOriginalData(
        id: json["id"],
        expectedTimeMinutes: json["expected_time_minutes"].toString(),
        deliveryCost: json["delivery_cost"].toString(),
        supportedCityCost: json["supported_city_cost"].toString(),
        orderStatusId: json["order_status_id"].toString(),
        paymentMethodId: json["payment_method_id"].toString(),
        deliveryMethodId: json["delivery_method_id"].toString(),
        warehouseId: json["warehouse_id"].toString(),
        addressId: json["address_id"].toString(),
        userId: json["user_id"].toString(),
        couponId: json["coupon_id"],
        userDeliveryRating: json["user_delivery_rating"],
        userPriceRating: json["user_price_rating"],
        userComment: json["user_comment"],
        total: json["total"].toString(),
        userNotes: json["user_notes"].toString(),
        createdAt: DateTime.parse(json["created_at"]),
        supportedCityId: json["supported_city_id"].toString(),
        underUpdate: json["under_update"].toString(),
        deliveryStaffId: json["delivery_staff_id"].toString(),
        products: List<OrderProducts>.from(json["products"].map((x) => OrderProducts.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "expected_time_minutes": expectedTimeMinutes,
        "delivery_cost": deliveryCost,
        "supported_city_cost": supportedCityCost,
        "order_status_id": orderStatusId,
        "payment_method_id": paymentMethodId,
        "delivery_method_id": deliveryMethodId,
        "warehouse_id": warehouseId,
        "address_id": addressId,
        "user_id": userId,
        "coupon_id": couponId,
        "user_delivery_rating": userDeliveryRating,
        "user_price_rating": userPriceRating,
        "user_comment": userComment,
        "total": total,
        "created_at": createdAt.toIso8601String(),
        "user_notes": userNotes,
        "supported_city_id": supportedCityId,
        "under_update": underUpdate,
        "delivery_staff_id": deliveryStaffId,
        "products": List<dynamic>.from(products.map((x) => x.toJson())),
      };
}
