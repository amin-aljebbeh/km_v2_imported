import 'package:meta/meta.dart';

import '../model/special_products_model.dart';

@immutable
class HomePageState {
  final List<SpecialProductsModel> specialProducts;
  final bool loading;

  const HomePageState({this.loading, this.specialProducts});

  factory HomePageState.initial() {
    return const HomePageState(specialProducts: [], loading: true);
  }

  HomePageState copyWith({List<SpecialProductsModel> specialProducts, bool loading}) {
    return HomePageState(
        specialProducts: specialProducts ?? this.specialProducts, loading: loading ?? this.loading);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HomePageState && specialProducts == other.specialProducts && loading == other.loading;

  @override
  int get hashCode => super.hashCode;
}
