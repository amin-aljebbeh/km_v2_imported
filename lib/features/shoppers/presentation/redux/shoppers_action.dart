import '../../domain/entities/shopper_entity.dart';

class SetShoppers {
  final List<ShopperEntity> shoppers;

  SetShoppers({this.shoppers});
}

class ShopperChanged {
  final ShopperEntity shopper;

  ShopperChanged({this.shopper});
}
