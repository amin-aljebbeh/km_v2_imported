import '../../../../core/core_importer.dart';
import '../../../products/domain/entities/product_entity.dart';
import '../../../products_attached_to_warehouse/services/added_products_services.dart';

class RemoveFromWarehouse extends StatelessWidget {
  final ProductEntity product;
  const RemoveFromWarehouse({Key key, this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: KammunButton(
        height: 50,
        text: 'إزالة من المستودع',
        color: Colors.red,
        onTap: () {
          List<DialogButton> dialogButtons = [
            DialogButton(
              text: yes,
              onTap: () async {
                Navigator.of(context).pop();
                bool result = await AddedProductsServices.unAttachProductsToSubWarehouseService(
                    productsId: product.id.toString(), subWarehouse: product.subWarehouseId.toString());
                if (result) {
                  int count = 0;
                  Navigator.of(context).popUntil((_) => count++ >= 1);
                  snackBar(success: result, message: 'تم إزالة المنتج من المستودع بنجاح', context: context);
                } else {
                  snackBar(
                      success: result,
                      message: 'فشلت عملية إزالة المنتج من المستودع يرجى المحاولة مجدداً',
                      context: context);
                }
              },
            ),
            DialogButton(text: no, onTap: () => Navigator.of(context).pop()),
          ];
          showMyDialog(
              context: context,
              title: '',
              text: 'هل تريد إزالة ${product.name} من المستودع ؟',
              dialogButtons: dialogButtons);
        },
      ),
    );
  }
}
