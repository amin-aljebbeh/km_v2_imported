import 'package:kammun_app/features/store/drawer_children.dart';
import 'package:kammun_app/features/store/store_view_category_grid.dart';

import '../../core/core_importer.dart';
import 'categories_title.dart';
import 'image_carousel.dart';
import 'show_update_dialog.dart';
import 'store_app_bar.dart';

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
    if (Services.updateOption) WidgetsBinding.instance.addPostFrameCallback((_) => showUpdateDialog(context: context));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      drawer: KDrawer(children: getDrawerChildren(context)),
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
