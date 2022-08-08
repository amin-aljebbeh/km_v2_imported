import 'package:kammun_app/core/core_importer.dart';

class SaveCart {
  final List<ProductData> cartProducts;

  SaveCart({this.cartProducts});
}

class LoadCart {
  final bool goToCart;

  LoadCart({this.goToCart = false});
}

class ClearCart {}

class AddProductToCart {
  final ProductData product;
  final BuildContext context;
  final bool pop;
  final bool sync;

  AddProductToCart({this.pop = false, this.context, this.product, this.sync = false});
}

class UpdateCartProduct {
  final int count;
  final int productId;

  UpdateCartProduct({this.productId, this.count});
}

class RemoveProduct {
  final int productId;

  RemoveProduct({this.productId});
}

class CalculateSubTotal {}

class CartLoadedSuccessfully {
  final List<ProductData> cartProducts;

  CartLoadedSuccessfully({this.cartProducts});
}

class CheckLimitTotalCost {
  final bool pop;

  CheckLimitTotalCost({this.pop = false});
}

class ShowCartCancelCoupon {}

class HideCartCancelCoupon {}

class SyncAddProduct {
  final ProductData product;

  SyncAddProduct({this.product});
}
