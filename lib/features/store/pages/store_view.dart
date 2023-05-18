import 'package:kammun_app/features/store/widgets/store_view_category_grid.dart';

import '../../../core/core_importer.dart';
import '../widgets/categories_title.dart';
import '../widgets/image_carousel.dart';
import '../widgets/show_update_dialog.dart';
import '../widgets/store_app_bar.dart';

class StoreView extends StatefulWidget {
  static const String routeName = '/StoreView';
  const StoreView({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => StoreViewState();
}

class StoreViewState extends State<StoreView> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    if (StaticVariables.updateOption) {
      WidgetsBinding.instance.addPostFrameCallback((_) => showUpdateDialog(context: context));
    }
  }

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
