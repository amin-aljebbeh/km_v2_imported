import 'package:kammun_app/features/inventory/presentation/redux/inventory_action.dart';

import '../../../../core/core_importer.dart';
import '../../../products/domain/entities/product_entity.dart';

class InventoryFloatingActionButton extends StatelessWidget {
  const InventoryFloatingActionButton({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      distinct: true,
      builder: (context, state) {
        List<ProductEntity> products = [];
        var inventoryState = state.inventoryState;
        products.addAll(inventoryState.products
            .where((product) => ![InventoryTypes.notAdded, InventoryTypes.all].contains(inventoryState.inventoryType)));
        products
            .addAll(inventoryState.allProducts.where((product) => InventoryTypes.all == inventoryState.inventoryType));
        products.addAll(inventoryState.notAddedProducts
            .where((product) => InventoryTypes.notAdded == inventoryState.inventoryType));
        return inventoryState.inventoryType == InventoryTypes.prices
            ? FloatingActionButton(
                onPressed: () {},
                backgroundColor: primaryColor,
                child: Text(products.length.toString(), style: mainStyle.copyWith(fontSize: 20)),
              )
            : inventoryState.inventoryType == InventoryTypes.subWarehouse
                ? FloatingActionButton(
                    backgroundColor: primaryColor,
                    onPressed: () =>
                        StoreProvider.of<AppState>(context).dispatch(ChangeSubWarehouseFilter(context: context)),
                    child: const Icon(Icons.filter_list_rounded, size: 35))
                : const SizedBox();
      },
    );
  }
}
