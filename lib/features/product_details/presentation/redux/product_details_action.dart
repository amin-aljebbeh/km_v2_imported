import 'package:dartz/dartz.dart';
import 'package:kammun_app/core/core_importer.dart';

abstract class ProductDetailsAction {
  handle({@required Store<AppState> store});
}

class DeleteProductAction extends ProductDetailsAction {
  final int productId;
  final BuildContext context;

  DeleteProductAction({this.productId, this.context});

  @override
  handle({Store<AppState> store}) async {
    store.dispatch(StartLoading());
    Either either =
        await store.state.productDetailsState.productDetailsUSeCases.deleteProductUseCase(productId: productId);
    either.fold(
        (failure) => snackBar(success: false, message: 'فشلت عملية حذف المنتج يرجى المحاولة مجدداً', context: context),
        (_) {
      int count = 0;
      Navigator.of(context).popUntil((_) => count++ >= 2);
      snackBar(success: true, message: 'تم حذف المنتج بنجاح', context: context);
    });
    store.dispatch(StopLoading());
  }
}

class RemoveProductFromCategoryAction extends ProductDetailsAction {
  final String productId, categoryId;
  final BuildContext context;
  final Function onRemove;

  RemoveProductFromCategoryAction({this.productId, this.context, this.categoryId, this.onRemove});

  @override
  handle({Store<AppState> store}) async {
    Navigator.of(context).pop();
    Either either = await store.state.productDetailsState.productDetailsUSeCases
        .removeProductFromCategoryUseCase(productId: productId, categoryId: categoryId);
    either.fold(
        (failure) => snackBar(
            success: false, message: 'فشلت عملية إزالة المنتج من الصنف يرجى المحاولة مجدداً', context: context), (_) {
      snackBar(success: true, message: 'تم إزالة المنتج من الصنف بنجاح', context: context);
      onRemove();
    });
  }
}

class DeleteImageAction extends ProductDetailsAction {
  final int imageId;
  final BuildContext context;

  DeleteImageAction({this.imageId, this.context});

  @override
  handle({Store<AppState> store}) async {
    store.dispatch(StartLoading());
    Either either = await store.state.productDetailsState.productDetailsUSeCases.deleteImageUseCase(imageId: imageId);
    either.fold(
        (failure) =>
            snackBar(success: false, message: 'فشلت عملية حذف صورة المنتج يرجى المحاولة مجدداً', context: context),
        (_) => snackBar(success: true, message: 'تم حذف صورة المنتج بنجاح', context: context));
    store.dispatch(StopLoading());
  }
}
