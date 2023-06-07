import '../../../core/core_importer.dart';
import '../pages/add_products.dart';
import '../pages/barcode_screen.dart';

class AddProductWidget extends StatelessWidget {
  const AddProductWidget({Key key, this.scaffoldKey, this.categoryId}) : super(key: key);
  final GlobalKey<ScaffoldState> scaffoldKey;
  final int categoryId;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: kmColors2,
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BarCodeScreen(
              requestType: BarcodeRequestType.addProduct,
              onIgnore: (barcode) {
                int param;
                if (barcode == null) {
                  param = null;
                } else {
                  param = int.parse(barcode);
                }
                Navigator.push(
                  scaffoldKey.currentContext,
                  MaterialPageRoute(
                      builder: (screenContext) => AddProductsView(categoryId: categoryId, barcode: param)),
                );
              },
            ),
          ),
        );
      },
      tooltip: 'إضافة منتج',
      child: const Icon(Icons.add),
    );
  }
}
