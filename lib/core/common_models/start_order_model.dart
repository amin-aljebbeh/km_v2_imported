import 'package:kammun_app/core/core_importer.dart';

GetOrdersModel getOrdersModelFromJson(String str) => GetOrdersModel.fromJson(json.decode(str));

String getOrdersModelToJson(GetOrdersModel data) => json.encode(data.toJson());

class GetOrdersModel {
  GetOrdersModel({
    this.success,
    this.orders,
  });

  bool success;
  List<OrdersOriginalData> orders;

  factory GetOrdersModel.fromJson(Map<String, dynamic> json) => GetOrdersModel(
        success: json['success'],
        orders: List<OrdersOriginalData>.from(json['data'].map((x) => OrdersOriginalData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        'success': success,
        'data': List<dynamic>.from(orders.map((x) => x.toJson())),
      };
}

class OrdersOriginalData {
  OrdersOriginalData({
    this.id,
    this.orderStatusId,
    this.paymentMethodId,
    this.deliveryMethodId,
    this.warehouseId,
    this.addressId,
    this.userId,
    this.deliveryId,
    this.shopperId,
    this.couponId,
    this.userDeliveryRating,
    this.userPriceRating,
    this.userFeedback,
    this.createdAt,
    this.cashV,
    this.updatedAt,
    this.acceptedAt,
    this.readyAt,
    this.shippedAt,
    this.deliveredAt,
    this.deletedAt,
    this.userNotes,
    this.supportedCityId,
    this.underUpdate,
    this.deliveryStaffId,
    this.transactionsCompleted,
    this.products,
    this.shopper,
    this.address,
    this.supportedCity,
  });

  int id;
  String orderStatusId;
  int paymentMethodId;
  int deliveryMethodId;
  int warehouseId;
  String addressId;
  int userId;
  dynamic deliveryId;
  dynamic shopperId;
  int couponId;
  dynamic userDeliveryRating;
  dynamic userPriceRating;
  dynamic userFeedback;
  String cashV;
  DateTime createdAt;
  DateTime updatedAt;
  dynamic acceptedAt;
  dynamic readyAt;
  dynamic shippedAt;
  dynamic deliveredAt;
  dynamic deletedAt;
  dynamic userNotes;
  int supportedCityId;
  String underUpdate;
  dynamic deliveryStaffId;
  int transactionsCompleted;
  List<OrderProducts> products;
  Shopper shopper;
  AddressModel address;
  SupportedCityModel supportedCity;

  factory OrdersOriginalData.fromJson(Map<String, dynamic> json) => OrdersOriginalData(
        id: json['id'],
        orderStatusId: json['order_status_id'].toString(),
        paymentMethodId: json['payment_method_id'],
        deliveryMethodId: json['delivery_method_id'],
        warehouseId: json['warehouse_id'],
        addressId: json['address_id'].toString(),
        userId: json['user_id'],
        deliveryId: json['delivery_id'],
        shopperId: json['shopper_id'],
        couponId: json['coupon_id'],
        cashV: json['cash_v'].toString(),
        userDeliveryRating: json['user_delivery_rating'],
        userPriceRating: json['user_price_rating'],
        userFeedback: json['user_feedback'],
        createdAt: json['created_at'] == null ? null : DateTime.parse(json['created_at']),
        updatedAt: json['updated_at'] == null ? null : DateTime.parse(json['updated_at']),
        acceptedAt: json['accepted_at'],
        readyAt: json['ready_at'],
        shippedAt: json['shipped_at'],
        deliveredAt: json['delivered_at'],
        deletedAt: json['deleted_at'],
        userNotes: json['user_notes'],
        supportedCityId: json['supported_city_id'],
        underUpdate: json['under_update'].toString(),
        deliveryStaffId: json['delivery_staff_id'],
        transactionsCompleted: json['transactions_completed'],
        supportedCity: json['supported_city'] != null ? SupportedCityModel.fromJson(json['supported_city']) : null,
        products: json['products'] == null
            ? null
            : List<OrderProducts>.from(json['products'].map((x) => OrderProducts.fromJson(x))),
        shopper: json['shopper'] == null ? null : Shopper.fromJson(json['shopper']),
        address: json['address'] == null ? null : AddressModel.fromJson(json['address']),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'order_status_id': orderStatusId,
        'payment_method_id': paymentMethodId,
        'delivery_method_id': deliveryMethodId,
        'warehouse_id': warehouseId,
        'address_id': addressId,
        'user_id': userId,
        'delivery_id': deliveryId,
        'shopper_id': shopperId,
        'coupon_id': couponId,
        'user_delivery_rating': userDeliveryRating,
        'user_price_rating': userPriceRating,
        'user_feedback': userFeedback,
        'created_at': createdAt.toIso8601String(),
        'updated_at': updatedAt.toIso8601String(),
        'accepted_at': acceptedAt,
        'ready_at': readyAt,
        'shipped_at': shippedAt,
        'delivered_at': deliveredAt,
        'deleted_at': deletedAt,
        'user_notes': userNotes,
        'supported_city_id': supportedCityId,
        'under_update': underUpdate,
        'delivery_staff_id': deliveryStaffId,
        'transactions_completed': transactionsCompleted,
        'products': List<dynamic>.from(products.map((x) => x.toJson())),
        'shopper': shopper,
      };
}

class Shopper {
  Shopper({this.id, this.name, this.levelId});

  int id;
  String name;
  int levelId;

  factory Shopper.fromJson(Map<String, dynamic> json) => Shopper(
        id: json['id'],
        name: json['name'],
        levelId: json['level_id'],
      );

  Map<String, dynamic> toJson() => {'id': id, 'name': name, 'level_id': levelId};
}
