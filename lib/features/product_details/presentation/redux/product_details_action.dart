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
