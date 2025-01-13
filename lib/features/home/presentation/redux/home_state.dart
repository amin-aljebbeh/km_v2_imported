import '../../../../core/core_importer.dart';
import '../../data/models/special_products_model.dart';
import '../../domain/use_cases/home_use_cases.dart';

@immutable
class HomeState extends Equatable {
  final HomeUseCases homeUseCases;
  final int pageIndex;
  final bool loading;
  final List<SpecialProductsModel> specialProducts;

  const HomeState({this.specialProducts, this.homeUseCases, this.pageIndex,this.loading});

  factory HomeState.initial() {
    return HomeState(homeUseCases: sl<HomeUseCases>(), pageIndex: 0, loading: true,specialProducts: const []);
  }

  HomeState copyWith({List<SpecialProductsModel> specialProducts, int pageIndex,bool loading}) {
    return HomeState(
        homeUseCases: homeUseCases,
        pageIndex: pageIndex ?? this.pageIndex,
        specialProducts: specialProducts ?? this.specialProducts,
        loading: loading ?? this.loading);
  }

  @override
  List<Object> get props => [homeUseCases, pageIndex, loading,specialProducts];
}
