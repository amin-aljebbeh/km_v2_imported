import 'package:dartz/dartz.dart';
import 'package:kammun_app/core/core_importer.dart';
import 'package:kammun_app/features/search_orders/domain/entities/get_order_response_entity.dart';

import '../../../order_details/presentation/pages/invoice_view.dart';
import '../../../orders/domain/entities/show_data_entity.dart';
import '../../../orders/orders_services.dart';

abstract class OrderDetailsAction {
  handle({@required Store<AppState> store});
}

class GetOrderInvoice extends OrderDetailsAction {
  final int orderId;
  final BuildContext context;

  GetOrderInvoice({this.orderId, this.context});

  @override
  handle({Store<AppState> store}) async {
    store.dispatch(StartLoading());
    Either either = await store.state.searchOrdersState.searchOrdersUSeCases
        .getOrderUseCase(cancelToken: OrdersServices.cancelRequest, orderId: orderId);
    either.fold((failure) => store.dispatch(CatchError(errorMessage: 'حدث خطأ، يرجى المحاولة مجدداً')), (response) {
      GetOrderResponseEntity order = response;
      store.dispatch(SetOrderInvoice(invoice: order.showData));
      Navigator.push(context, MaterialPageRoute(builder: (context) => const InvoiceView()));
    });
    store.dispatch(StopLoading());
  }
}

class SetOrderInvoice {
  final ShowDataEntity invoice;

  SetOrderInvoice({this.invoice});
}

class AddImageToOrderAction extends OrderDetailsAction {
  final int orderId;
  final File image;
  final BuildContext context;

  AddImageToOrderAction({this.context, this.orderId, this.image});

  @override
  handle({Store<AppState> store}) async {
    store.dispatch(StartLoading());
    Either either =
        await store.state.orderDetailsState.orderDetailsUseCases.addImageToOrderUseCase(image: image, orderId: orderId);
    either.fold((failure) => snackBar(success: false, message: 'فشلت عملية إضافة الصورة', context: context),
        (_) => snackBar(success: true, message: 'نجحت عملية إضافة الصورة', context: context));
    store.dispatch(StopLoading());
  }
}

class DeleteImageFromOrderAction extends OrderDetailsAction {
  final int imageId;
  final BuildContext context;
  final Function onDelete;

  DeleteImageFromOrderAction({this.context, this.imageId, this.onDelete});

  @override
  handle({Store<AppState> store}) async {
    store.dispatch(StartLoading());
    Either either =
        await store.state.orderDetailsState.orderDetailsUseCases.deleteImageFromOrderUseCase(imageId: imageId);
    either.fold((failure) => snackBar(success: false, message: 'فشلت عملية حذف الصورة', context: context), (_) {
      snackBar(success: true, message: 'تم حذف الصورة من الطلب', context: context);
      onDelete();
    });
    store.dispatch(StopLoading());
  }
}

class UpdateOrderProductAction extends OrderDetailsAction {
  final int orderId, productId;
  final BuildContext context;
  final String updateKey, updateValue;

  UpdateOrderProductAction({this.orderId, this.productId, this.updateKey, this.updateValue, this.context});

  @override
  handle({Store<AppState> store}) async {
    store.dispatch(StartLoading());
    Either either = await store.state.orderDetailsState.orderDetailsUseCases.updateOrderProductUseCase(
        orderId: orderId, updateKey: updateKey, updateValue: updateValue, productId: productId);
    either.fold(
        (failure) => snackBar(success: false, message: 'فشلت عملية تعديل الطلب يرجى المحاولة مجدداً', context: context),
        (_) => snackBar(success: true, message: 'نجحت عملية تعديل الطلب', context: context));
    store.dispatch(StopLoading());
  }
}
