import 'package:kammun_app/modules/home_page/model/special_products_model.dart';
import '../../../core/core_importer.dart';

class SpecialProductsView extends StatelessWidget {
  final List<SpecialProductsModel> specialProducts;
  const SpecialProductsView({Key key, this.specialProducts}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
        converter: (store) => store.state,
        distinct: true,
        builder: (context, state) {
          return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children:
                  specialProducts.map((element) => SpecialProductsWidget(specialProductsModel: element)).toList());
        });
  }
}
