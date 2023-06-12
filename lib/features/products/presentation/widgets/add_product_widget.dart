import '../../../../core/core_importer.dart';
import '../../../barcode/presentation/pages/barcode_scanner_page.dart';
import '../../../barcode/presentation/redux/barcode_action.dart';
import '../../../products_view/pages/add_products.dart';

class AddProductWidget extends StatelessWidget {
  const AddProductWidget({Key key, this.scaffoldKey, this.categoryId}) : super(key: key);
  final GlobalKey<ScaffoldState> scaffoldKey;
  final int categoryId;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: kmColors2,
      onPressed: () {
        StoreProvider.of<AppState>(context).dispatch(SetBarcodeType(barcodeRequestType: BarcodeRequestType.addProduct));
        StoreProvider.of<AppState>(context).dispatch(SetonIgnore(
          onIgnore: (barcode) {
            int param;
            if (barcode == null) {
              param = null;
            } else {
              param = int.parse(barcode);
            }
            Navigator.push(
              scaffoldKey.currentContext,
              MaterialPageRoute(builder: (screenContext) => AddProductsView(categoryId: categoryId, barcode: param)),
            );
          },
        ));
        Navigator.push(context, MaterialPageRoute(builder: (context) => const BarcodeScannerPage()));
      },
      tooltip: 'إضافة منتج',
      child: const Icon(Icons.add),
    );
  }
}
