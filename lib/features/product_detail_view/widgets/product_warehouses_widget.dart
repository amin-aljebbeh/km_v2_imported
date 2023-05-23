import '../../../core/core_importer.dart';

class ProductWarehousesWidget extends StatelessWidget {
  final List<Warehouse> warehouses;
  const ProductWarehousesWidget({Key key, this.warehouses}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: SizedBox(
        height: 74,
        child: ListView.builder(
          itemCount: warehouses.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (BuildContext context, int index) {
            return SizedBox(
              width: MediaQuery.of(context).size.width * 0.45,
              child: ShopByCategory(
                  img: 'null', categoryName: warehouses[index].name, index: index + 100, fit: BoxFit.contain),
            );
          },
        ),
      ),
    );
  }
}
