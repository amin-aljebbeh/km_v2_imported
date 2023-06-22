import 'package:dartz/dartz.dart';

import '../../../../core/core_importer.dart';
import 'barcode_state.dart';

abstract class BarcodeAction {
  handle({@required Store<AppState> store, BarcodeState state});
}

class DeleteBarcodeAction extends BarcodeAction {
  final String barcodeId;
  final BuildContext context;
  final Function onDelete;

  DeleteBarcodeAction({this.context, this.barcodeId, this.onDelete});

  @override
  handle({Store<AppState> store, BarcodeState state}) async {
    Either either = await state.barcodeUseCases.deleteBarcodeUseCase(barcodeId: barcodeId);
    Navigator.of(context).pop();
    either.fold(
        (failure) => snackBar(success: false, message: 'فشلت عملية حذف الرمز يرجى المحاولة مجدداً', context: context),
        (barcode) {
      snackBar(success: true, message: 'تم حذف الرمز بنجاح', context: context);
      onDelete();
    });
  }
}

class SetBarcodeToProductAction extends BarcodeAction {
  final int barcode, productId;
  final BuildContext context;
  final Function(String) onSuccess;

  SetBarcodeToProductAction({this.context, this.barcode, this.productId, this.onSuccess});

  @override
  handle({Store<AppState> store, BarcodeState state}) async {
    Either either = await state.barcodeUseCases.setBarcodeToProductUseCase(productId: productId, barcode: barcode);
    either.fold(
        (failure) => snackBar(success: false, message: 'فشلت عملية إرسال الرمز يرجى المحاولة مجدداً', context: context),
        (barcode) {
      snackBar(success: true, message: 'تم إرسال الرمز بنجاح', context: context);
      onSuccess(barcode);
    });
  }
}

class SetBarcodeType {
  final BarcodeRequestType barcodeRequestType;

  SetBarcodeType({this.barcodeRequestType});
}

class SetBarcodeString {
  final String barcodeString;

  SetBarcodeString({this.barcodeString});
}

class SetonIgnore {
  final Function(String) onIgnore;

  SetonIgnore({this.onIgnore});
}
