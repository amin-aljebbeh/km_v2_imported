import '../../../../core/core_importer.dart';
import '../../data/models/special_products_model.dart';
import '../../domain/entities/banner_entity.dart';
import '../../domain/use_cases/home_use_cases.dart';

@immutable
class HomeState extends Equatable {
  final HomeUseCases homeUseCases;
  final int pageIndex;
  final bool loading;
  final List<SpecialProductsModel> specialProducts;
  final List<BannerEntity> banners;

  const HomeState({this.specialProducts, this.homeUseCases, this.pageIndex, this.loading, this.banners});

  factory HomeState.initial() {
    return HomeState(
        homeUseCases: sl<HomeUseCases>(), pageIndex: 0, loading: true, specialProducts: const [], banners: const []);
  }

  HomeState copyWith(
      {List<SpecialProductsModel> specialProducts, int pageIndex, bool loading, List<BannerEntity> banners}) {
    return HomeState(
        homeUseCases: homeUseCases,
        pageIndex: pageIndex ?? this.pageIndex,
        specialProducts: specialProducts ?? this.specialProducts,
        banners: banners ?? this.banners,
        loading: loading ?? this.loading);
  }

  @override
  List<Object> get props => [homeUseCases, pageIndex, loading, specialProducts, banners];
}
