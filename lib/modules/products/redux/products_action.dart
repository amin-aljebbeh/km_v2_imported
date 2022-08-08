import '../../../core/core_importer.dart';

class GetProducts {
  final ProductsViewTypes productsViewTypes;
  final String query;

  GetProducts({this.query, this.productsViewTypes});
}

class GetCategory {
  final String categoryId;

  GetCategory({this.categoryId});
}

class SearchProduct {
  final String query;

  SearchProduct({this.query});
}

class GetFavorites {}

class GetAlertProduct {}

class GetBarcodeProducts {
  final String code;

  GetBarcodeProducts({this.code});
}

class ProductsFetchedSuccessfully {
  final List<ProductData> products;

  ProductsFetchedSuccessfully({this.products});
}

class SetAlertProducts {
  final List<ProductData> products;

  SetAlertProducts({this.products});
}

class EndOfProducts {}

class EmptyList {}

class HandleResponse {
  final List<ProductData> products;

  HandleResponse({this.products});
}

class NextProductsPage {}

class FirstProductPage {}

class AddProductToFavoritesList {
  final int productId;

  AddProductToFavoritesList({this.productId});
}

class RemoveProductFromFavoritesList {
  final int productId;

  RemoveProductFromFavoritesList({this.productId});
}

class SaveFavorites {
  final List<int> favorites;

  SaveFavorites({this.favorites});
}

class ProductAddedToFavoritesSuccessfully {
  final int productId;

  ProductAddedToFavoritesSuccessfully({this.productId});
}

class ProductRemovedFromFavoritesSuccessfully {
  final int productId;

  ProductRemovedFromFavoritesSuccessfully({this.productId});
}

class NotificationRequestSentSuccessfully {
  final int alertId;
  final int productId;

  NotificationRequestSentSuccessfully({this.alertId, this.productId});
}

class NotificationRequestDeletedSuccessfully {
  final int productId;

  NotificationRequestDeletedSuccessfully({this.productId});
}

class SetType {
  final ProductsViewTypes productsViewTypes;

  SetType({this.productsViewTypes});
}

class GetFeaturedProducts {
  final String url;

  GetFeaturedProducts({this.url});
}
