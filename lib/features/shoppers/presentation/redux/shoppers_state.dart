import 'package:kammun_app/features/shoppers/domain/entities/shopper_entity.dart';

import '../../../../core/core_importer.dart';
import '../../domain/use_cases/shoppers_use_case.dart';

@immutable
class ShoppersState extends Equatable {
  final ShoppersUseCase shoppersUseCase;
  final List<ShopperEntity> shoppers;

  const ShoppersState({this.shoppersUseCase, this.shoppers});

  factory ShoppersState.initial() {
    return ShoppersState(shoppersUseCase: sl<ShoppersUseCase>(), shoppers: const []);
  }

  ShoppersState copyWith({List<ShopperEntity> shoppers}) {
    return ShoppersState(shoppersUseCase: shoppersUseCase, shoppers: shoppers ?? this.shoppers);
  }

  @override
  List<Object> get props => [shoppers, shoppersUseCase];
}
