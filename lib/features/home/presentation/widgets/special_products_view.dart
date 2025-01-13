
import 'package:kammun_app/features/home/presentation/widgets/special_products_widget.dart';

import '../../../../core/core_importer.dart';

class SpecialProductsView extends StatelessWidget {
  const SpecialProductsView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
        converter: (store) => store.state,
        distinct: true,
        builder: (context, state) {
          return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children:
                  state.homeState.specialProducts.map((element) => SpecialProductsWidget(specialProductsModel: element)).toList());
        });
  }
}
