import '../../domain/entities/shopper_entity.dart';
import '../../domain/entities/shopper_level_entity.dart';

class SetShoppers {
  final List<ShopperEntity> shoppers;

  SetShoppers({this.shoppers});
}

class ShopperChanged {
  final ShopperEntity shopper;

  ShopperChanged({this.shopper});
}

class SetLevels {
  final List<ShopperLevelEntity> levels;

  SetLevels({this.levels});
}

class SetShopper {
  final ShopperEntity shopper;

  SetShopper({this.shopper});
}

class SetShoppersSearchFilter {
  final String searchFilter;

  SetShoppersSearchFilter({this.searchFilter});
}
