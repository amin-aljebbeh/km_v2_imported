import 'package:kammun_app/features/shoppers/domain/entities/shopper_entity.dart';
import 'package:kammun_app/features/shoppers/domain/entities/shopper_level_entity.dart';

import '../../../../core/core_importer.dart';
import '../../domain/use_cases/shoppers_use_case.dart';

@immutable
class ShoppersState extends Equatable {
  final ShoppersUseCase shoppersUseCase;
  final List<ShopperEntity> shoppers;
  final ShopperEntity shopper;
  final List<ShopperLevelEntity> levels;
  final String searchFilter;

  const ShoppersState({this.shoppersUseCase, this.shoppers, this.levels, this.shopper, this.searchFilter});

  factory ShoppersState.initial() {
    return ShoppersState(
        shoppersUseCase: sl<ShoppersUseCase>(), shoppers: const [], levels: const [], searchFilter: '');
  }

  ShoppersState copyWith(
      {List<ShopperEntity> shoppers, List<ShopperLevelEntity> levels, ShopperEntity shopper, String searchFilter}) {
    return ShoppersState(
      shoppersUseCase: shoppersUseCase,
      shoppers: shoppers ?? this.shoppers,
      levels: levels ?? this.levels,
      shopper: shopper ?? this.shopper,
      searchFilter: searchFilter ?? this.searchFilter,
    );
  }

  @override
  List<Object> get props => [shoppers, shoppersUseCase, levels, shopper, searchFilter];
}
