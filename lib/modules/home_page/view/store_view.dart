import 'package:flutter/material.dart';
import 'package:kammun_app/modules/products/redux/products_action.dart';
import '../../../core/core_importer.dart';
import '../redux/home_page_action.dart';

class StoreView extends StatefulWidget {
  static String routeName = '/StoreView';

  const StoreView({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => StoreViewState();
}

class StoreViewState extends State<StoreView> {
  TextEditingController searchController = TextEditingController();
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      StoreProvider.of<AppState>(context).dispatch(FirstProductPage());
      StoreProvider.of<AppState>(context).dispatch(GetSpecialProducts(
          specialProduct: StoreProvider.of<AppState>(context).state.startupState.startModel.specialProduct));
    });
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      builder: (context, state) {
        return Scaffold(
          key: scaffoldKey,
          backgroundColor: Colors.white,
          drawer: const KDrawer(),
          appBar: KAppBar(isFromStore: true, scaffoldKey: scaffoldKey, searchController: searchController),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                      padding: const EdgeInsets.only(left: 2, right: 2, top: 10),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [ChooseAddressWidget(), KBanner()])),
                  state.homePageState.loading
                      ? SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height / 4,
                          child: const Center(child: Loader()))
                      : state.homePageState.specialProducts.isNotEmpty
                          ? SpecialProductsView(specialProducts: state.homePageState.specialProducts)
                          : Container(),
                  const CategoryTitle(),
                  const StoreViewCategory(),
                  const EndOfPageWidget(),
                ],
              ),
              physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
            ),
          ),
        );
      },
    );
  }
}
