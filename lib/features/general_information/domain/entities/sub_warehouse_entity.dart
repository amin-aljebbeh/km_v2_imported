import 'sub_warehouse_level_pivot_entity.dart';

class SubWarehouseEntity {
  final int id;
  final String name;
  final int directDiscount;
  final SubWarehouseLevelPivotEntity levelPivot;
  final double discountPercentage;
  final String allowShopperAssign;

  SubWarehouseEntity({
    this.id,
    this.name,
    this.directDiscount,
    this.levelPivot,
    this.discountPercentage,
    this.allowShopperAssign,
  });
}
