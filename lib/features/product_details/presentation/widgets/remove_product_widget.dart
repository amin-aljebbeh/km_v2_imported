import 'package:kammun_app/features/product_details/presentation/redux/product_details_action.dart';

import '../../../../core/core_importer.dart';
import '../../../products/domain/entities/product_entity.dart';
import 'remove_from_warehouse.dart';

class RemoveProductWidget extends StatelessWidget {
  final ProductEntity product;
  const RemoveProductWidget({Key key, this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      distinct: true,
      builder: (context, state) {
        return Column(
          children: [
            if (state.generalInformationState.subWarehouses.any((element) => element.id == product.subWarehouseId))
              RemoveFromWarehouse(product: product),
            KammunButton(
              height: 50,
              text: 'حذف المنتج',
              color: Colors.red,
              onTap: () {
                List<DialogButton> dialogButtons = [
                  DialogButton(
                    text: yes,
                    onTap: () {
                      StoreProvider.of<AppState>(context)
                          .dispatch(DeleteProductAction(productId: product.productId, context: context));
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
      },
    );
  }
}
