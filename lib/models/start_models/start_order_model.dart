import 'dart:convert';

import 'start_model_importer.dart';
import 'package:kammun_app/views/loading/LoadingServices.dart';

import '../../Services.dart';
import '../order_accounting_row.dart';
import '../order_image.dart';

OrdersOriginal ordersFromJson(String str) =>
    OrdersOriginal.fromJson(json.decode(str));

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
        data: List<OrdersOriginalData>.from(
            json["data"].map((x) => OrdersOriginalData.fromJson(x))),
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
    this.address,
    this.userData,
    this.createdAt,
    this.delivery,
    this.shopper,
    this.images,
    this.orderAccountingRows,
    this.shopperProfit,
    this.kammunProfit,
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
  OrderAddress address;
  UserData userData;

  String userNotes;
  String supportedCityId;
  String underUpdate;
  dynamic deliveryStaffId;
  List<OrderProducts> products;
  List<OrderImage> images;
  Assigned delivery;
  Assigned shopper;

  List<OrderAccountingRow> orderAccountingRows;
  double kammunProfit;
  double shopperProfit;

  factory OrdersOriginalData.fromJson(Map<String, dynamic> json) =>
      OrdersOriginalData(
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
        couponId: json["coupon_id"].toString(),
        userDeliveryRating: json["user_delivery_rating"].toString(),
        userPriceRating: json["user_price_rating"].toString(),
        userComment: json["user_comment"].toString(),
        total: json["total"].toString(),
        userData: UserData.fromJson(json["user"]),
        address: OrderAddress.fromJson(json["address"]),
        userNotes: json["user_notes"],
        createdAt: DateTime.parse(json["created_at"]),
        supportedCityId: json["supported_city_id"].toString(),
        underUpdate: json["under_update"].toString(),
        deliveryStaffId: json["delivery_staff_id"].toString(),
        products: List<OrderProducts>.from(
            json["products"].map((x) => OrderProducts.fromJson(x))),
        shopper:
            json["shopper"] == null ? null : Assigned.fromJson(json["shopper"]),
        delivery: json["delivery"] == null
            ? null
            : Assigned.fromJson(json["delivery"]),
        images: json["images"] == null
            ? new List<OrderImage>()
            : List<OrderImage>.from(
                json["images"].map((x) => OrderImage.fromJson(x))),
        orderAccountingRows: new List<OrderAccountingRow>(),
        shopperProfit: 0,
        kammunProfit: 0,
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
        "address": address.toJson(),
        "user": userData.toJson(),
        "supported_city_id": supportedCityId,
        "under_update": underUpdate,
        "delivery_staff_id": deliveryStaffId,
        "products": List<dynamic>.from(products.map((x) => x.toJson())),
      };

  initOrderRow() {
    kammunProfit = 0;
    shopperProfit = 0;
    orderAccountingRows = new List<OrderAccountingRow>();
    for (int i = 0; i < LoadingScreenServices.subWarehouses.length; i++) {
      orderAccountingRows.add(
        new OrderAccountingRow(
          LoadingScreenServices.subWarehouses[i].id,
          LoadingScreenServices.subWarehouses[i].name,
          0,
          0,
        ),
      );
    }
    for (int i = 0; i < products.length; i++)
      if (products[i].pivot.deletedAt == null) {
        double netPrice = double.parse(products[i].pivot.purchasePrice) *
            int.parse(products[i].pivot.quantity);

        orderAccountingRows
            .firstWhere(
                (row) => row.subWarehouseId == products[i].subWarehouseId)
            .customerPay += netPrice;
        int increaseValue = products[i].pivot.increaseValue *
            int.parse(products[i].pivot.quantity);
        netPrice -= increaseValue;
        orderAccountingRows
            .firstWhere(
                (row) => row.subWarehouseId == products[i].subWarehouseId)
            .payToSubWarehouse += netPrice;
      }
    return orderAccountingRows;
  }

  accountOrderRows() {
    double shopperIncreaseProfit = 0;
    double kammunIncreaseProfit = 0;
    for (int i = 0; i < products.length; i++)
      if (products[i].pivot.deletedAt == null) {
        double netPrice = double.parse(products[i].pivot.purchasePrice) *
            int.parse(products[i].pivot.quantity);
        int increaseValue = products[i].pivot.increaseValue *
            int.parse(products[i].pivot.quantity);
        netPrice -= increaseValue;
        double shopperSubWarehouseProfit = 0.0;
        double discountPercentage = 0.0;
        double increaseProfit = 0.0;

        if (Services.shopper != null) {
          shopperSubWarehouseProfit = Services.shopper.level.subWarehouses
                  .firstWhere((subWarehouse) =>
                      subWarehouse.id == products[i].subWarehouseId)
                  .levelPivot
                  .shoppingProfitPercentage /
              100;
          increaseProfit = Services.shopper.level.subWarehouses
                  .firstWhere((subWarehouse) =>
                      subWarehouse.id == products[i].subWarehouseId)
                  .levelPivot
                  .valueAddedPercentage /
              100;
        }

        discountPercentage = LoadingScreenServices.subWarehouses
                .firstWhere((subWarehouse) =>
                    subWarehouse.id == products[i].subWarehouseId)
                .discountPercentage /
            100;

        shopperIncreaseProfit += increaseValue * increaseProfit;
        kammunIncreaseProfit +=
            increaseValue - (increaseValue * increaseProfit);
        double productKammunProfit = netPrice * discountPercentage;
        kammunProfit += productKammunProfit;
        double productShopperProfit =
            productKammunProfit * shopperSubWarehouseProfit;
        shopperProfit += productShopperProfit;
        orderAccountingRows
            .firstWhere(
                (row) => row.subWarehouseId == products[i].subWarehouseId)
            .payToSubWarehouse -= productKammunProfit;
      }
    kammunProfit -= shopperProfit;
    kammunProfit += kammunIncreaseProfit;
    shopperProfit += shopperIncreaseProfit;
    double deliverProfit = 0.0;
    if (Services.shopper != null)
      deliverProfit = Services.shopper.level.supportedCities
              .firstWhere((city) => city.id == supportedCityId)
              .levelPivot
              .deliveryProfitPercentage /
          100;
    double shopperDeliverProfit =
        double.parse(supportedCityCost) * deliverProfit;
    shopperProfit += shopperDeliverProfit;
    kammunProfit += double.parse(supportedCityCost) - shopperDeliverProfit;
  }
}

class Assigned {
  Assigned({
    this.id,
    this.name,
  });

  int id;
  String name;

  factory Assigned.fromJson(Map<String, dynamic> json) => Assigned(
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "name": name == null ? null : name,
      };
}
