import 'package:kammun_app/core/core_importer.dart';
import 'package:kammun_app/features/orders/data/models/address_model.dart';
import 'package:kammun_app/features/orders/data/models/order_image_model.dart';
import 'package:kammun_app/features/products/data/models/product_model.dart';

import '../../../shoppers/data/models/shopper_model.dart';
import '../../domain/entities/order_entity.dart';

class OrderModel extends OrderEntity {
  OrderModel(
      {id,
      deliveryCost,
      supportedCityCost,
      orderStatusId,
      deliveryMethodId,
      userId,
      userDeliveryRating,
      total,
      userNotes,
      supportedCityId,
      underUpdate,
      products,
      address,
      createdAt,
      deliveredAt,
      acceptedAt,
      shopper,
      images,
      orderAccountingRows,
      shopperProfit,
      kammunProfit,
      userFeedback,
      cashValue,
      deliveryDistance,
      collectingCost,
      walletValue,
      couponValue,
      tips,
      userPriceRating,
      user,
      subWarehouseAuthCodes})
      : super(
            id: id,
            deliveryCost: deliveryCost,
            supportedCityCost: supportedCityCost,
            orderStatusId: orderStatusId,
            deliveryMethodId: deliveryMethodId,
            userId: userId,
            userDeliveryRating: userDeliveryRating,
            total: total,
            userNotes: userNotes,
            supportedCityId: supportedCityId,
            underUpdate: underUpdate,
            products: products,
            address: address,
            createdAt: createdAt,
            deliveredAt: deliveredAt,
            acceptedAt: acceptedAt,
            shopper: shopper,
            images: images,
            orderAccountingRows: [],
            shopperProfit: shopperProfit,
            kammunProfit: kammunProfit,
            userFeedback: userFeedback,
            cashValue: cashValue,
            deliveryDistance: deliveryDistance,
            collectingCost: collectingCost,
            walletValue: walletValue,
            couponValue: couponValue,
            tips: tips,
            userPriceRating: userPriceRating,
            user: user,
            subWarehouseAuthCodes: subWarehouseAuthCodes);

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
        id: json['id'],
        deliveryCost: json['delivery_cost'].toString(),
        supportedCityCost: json['supported_city_cost'].toString(),
        orderStatusId: json['order_status_id'].toString(),
        deliveryMethodId: json['delivery_method_id'].toString(),
        userId: json['user_id'].toString(),
        userDeliveryRating: json['user_delivery_rating'].toString(),
        total: json['total'].toString(),
        user: json['user'] == null ? null : UserModel.fromJson(json['user']),
        address: json['address'] == null ? null : AddressModel.fromJson(json['address']),
        userNotes: json['user_notes'],
        createdAt: json['created_at'] == null ? null : DateTime.parse(json['created_at']),
        supportedCityId: json['supported_city_id'].toString(),
        underUpdate: json['under_update'].toString(),
        products: List<ProductModel>.from(json['products'].map((x) => ProductModel.fromJson(x))),
        shopper: json['shopper'] == null ? null : ShopperModel.fromJson(json['shopper']),
        images: json['images'] == null
            ? null
            : List<OrderImageModel>.from(json['images'].map((x) => OrderImageModel.fromJson(x))),
        shopperProfit: 0.0,
        userPriceRating: json['user_price_rating'].toString(),
        kammunProfit: 0.0,
        tips: json['tips'],
        userFeedback: json['user_feedback'] ?? 'null',
        deliveredAt:
            json['delivered_at'] != null ? DateTime.parse(json['delivered_at']) : DateTime.parse('2022-03-07 17:00:08'),
        acceptedAt:
            json['accepted_at'] != null ? DateTime.parse(json['accepted_at']) : DateTime.parse('2022-03-07 17:00:08'),
        cashValue: json['cash_v'].toString(),
        deliveryDistance: json['delivery_distance'].toString(),
        collectingCost: json['collecting_cost'].toString(),
        walletValue: json['wallet_v'].toString(),
        couponValue: json['coupon_v'].toString(),
        subWarehouseAuthCodes: json['sub_warehouse_auth_codes'] == null
            ? <OrderCodeModel>[]
            : List<OrderCodeModel>.from(json['sub_warehouse_auth_codes'].map((x) => OrderCodeModel.fromJson(x))));
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'delivery_cost': deliveryCost,
        'supported_city_cost': supportedCityCost,
        'order_status_id': orderStatusId,
        'delivery_method_id': deliveryMethodId,
        'user_id': userId,
        'user_delivery_rating': userDeliveryRating,
        'total': total,
        'created_at': createdAt.toIso8601String(),
        'user_notes': userNotes,
        'supported_city_id': supportedCityId,
        'under_update': underUpdate,
      };
}

class OrderCodeModel extends OrderCodeEntity {
  OrderCodeModel({subWarehouseId}) : super(subWarehouseId: subWarehouseId);
  factory OrderCodeModel.fromJson(Map<String, dynamic> json) =>
      OrderCodeModel(subWarehouseId: json["sub_warehouse_id"]);

  Map<String, dynamic> toJson() => {"sub_warehouse_id": subWarehouseId};
}
