import '../../../../core/core_importer.dart';
import '../../../products/domain/entities/product_entity.dart';

class ProductCheckWidget extends StatelessWidget {
  final Function onCheckbox;
  final ProductEntity product;

  const ProductCheckWidget({Key key, @required this.onCheckbox, @required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (Services.hasRole(context, operationManagerRole) || product.pivot.deletedAt != 'null')
          Column(
            children: [
              PrimeProductWidget(product: product),
              RotatedBox(
                quarterTurns: 1,
                child: SwitchProductStatusWidget(
                  // product: product,
                  isForSubWarehouse: true,
                  height: 20,
                  width: 65,
                  preState: int.parse(product.isActive),
                  subWarehouseId: product.subWarehouseId,
                  productId: product.pivot.productId,
                  onChange: (int active, bool result) {
                    if (result) product.isActive = active.toString();
                  },
                ),
              ),
            ],
          ),
        Column(
          children: [
            Container(
              padding: const EdgeInsets.all(3.0),
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                  border: Border.all(color: primaryColor, width: 2)),
              child: Center(child: Text(product.pivot.quantity, style: mainStyle.copyWith(fontSize: 30))),
            ),
            IconButton(
                icon: const Icon(Icons.library_add_check_outlined, color: Colors.green),
                onPressed: () {
                  if (product.pivot.quantity != '1') {
                    List<DialogButton> decisionButtons = [
                      DialogButton(
                        text: 'نعم',
                        onTap: () {
                          Navigator.of(context).pop();
                          onCheckbox();
                        },
                      ),
                      DialogButton(text: 'لا', onTap: () => Navigator.of(context).pop()),
                    ];
                    showMyDialog(
                        context: context,
                        title: 'تحقق من الكمية',
                        text: 'هل أنت متأكد انك وجدت ${product.pivot.quantity} قطعة من ${product.name}',
                        dialogButtons: decisionButtons);
                  } else {
                    onCheckbox();
                  }
                }),
          ],
        ),
      ],
    );
  }
}
