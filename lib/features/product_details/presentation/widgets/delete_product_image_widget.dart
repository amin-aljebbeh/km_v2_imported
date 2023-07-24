import '../../../../core/core_importer.dart';
import '../../../products/domain/entities/product_entity.dart';
import '../redux/product_details_action.dart';

class DeleteProductImageWidget extends StatelessWidget {
  final ProductEntity product;
  final Future<bool> Function() onAdd;
  final Function onDone;

  const DeleteProductImageWidget({Key key, this.product, this.onAdd, this.onDone}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (product.images.isNotEmpty)
          KammunButton(
            height: 50,
            color: Theme.of(context).primaryColor,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text('حذف الصورة', overflow: TextOverflow.clip, style: decisionButtonStyle),
                const Icon(Icons.delete, color: Colors.white, size: 30),
              ],
            ),
            onTap: () async {
              if (product.images.isNotEmpty) {
                showMyDialog(
                    context: context,
                    title: 'حذف صورة',
                    text: 'هل أنت متأكد من رغبتك في حذف صورة المنتج ؟',
                    dialogButtons: [
                      const CloseWidget(),
                      DialogButton(
                        text: yes,
                        onTap: () async {
                          Navigator.of(context).pop();
                          StoreProvider.of<AppState>(context)
                              .dispatch(DeleteImageAction(context: context, imageId: product.images[0].id));
                          product.images.removeAt(0);
                        },
                      )
                    ]);
              }
            },
          ),
        KammunButton(
          height: 50,
          text: 'الإضافة لصنف جديد',
          color: Theme.of(context).primaryColor,
          onTap: () async {
            bool result = await onAdd();
            if (result) {
              onDone();
            }
            snackBar(
                success: result,
                context: context,
                message: result ? 'تم إضاقة المنتج للصنف بنجاح' : 'فشلت عملية إضاقة المنتج للصنف يرجى المحاولة مجدداً');
          },
        ),
      ],
    );
  }
}
