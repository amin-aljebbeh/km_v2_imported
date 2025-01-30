import 'package:kammun_app/features/store/widgets/store_view_category_grid.dart';

import '../../../core/core_importer.dart';
import '../../home/presentation/widgets/special_products_view.dart';
import '../widgets/categories_title.dart';
import '../widgets/k_banner.dart';
import '../widgets/store_app_bar.dart';

class StoreView extends StatelessWidget {
  StoreView({Key key}) : super(key: key);

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      builder: (context, state) {
        return Scaffold(
          key: scaffoldKey,
          backgroundColor: Colors.white,
          drawer: const KDrawer(),
          appBar: StoreAppBar(scaffoldKey: scaffoldKey),
          body: SafeArea(
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const KBanner(),
                  !Services.hasRole(context, shopperRole)
                      ? state.homeState.loading
                          ? SizedBox(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height / 4,
                              child: const Center(child: Loader()))
                          : state.homeState.specialProducts.isNotEmpty
                              ? const SpecialProductsView()
                              : Container()
                      : Container(),
                  const CategoriesTitle(),
                  const StoreViewCategory()
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
