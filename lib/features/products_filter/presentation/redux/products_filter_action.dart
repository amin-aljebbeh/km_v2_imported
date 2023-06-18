import 'package:dartz/dartz.dart';
import 'package:kammun_app/core/core_importer.dart';
import 'package:kammun_app/features/products/domain/entities/product_entity.dart';

import '../../domain/entities/products_pagination_entity.dart';

abstract class ProductsFilterAction {
  handle({@required Store<AppState> store});
}

class InitProductsFilter extends ProductsFilterAction {
  final BuildContext context;
  final int page;

  InitProductsFilter({this.context, this.page = 1});

  @override
  handle({Store<AppState> store}) {
    store.dispatch(NoError());
    store.dispatch(EndOfFilteredProducts(endOfProducts: false));
    store.dispatch(SetFilteredProductsPage(page: page));
    store.dispatch(SetFilteredProducts(products: []));
    store.dispatch(SetTotal(total: 0));
    store.dispatch(GetFilteredProductsAction(context: context));
  }
}

class GetFilteredProductsAction extends ProductsFilterAction {
  final BuildContext context;

  GetFilteredProductsAction({this.context});

  @override
  handle({Store<AppState> store}) {
    switch (store.state.productsFilterState.filteredProductsTypes) {
      case FilteredProductsTypes.lastActivation:
        if (store.state.productsFilterState.number <= 5) {
          Toast.show('يرجى إدخال عدد أيام أكبر من 5', context, duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
          return;
        } else {
          store.dispatch(FilterByLastActivationDateAction());
        }
        break;
      case FilteredProductsTypes.numberOfSales:
        store.dispatch(FilterByNumberOfSalesAction());
        break;
      case FilteredProductsTypes.numberOfVisits:
        store.dispatch(FilterByNumberOfVisitsAction());
        break;
      case FilteredProductsTypes.deleted:
        store.dispatch(GetDeletedProductsFromOrdersAction());
        break;
    }
  }
}

class FilterByLastActivationDateAction extends ProductsFilterAction {
  @override
  handle({Store<AppState> store}) async {
    store.dispatch(StartLoading());
    Either either = await store.state.productsFilterState.productsUSeCases.filterByLastActivationDateUseCase(
        page: store.state.productsFilterState.filteredProductsPage,
        biggerThan: store.state.productsFilterState.biggerThan ? 1 : 0,
        numberOfDays: store.state.productsFilterState.number);
    either.fold((failure) => store.dispatch(CatchError(errorMessage: 'حدث خطأ')), (page) {
      ProductsPageEntity filterPage = page;
      store.dispatch(SetFilteredProducts(products: filterPage.products));
      store.dispatch(SetTotal(total: filterPage.total));
      if (filterPage.currentPage == filterPage.lastPage) store.dispatch(EndOfFilteredProducts(endOfProducts: true));
    });
    store.dispatch(StopLoading());
  }
}

class FilterByNumberOfSalesAction extends ProductsFilterAction {
  @override
  handle({Store<AppState> store}) async {
    store.dispatch(StartLoading());
    Either either = await store.state.productsFilterState.productsUSeCases.filterByNumberOfSalesUseCase(
        page: store.state.productsFilterState.filteredProductsPage,
        biggerThan: store.state.productsFilterState.biggerThan ? 1 : 0,
        numberOfSale: store.state.productsFilterState.number);
    either.fold((failure) => store.dispatch(CatchError(errorMessage: 'حدث خطأ')), (page) {
      ProductsPageEntity filterPage = page;
      store.dispatch(SetFilteredProducts(products: filterPage.products));
      store.dispatch(SetTotal(total: filterPage.total));
      if (filterPage.currentPage == filterPage.lastPage) store.dispatch(EndOfFilteredProducts(endOfProducts: true));
    });
    store.dispatch(StopLoading());
  }
}

class FilterByNumberOfVisitsAction extends ProductsFilterAction {
  @override
  handle({Store<AppState> store}) async {
    store.dispatch(StartLoading());
    Either either = await store.state.productsFilterState.productsUSeCases.filterByNumberOfVisitsUseCase(
        page: store.state.productsFilterState.filteredProductsPage,
        biggerThan: store.state.productsFilterState.biggerThan ? 1 : 0,
        numberOfVisit: store.state.productsFilterState.number);
    either.fold((failure) => store.dispatch(CatchError(errorMessage: 'حدث خطأ')), (page) {
      ProductsPageEntity filterPage = page;
      store.dispatch(SetFilteredProducts(products: filterPage.products));
      store.dispatch(SetTotal(total: filterPage.total));
      if (filterPage.currentPage == filterPage.lastPage) store.dispatch(EndOfFilteredProducts(endOfProducts: true));
    });
    store.dispatch(StopLoading());
  }
}

class GetDeletedProductsFromOrdersAction extends ProductsFilterAction {
  @override
  handle({Store<AppState> store}) async {
    store.dispatch(StartLoading());
    Either either = await store.state.productsFilterState.productsUSeCases.getDeletedProductsFromOrdersUseCase(
      page: store.state.productsFilterState.filteredProductsPage,
      fromDate: store.state.productsFilterState.fromDate,
      toDate: store.state.productsFilterState.toDate,
    );
    either.fold((failure) => store.dispatch(CatchError(errorMessage: 'حدث خطأ')), (page) {
      ProductsPageEntity filterPage = page;
      store.dispatch(SetFilteredProducts(products: filterPage.products));
      store.dispatch(SetTotal(total: filterPage.total));
      if (filterPage.currentPage == filterPage.lastPage) store.dispatch(EndOfFilteredProducts(endOfProducts: true));
    });
    store.dispatch(StopLoading());
  }
}

class SetFilteredProducts {
  final List<ProductEntity> products;

  SetFilteredProducts({this.products});
}

class SetFilteredProductsPage {
  final int page;

  SetFilteredProductsPage({this.page});
}

class EndOfFilteredProducts {
  final bool endOfProducts;

  EndOfFilteredProducts({this.endOfProducts});
}

class SetFilteredProductsViewTypes {
  final FilteredProductsTypes type;

  SetFilteredProductsViewTypes({this.type});
}

class SetProductsFilterSearchString {
  final String searchString;

  SetProductsFilterSearchString({this.searchString});
}

class SetBiggerThan {
  final bool biggerThan;

  SetBiggerThan({this.biggerThan});
}

class SetFilterValue {
  final int value;

  SetFilterValue({this.value});
}

class SetTotal {
  final int total;

  SetTotal({this.total});
}

class SetFromDate {
  final String fromDate;

  SetFromDate({this.fromDate});
}

class SetToDate {
  final String toDate;

  SetToDate({this.toDate});
}
