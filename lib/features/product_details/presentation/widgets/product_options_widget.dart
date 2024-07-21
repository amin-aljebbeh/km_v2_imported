import 'package:kammun_app/features/barcode/presentation/redux/barcode_action.dart';
import 'package:kammun_app/features/products/domain/entities/product_entity.dart';

import '../../../../core/core_importer.dart';
import '../../../products_view/services/products_services.dart';

class ProductOptionsWidget extends StatelessWidget {
  final ProductEntity product;
  final GlobalKey<ScaffoldState> scaffoldKey;
  final Function(String) onAddBarcode;

  const ProductOptionsWidget({Key key, this.product, this.scaffoldKey, this.onAddBarcode}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        if (Services.hasRole(context, productsControllerRole))
          Row(
            children: [
              BarcodeIcon(
                product: product,
                color: kmColors,
                requestType: BarcodeRequestType.addBarcode,
                productId: product.productId,
                scaffoldKey: scaffoldKey,
                onAddBarcode: (result) => onAddBarcode(result),
              ),
              IconButton(
                icon: Icon(Icons.list, size: 30, color: kmColors2),
                onPressed: () {
                  showMyDialog(
                    context: context,
                    title: 'باركود',
                    content: Column(
                      children: product.barcodes
                          .map(
                            (barcode) => GestureDetector(
                              child: Column(
                                children: [
                                  const Divider(color: Colors.black, thickness: 1),
                                  Text(barcode.barcode, style: decisionButtonStyle.copyWith(color: Colors.black)),
                                  const Divider(color: Colors.black, thickness: 1),
                                ],
                              ),
                              onTap: () {
                                Navigator.of(context).pop();
                                showMyDialog(
                                  context: context,
                                  title: 'إزالة باركود',
                                  dialogButtons: [
                                    DialogButton(
                                      text: yes,
                                      onTap: () {
                                        StoreProvider.of<AppState>(context).dispatch(DeleteBarcodeAction(
                                            context: context,
                                            onDelete: () => product.barcodes.removeWhere(
                                                (barcodeToDelete) => barcodeToDelete.barcode == barcode.barcode),
                                            barcodeId: product.barcodes
                                                .firstWhere(
                                                    (barcodeToDelete) => barcodeToDelete.barcode == barcode.barcode)
                                                .id));
                                      },
                                    ),
                                    DialogButton(text: no, onTap: () => Navigator.of(context).pop()),
                                  ],
                                  text: 'هل أنت متأكد أنك ترغب في إزالة الباركود للمنتج ؟',
                                );
                              },
                            ),
                          )
                          .toList(),
                    ),
                    dialogButtons: [const CloseWidget()],
                  );
                },
              ),
            ],
          ),
        if (Services.hasRole(context, productsControllerRole))
          PrimeProductWidget(product: ProductEntity(productId: product.productId, isPrimeItem: product.isPrimeItem)),
        AddImageWidget(
          onSubmit: (image) async {
            bool result = await ProductsServices.setImageToProducts(productId: product.productId, image: image);
            if (result) {
              snackBar(success: result, message: 'تم حفظ صورة المنتج بنجاح', context: context);
            } else {
              snackBar(success: result, message: 'فشلت عملية حفظ صورة المنتج يرجى المحاولة مجدداً', context: context);
            }
          },
        )
      ],
    );
  }
}
