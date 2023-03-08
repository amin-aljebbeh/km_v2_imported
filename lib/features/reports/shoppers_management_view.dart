import '../../core/core_importer.dart';

class ShopperManagementView extends StatefulWidget {
  static const String routeName = '/ShopperManagementView';
  const ShopperManagementView({Key key}) : super(key: key);

  @override
  _ShopperManagementViewState createState() => _ShopperManagementViewState();
}

class _ShopperManagementViewState extends State<ShopperManagementView> {
  bool loading;

  loadShopper() async {
    await GeneralApis.getShoppers();
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
                itemCount: StaticVariables.allShoppers == null ? 0 : StaticVariables.allShoppers.length,
                itemBuilder: (BuildContext context, int index) =>
                    ShopperWidget(shopper: StaticVariables.allShoppers[index]),
              ),
      ),
    );
  }
}
