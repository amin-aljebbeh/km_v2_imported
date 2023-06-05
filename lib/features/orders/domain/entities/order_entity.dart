import 'package:kammun_app/features/orders/domain/entities/address_entity.dart';
import 'package:kammun_app/features/orders/domain/entities/order_image_entity.dart';
import 'package:kammun_app/features/products/domain/entities/product_entity.dart';
import 'package:kammun_app/features/shoppers/domain/entities/shopper_entity.dart';
import 'package:kammun_app/features/users/domain/entities/user_entity.dart';

import '../../../../core/core_importer.dart';

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
    orderAccountingRows = StaticVariables.subWarehouses
        .where((subWarehouse) => products.map((product) => product.subWarehouseId).contains(subWarehouse.id))
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
  }

  orderProfits({BuildContext context}) {
    if (shopper == null) {
      shopperProfit = 0;
      kammunProfit = 0;
    } else {
      Level orderLevel;
      if (Services.hasRole(context, shopperRole)) {
        orderLevel = StaticVariables.shopper.level;
      } else {
        orderLevel = StaticVariables.levels.firstWhere((level) => level.id == shopper.levelId);
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
                        minProfit: -1,
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
