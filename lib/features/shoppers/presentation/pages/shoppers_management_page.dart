import '../../../../core/core_importer.dart';

class ShopperManagementPage extends StatefulWidget {
  const ShopperManagementPage({Key key}) : super(key: key);

  @override
  _ShopperManagementPageState createState() => _ShopperManagementPageState();
}

class _ShopperManagementPageState extends State<ShopperManagementPage> {
  bool loading;

  loadShopper() async {
    await GeneralApis.getShoppers(context: context);
    setState(() => loading = false);
  }

  @override
  void initState() {
    loading = true;
    loadShopper();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      distinct: true,
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(backgroundColor: primaryColor, title: Text('فريق التوصيل', style: appBarStyle)),
          body: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: loading
                ? const Loader()
                : ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
                    primary: false,
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: state.shoppersState.shoppers == null ? 0 : state.shoppersState.shoppers.length,
                    itemBuilder: (BuildContext context, int index) =>
                        ShopperWidget(shopper: state.shoppersState.shoppers[index]),
                  ),
          ),
        );
      },
    );
  }
}
