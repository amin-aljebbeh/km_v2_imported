import 'package:kammun_app/features/admins/data/models/admin_model.dart';
import 'package:kammun_app/features/loading/loading_services.dart';

import '../../../features/orders/model/get_order_model.dart';
import '../../core_importer.dart';

OrdersOriginal ordersFromJson(String str) => OrdersOriginal.fromJson(json.decode(str));

class OrdersOriginal {
  OrdersOriginal({this.success, this.data});

  bool success;
  PageData data;

  factory OrdersOriginal.fromJson(Map<String, dynamic> json) =>
      OrdersOriginal(success: json['success'], data: PageData.fromJson(json['data']));

  Map<String, dynamic> toJson() => {'success': success, 'data': data.toJson()};
}

class PageData {
  PageData({this.data});

  List<OrdersOriginalData> data;

  factory PageData.fromJson(Map<String, dynamic> json) =>
      PageData(data: List<OrdersOriginalData>.from(json['data'].map((x) => OrdersOriginalData.fromJson(x))));

  Map<String, dynamic> toJson() => {'data': List<dynamic>.from(data.map((x) => x.toJson()))};
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
    this.total,
    this.userNotes,
    this.supportedCityId,
    this.underUpdate,
    this.deliveryStaffId,
    this.products,
    this.address,
    this.userData,
    this.createdAt,
    this.deliveredAt,
    this.acceptedAt,
    this.shopper,
    this.images,
    this.orderAccountingRows,
    this.shopperProfit,
    this.kammunProfit,
    this.userFeedback,
    this.cashValue,
    this.deliveryDistance,
    this.collectingCost,
    this.walletValue,
    this.couponValue,
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
  String userDeliveryRating;
  dynamic userPriceRating;
  String total;
  String userFeedback;
  DateTime createdAt;
  DateTime acceptedAt;
  DateTime deliveredAt;
  OrderAddress address;
  UserData userData;
  String deliveryDistance;
  String userNotes;
  String supportedCityId;
  String underUpdate;
  dynamic deliveryStaffId;
  List<OrderProduct> products;
  List<OrderImage> images;
  Assigned shopper;
  ShowData showData;
  List<OrderAccountingRow> orderAccountingRows;
  double kammunProfit;
  double shopperProfit;
  String cashValue;
  String collectingCost;
  String walletValue;
  String couponValue;

  factory OrdersOriginalData.fromJson(Map<String, dynamic> json) => OrdersOriginalData(
      id: json['id'],
      expectedTimeMinutes: json['expected_time_minutes'].toString(),
      deliveryCost: json['delivery_cost'].toString(),
      supportedCityCost: json['supported_city_cost'].toString(),
      orderStatusId: json['order_status_id'].toString(),
      paymentMethodId: json['payment_method_id'].toString(),
      deliveryMethodId: json['delivery_method_id'].toString(),
      warehouseId: json['warehouse_id'].toString(),
      addressId: json['address_id'].toString(),
      userId: json['user_id'].toString(),
      couponId: json['coupon_id'].toString(),
      userDeliveryRating: json['user_delivery_rating'].toString(),
      userPriceRating: json['user_price_rating'].toString(),
      total: json['total'].toString(),
      userData: json['user'] == null ? null : UserData.fromJson(json['user']),
      address: json['address'] == null ? null : OrderAddress.fromJson(json['address']),
      userNotes: json['user_notes'],
      createdAt: json['created_at'] == null ? null : DateTime.parse(json['created_at']),
      supportedCityId: json['supported_city_id'].toString(),
      underUpdate: json['under_update'].toString(),
      deliveryStaffId: json['delivery_staff_id'].toString(),
      products: List<OrderProduct>.from(json['products'].map((x) => OrderProduct.fromJson(x))),
      shopper: json['shopper'] == null ? null : Assigned.fromJson(json['shopper']),
      images: json['images'] == null ? [] : List<OrderImage>.from(json['images'].map((x) => OrderImage.fromJson(x))),
      orderAccountingRows: [],
      shopperProfit: 0,
      kammunProfit: 0,
      userFeedback: json['user_feedback'] ?? 'null',
      deliveredAt:
          json['delivered_at'] != null ? DateTime.parse(json['delivered_at']) : DateTime.parse('2022-03-07 17:00:08'),
      acceptedAt:
          json['accepted_at'] != null ? DateTime.parse(json['accepted_at']) : DateTime.parse('2022-03-07 17:00:08'),
      cashValue: json['cash_v'].toString(),
      deliveryDistance: json['delivery_distance'].toString(),
      collectingCost: json['collecting_cost'].toString(),
      walletValue: json['wallet_v'].toString(),
      couponValue: json['coupon_v'].toString());

  Map<String, dynamic> toJson() => {
        'id': id,
        'expected_time_minutes': expectedTimeMinutes,
        'delivery_cost': deliveryCost,
        'supported_city_cost': supportedCityCost,
        'order_status_id': orderStatusId,
        'payment_method_id': paymentMethodId,
        'delivery_method_id': deliveryMethodId,
        'warehouse_id': warehouseId,
        'address_id': addressId,
        'user_id': userId,
        'coupon_id': couponId,
        'user_delivery_rating': userDeliveryRating,
        'user_price_rating': userPriceRating,
        'total': total,
        'created_at': createdAt.toIso8601String(),
        'user_notes': userNotes,
        'address': address.toJson(),
        'user': userData.toJson(),
        'supported_city_id': supportedCityId,
        'under_update': underUpdate,
        'delivery_staff_id': deliveryStaffId,
        'products': List<dynamic>.from(products.map((x) => x.toJson())),
      };

  orderArithmeticOperations() {
    OrderAccountingRow row = OrderAccountingRow(
        subWarehouseId: 0,
        subWarehouseName: 'subWarehouse.name',
        netPrice: 0,
        payToSubWarehouse: 0,
        increaseValuesSum: 0,
        directDiscount: 0);
    kammunProfit = 0;
    shopperProfit = 0;
    orderAccountingRows = LoadingScreenServices.subWarehouses
        .map((subWarehouse) => OrderAccountingRow(
            subWarehouseId: subWarehouse.id,
            subWarehouseName: subWarehouse.name,
            netPrice: 0,
            payToSubWarehouse: 0,
            increaseValuesSum: 0,
            directDiscount: subWarehouse.directDiscount))
        .toList();
    products.where((product) => product.pivot.deletedAt == 'null').forEach((product) {
      double netPrice = double.parse(product.pivot.purchasePrice) * int.parse(product.pivot.quantity);
      int increaseValue = product.pivot.increaseValue * int.parse(product.pivot.quantity);
      netPrice -= increaseValue;
      orderAccountingRows
          .firstWhere((row) => row.subWarehouseId == product.pivot.subWarehouseId, orElse: () => row)
          .increaseValuesSum += increaseValue;
      orderAccountingRows
          .firstWhere((row) => row.subWarehouseId == product.pivot.subWarehouseId, orElse: () => row)
          .netPrice += netPrice;
      double discountPercentage = SubWarehouse.getDiscountPercentage(product.pivot.subWarehouseId);
      orderAccountingRows
          .firstWhere((row) => row.subWarehouseId == product.pivot.subWarehouseId, orElse: () => row)
          .payToSubWarehouse += netPrice;
      orderAccountingRows
          .firstWhere((row) => row.subWarehouseId == product.pivot.subWarehouseId && row.directDiscount == 1,
              orElse: () => row)
          .payToSubWarehouse -= (netPrice * discountPercentage);
    });
    return orderAccountingRows;
  }

  orderProfits() {
    if (shopper == null) {
      shopperProfit = 0;
      kammunProfit = 0;
    } else {
      Level orderLevel;
      if (Services.isShopper()) {
        orderLevel = Services.shopper.level;
      } else {
        orderLevel = LoadingScreenServices.levels.firstWhere((level) => level.id == shopper.levelId);
      }
      for (int i = 0; i < orderAccountingRows.length; i++) {
        double shopperSubWarehouseProfit = 0.0;
        double increaseProfit = 0.0;
        SubWarehouseLevelPivot pivot = orderLevel.subWarehouses
            .firstWhere((subWarehouse) => subWarehouse.id == orderAccountingRows[i].subWarehouseId,
                orElse: () => SubWarehouse(
                    levelPivot: SubWarehouseLevelPivot(
                        subWarehouseId: 0,
                        levelId: 0,
                        valueAddedPercentage: 0,
                        shoppingProfitPercentage: 0,
                        minProfit: 1,
                        maxProfit: 10000000000)))
            .levelPivot;
        shopperSubWarehouseProfit = pivot.shoppingProfitPercentage / 100;
        increaseProfit = pivot.valueAddedPercentage / 100;
        double discountPercentage = SubWarehouse.getDiscountPercentage(orderAccountingRows[i].subWarehouseId);
        shopperProfit += orderAccountingRows[i].increaseValuesSum * increaseProfit;
        kammunProfit +=
            orderAccountingRows[i].increaseValuesSum - (orderAccountingRows[i].increaseValuesSum * increaseProfit);
        double productKammunProfit = orderAccountingRows[i].netPrice * discountPercentage;
        double addedProfit = productKammunProfit * shopperSubWarehouseProfit;
        if (addedProfit > pivot.maxProfit) addedProfit = pivot.maxProfit.toDouble();
        if (addedProfit < pivot.minProfit) addedProfit = pivot.minProfit.toDouble();
        kammunProfit += (productKammunProfit - addedProfit);
        shopperProfit += addedProfit;
      }
      double deliverProfit = 0.0;
      double cityCost = double.parse(supportedCityCost);
      cityCost += double.parse(collectingCost);
      deliverProfit = orderLevel.supportedCities
              .firstWhere((city) => city.id == supportedCityId)
              .levelPivot
              .deliveryProfitPercentage /
          100;
      double shopperDeliverProfit = cityCost * deliverProfit;
      shopperProfit += shopperDeliverProfit;
      kammunProfit += cityCost - shopperDeliverProfit;
    }
  }
}

class Assigned {
  Assigned({this.id, this.name, this.admin, this.levelId});

  int id;
  String name;
  AdminModel admin;
  int levelId;

  factory Assigned.fromJson(Map<String, dynamic> json) => Assigned(
      id: json['id'],
      name: json['name'],
      admin: json['admin'] == null ? null : AdminModel.fromJson(json['admin']),
      levelId: json['level_id'] ?? 0);

  Map<String, dynamic> toJson() => {'id': id, 'name': name, 'admin': admin};
}
