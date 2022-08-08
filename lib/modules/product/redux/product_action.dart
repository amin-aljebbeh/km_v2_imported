import '../../../core/core_importer.dart';

class UserVisitProduct {
  final ProductData product;

  UserVisitProduct({this.product});
}

class AddProductToFavorites {
  final int productId;

  AddProductToFavorites({this.productId});
}

class RemoveProductFromFavorites {
  final int productId;

  RemoveProductFromFavorites({this.productId});
}

class NotifyMe {
  final int productId;
  final int isAlways;

  NotifyMe({this.isAlways, this.productId});
}

class DoNotNotifyMe {
  final int alertId;
  final int productId;

  DoNotNotifyMe({this.productId, this.alertId});
}

class UpdateNotify {
  final int alertId;

  UpdateNotify({this.alertId});
}
