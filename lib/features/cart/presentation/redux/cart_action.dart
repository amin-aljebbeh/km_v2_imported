import 'package:dartz/dartz.dart';
import 'package:kammun_app/features/cart/presentation/pages/final_cart_page.dart';
import 'package:kammun_app/features/products/domain/entities/product_entity.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../../../../core/core_importer.dart';
import '../../../products/domain/entities/order_product_pivot_entity.dart';
import '../../../thank_you/pages/thank_you_view.dart';
import '../../domain/entities/submit_order_entity.dart';
import '../../domain/entities/update_order_response_entity.dart';
import '../pages/order_problem_sheet.dart';

abstract class CartAction {
  handle({@required Store<AppState> store});
}

class GetCartAction extends CartAction {
  GetCartAction();

  @override
  handle({Store<AppState> store}) async {
    store.dispatch(StartLoading());
    List<int> counts = store.state.cartState.cartProducts.map((product) => product.productCount).toList();
    String cart = store.state.cartState.cartProducts.fold('', (ids, product) => ids + product.id.toString() + ';');
    cart.replaceRange(cart.length - 1, cart.length, '');

    Either either = await store.state.cartState.cartUSeCases.getCartUseCase(cart: cart);
    either.fold((failure) {}, (response) {
      List<ProductEntity> products = response;
      for (int i = 0; i < products.length; i++) {
        if (products[i] != null) {
          products[i].productCount = counts[i];
          products[i].pivot = OrderProductPivotEntity(increaseValue: products[i].increasePercentage);
        }
      }
      store.dispatch(SetCartProducts(products: products));
    });
    store.dispatch(StopLoading());
  }
}

class UpdateCartProducts extends CartAction {
  final int productId, quantity;
  final ProductEntity product;
  final BuildContext context;

  UpdateCartProducts({this.productId, this.quantity, this.product, this.context});

  @override
  handle({Store<AppState> store}) {
    List<ProductEntity> products = [];
    products.addAll(store.state.cartState.cartProducts);
    if (quantity == 0) {
      products.removeWhere((product) => product.id == productId);
    } else {
      if (products.map((product) => product.id).contains(productId)) {
        products.firstWhere((product) => product.id == productId).productCount = quantity;
      } else {
        products.add(product);
        if (StoreProvider.of<AppState>(context).state.generalInformationState.subWarehouses.length == 1) {
          products.sort((a, b) {
            if (a.subWarehouseId > b.subWarehouseId) {
              return -1;
            } else if (a.subWarehouseId < b.subWarehouseId) {
              return 1;
            } else {
              return 0;
            }
          });
        } else {
          products.sort((a, b) {
            if (a.subWarehouseId > b.subWarehouseId) {
              return 1;
            } else if (a.subWarehouseId < b.subWarehouseId) {
              return -1;
            } else {
              return 0;
            }
          });
        }
      }
    }
    if (context != null) snackBar(success: true, message: 'تم إضافة ${product.name} لسلة المشتريات', context: context);
    store.dispatch(SetCartProducts(products: products));
  }
}

class UpdateOrderAction extends CartAction {
  final BuildContext context;
  final SubmitOrderEntity submitOrderEntity;

  UpdateOrderAction({this.submitOrderEntity, this.context});

  @override
  handle({Store<AppState> store}) async {
    store.dispatch(StartLoading());
    Either either = await store.state.cartState.cartUSeCases
        .updateOrderUSeCase(submitOrderEntity: submitOrderEntity, orderId: store.state.cartState.orderUnderUpdateId);
    either.fold((failure) {
      if (failure is OfflineRegionFailure) {
        store.dispatch(CatchError(errorMessage: failure.message));
      } else {
        store.dispatch(CatchError(errorMessage: 'حدث خطأ يرجى إعادة المحاولة لاحقاً'));
      }
      store.dispatch(StopLoading());
    }, (updateResponse) {
      UpdateOrderResponseEntity response = updateResponse;
      if (response.changedPriceProducts.isNotEmpty || response.inactiveProducts.isNotEmpty) {
        List<int> notActiveId = [];
        List<int> priceId = [];

        notActiveId = store.state.cartState.cartProducts
            .where((order) => response.inactiveProducts.contains(order.id.toString()))
            .toList()
            .map((order) => order.id)
            .toList();
        priceId = store.state.cartState.cartProducts
            .where((product) => response.changedPriceProducts
                .map((priceProduct) => priceProduct.id.toString())
                .toList()
                .contains(product.id.toString()))
            .toList()
            .map((product) => product.id)
            .toList();
        store.dispatch(StopLoading());
        showMaterialModalBottomSheet(
          context: context,
          builder: (context) => OrderProblemBottomSheet(
            notActiveProducts: notActiveId,
            cartProducts: store.state.cartState.cartProducts,
            pricesChangesProducts: priceId,
            applyChanges: (submitOrder) {
              if (submitOrder) {
                submitOrderEntity.checkChangedPriceProduct = 0;
                store.dispatch(UpdateOrderAction(context: context, submitOrderEntity: submitOrderEntity));
              } else {
                Navigator.of(context).pop();
                store.dispatch(GetCartAction());
                Navigator.of(context).pop();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            FinalCartPage(userNotes: TextEditingController(text: store.state.cartState.userNote))));
              }
            },
          ),
        );
      } else if (response.success) {
        Navigator.push(context, MaterialPageRoute(builder: (context) => ThankYouView(orderMessage: response.message)));
        store.dispatch(SetOrderId(orderId: 0));
        store.dispatch(SetCartProducts(products: []));
        store.dispatch(SetRefund(refund: false));
        store.dispatch(SetUserNote(note: ''));
        store.dispatch(StopLoading());
      } else {
        store.dispatch(StopLoading());
        store.dispatch(CatchError(errorMessage: 'حدث خطأ يرجى إعادة المحاولة لاحقاً'));
      }
    });
  }
}

class SetOrderId {
  final int orderId;

  SetOrderId({this.orderId});
}

class SetOrderStatus {
  final int statusId;

  SetOrderStatus({this.statusId});
}

class SetRefund {
  final bool refund;

  SetRefund({this.refund});
}

class SetEditIndex {
  final int index;

  SetEditIndex({this.index});
}

class SetCartProducts {
  final List<ProductEntity> products;

  SetCartProducts({this.products});
}

class SetUserNote {
  final String note;

  SetUserNote({this.note});
}

class SetDeliveryPrice {
  final int deliveryPrice;

  SetDeliveryPrice({this.deliveryPrice});
}

class SetOrderProblem {
  final List<int> notActiveProducts;
  final List<int> pricesChangesProducts;

  SetOrderProblem({this.notActiveProducts, this.pricesChangesProducts});
}
