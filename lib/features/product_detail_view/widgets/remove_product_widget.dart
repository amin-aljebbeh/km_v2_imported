import '../../../core/core_importer.dart';
import '../../products/domain/entities/product_entity.dart';
import '../../products_view/services/products_services.dart';
import 'remove_from_warehouse.dart';

class RemoveProductWidget extends StatelessWidget {
  final ProductEntity product;
  const RemoveProductWidget({Key key, this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (StaticVariables.subWarehouses.any((element) => element.id == product.subWarehouseId))
          RemoveFromWarehouse(product: product),
        KammunButton(
          height: 50,
          text: 'حذف المنتج',
          color: Colors.red,
          onTap: () {
            List<DialogButton> dialogButtons = [
              DialogButton(
                text: yes,
                onTap: () async {
                  bool result = await ProductsServices.deleteProductService(product.id.toString());
                  if (result) {
                    int count = 0;
                    Navigator.of(context).popUntil((_) => count++ >= 2);
                    snackBar(success: result, message: 'تم حذف المنتج بنجاح', context: context);
                  } else {
                    snackBar(success: result, message: 'فشلت عملية حذف المنتج يرجى المحاولة مجدداً', context: context);
                  }
                },
              ),
              DialogButton(text: no, onTap: () => Navigator.of(context).pop()),
            ];
            showMyDialog(
                context: context,
                title: '',
                text: 'هل تريد حذف ${product.name} نهائياً ؟',
                dialogButtons: dialogButtons);
          },
        ),
      ],
    );
  }
}
