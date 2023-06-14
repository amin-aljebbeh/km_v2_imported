import 'package:kammun_app/core/core_importer.dart';
import 'package:kammun_app/features/products/domain/entities/product_entity.dart';

abstract class ProductsFilterAction {
  handle({@required Store<AppState> store});
}

class GetFilteredProductsAction extends ProductsFilterAction {
  @override
  handle({Store<AppState> store}) {
    switch (store.state.productsState.productsViewType) {
      case ProductsViewTypes.search:
        // TODO: Handle this case.
        break;
      case ProductsViewTypes.category:
        // TODO: Handle this case.
        break;
      case ProductsViewTypes.barcode:
        // TODO: Handle this case.
        break;
    }
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
