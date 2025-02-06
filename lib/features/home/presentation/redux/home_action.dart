import 'package:dartz/dartz.dart';
import '../../../../core/core_importer.dart';
import '../../../products/domain/entities/category_products_pagination_entity.dart';
import '../../data/models/special_products_model.dart';
import '../../domain/entities/banner_entity.dart';
import 'home_state.dart';

abstract class HomeAction {
  handle({@required Store<AppState> store, HomeState state});
}

class SetPageIndex {
  final int index;

  SetPageIndex({this.index});
}

class SetSpecialProducts {
  final List<SpecialProductsModel> specialProducts;

  SetSpecialProducts({this.specialProducts});
}

class SetHomeLoadingAction {
  final bool loading;

  SetHomeLoadingAction({this.loading});
}

class SetBannerAction {
  final List<BannerEntity> banners;

  SetBannerAction({this.banners});
}

class GetBannersAction extends HomeAction {
  @override
  handle({Store<AppState> store, HomeState state}) async {
    Either either = await store.state.homeState.homeUseCases.getBannersUseCase();
    either.fold((failure) {}, (response) {
      List<BannerEntity> banners = response;
      store.dispatch(SetBannerAction(banners: banners));
    });
  }
}

class GetSpecialProductsAction extends HomeAction {
  GetSpecialProductsAction();

  @override
  handle({Store<AppState> store, HomeState state}) async {
    store.dispatch(SetHomeLoadingAction(loading: true));
    List<SpecialProductsModel> specialProducts = [];

    Either newEither = await store.state.productsState.productsUSeCases.getNewlyAddedProductsUseCase(pageNumber: 1);
    newEither.fold((failure) {}, (response) {
      CategoryProductsPaginationEntity page = response;
      if (page != null) {
        if (page.products.isNotEmpty) {
            specialProducts.add(SpecialProductsModel(
                title: 'المضافة حديثاً',
                products: page.products,
                totalNumber: page.total.toString(),
                url: featuredProductsApi,
                productsViewTypes: ProductsViewTypes.newlyAdded,
                nonActiveNumber: page.products.where((product) => product.isActive == '0').length,
                hasNext: page.nextPageUrl != null));
        }
      }
    });

    Either either = await store.state.productsState.productsUSeCases.getFeaturedProductsUseCase(pageNumber: 1);
    either.fold((failure) {}, (response) {
      CategoryProductsPaginationEntity page = response;
      if (page != null) {
        if (page.products.isNotEmpty) {
          specialProducts.add(SpecialProductsModel(
              title: 'المنتجات المميزة',
              products: page.products,
              totalNumber: page.total.toString(),
              productsViewTypes: ProductsViewTypes.featured,
              url: featuredProductsApi,
              nonActiveNumber: page.products.where((product) => product.isActive == '0').length,
              hasNext: page.nextPageUrl != null));
        }
      }
    });

    store.dispatch(SetSpecialProducts(specialProducts: specialProducts));
    store.dispatch(SetHomeLoadingAction(loading: false));
  }
}
