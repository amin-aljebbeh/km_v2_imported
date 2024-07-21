import '../../../../core/core_importer.dart';
import '../../../general_information/domain/entities/warehouse_entity.dart';

class ProductWarehousesWidget extends StatelessWidget {
  final List<WarehouseEntity> warehouses;

  const ProductWarehousesWidget({Key key, this.warehouses}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<WarehouseEntity> sortedWarehouses = List.from(warehouses);

    sortedWarehouses.sort((a, b) {
      const List<int> specialOrder = [1, 10, 8, 9];
      int indexA = specialOrder.indexOf(a.id);
      int indexB = specialOrder.indexOf(b.id);

      if (indexA != -1 && indexB != -1) {
        return indexA.compareTo(indexB);
      } else if (indexA != -1) {
        return -1; // a is in the special order, b is not
      } else if (indexB != -1) {
        return 1; // b is in the special order, a is not
      } else {
        return a.id.compareTo(b.id); // natural order for the rest
      }
    });

    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: SizedBox(
        height: 74,
        child: ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
          itemCount: sortedWarehouses.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (BuildContext context, int index) {
            return SizedBox(
              width: MediaQuery.of(context).size.width * 0.45,
              child: ShopByCategory(
                  img: 'null', categoryName: sortedWarehouses[index].name, index: index + 100, fit: BoxFit.contain),
            );
          },
        ),
      ),
    );
  }
}
