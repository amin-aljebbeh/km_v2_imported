import 'package:kammun_app/features/store/widgets/store_view_category_grid.dart';

import '../../../core/core_importer.dart';
import '../widgets/categories_title.dart';
import '../widgets/image_carousel.dart';
import '../widgets/store_app_bar.dart';

class StoreView extends StatelessWidget {
  static const String routeName = '/StoreView';
  StoreView({Key key}) : super(key: key);

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
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
            children: const <Widget>[ImageCarousel(), CategoriesTitle(), StoreViewCategory()],
          ),
        ),
      ),
    );
  }
}
