import 'package:kammun_app/features/orders_feature/domain/entities/address_entity.dart';
import 'package:kammun_app/features/orders_feature/domain/entities/order_image_entity.dart';
import 'package:kammun_app/features/products/domain/entities/product_entity.dart';
import 'package:kammun_app/features/shoppers/domain/entities/shopper_entity.dart';
import 'package:kammun_app/features/users/domain/entities/user_entity.dart';

class OrderEntity {
  int id;
  String deliveryCost;
  String supportedCityCost;
  String orderStatusId;
  String deliveryMethodId;
  String warehouseId;
  String userId;
  String userDeliveryRating;
  String userPriceRating;
  String total;
  String userFeedback;
  DateTime createdAt;
  DateTime acceptedAt;
  DateTime deliveredAt;
  AddressEntity address;
  UserEntity user;
  String deliveryDistance;
  String userNotes;
  String supportedCityId;
  String underUpdate;
  List<ProductEntity> products;
  List<OrderImageEntity> images;
  ShopperEntity shopper;
  List<OrderAccountingRow> orderAccountingRows;
  double kammunProfit;
  double shopperProfit;
  String cashValue;
  String collectingCost;
  String walletValue;
  String couponValue;
  int tips;

  OrderEntity({
    this.id,
    this.deliveryCost,
    this.supportedCityCost,
    this.orderStatusId,
    this.deliveryMethodId,
    this.warehouseId,
    this.userId,
    this.userDeliveryRating,
    this.total,
    this.userNotes,
    this.supportedCityId,
    this.underUpdate,
    this.products,
    this.address,
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
    this.tips,
    this.userPriceRating,
    this.user,
  });
}

class OrderAccountingRow {
  int subWarehouseId;
  String subWarehouseName;
  double netPrice;
  double payToSubWarehouse;
  double increaseValuesSum;
  int directDiscount;

  OrderAccountingRow({
    this.subWarehouseId,
    this.subWarehouseName,
    this.netPrice,
    this.payToSubWarehouse,
    this.increaseValuesSum,
    this.directDiscount,
  });
}
