import 'package:kammun_app/features/shoppers/domain/entities/shopper_entity.dart';

import '../../../../core/core_importer.dart';

class ShopperManagementPage extends StatefulWidget {
  const ShopperManagementPage({Key key}) : super(key: key);

  @override
  _ShopperManagementPageState createState() => _ShopperManagementPageState();
}

class _ShopperManagementPageState extends State<ShopperManagementPage> {
  bool loading;
  String searchTerm ='' ;

    StreamController<String> _searchController;

  loadShopper() async {
    await GeneralApis.getShoppers(context: context);
    setState(() => loading = false);
  }

  @override
  void initState() {
    loading = true;
    loadShopper();


    _searchController = StreamController<String>();
    _searchController.stream.listen((term) {
      searchTerm = term;
      setState(() {
        print(term);
      });

    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();

    // Dispose of the stream controller
    _searchController.close();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      distinct: true,
      builder: (context, state) {
        return Scaffold(
          appBar:AppBar(
            toolbarHeight: 85,
            backgroundColor: primaryColor,
            automaticallyImplyLeading: false, // hides leading widget
            flexibleSpace: SafeArea(
              top: true,
              left: false,
              bottom: false,
              right: false,
              child: Column(
                children: <Widget>[
                   Padding(
                     padding: const EdgeInsets.all(8.0),
                     child: Text('فريق التوصيل ',style: appBarStyle),
                   ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 5,),
                    child: Container(
                      height: 40.0,
                      decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(6.0))),
                      child: TextField(
                        // controller: searchController,
                        // onSubmitted: (_) => submit(context),
                        cursorColor: primaryColor,
                        onChanged: (term) {
                          _searchController.add(term);
                        },
                        decoration: InputDecoration(
                          prefixIcon: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.30,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(icon: Icon(Icons.search, color: primaryColor), onPressed: () {}),
                              ],
                            ),
                          ),
                          border: UnderlineInputBorder(borderSide: BorderSide(color: kmColors)),
                          focusedBorder:
                          OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide(color: kmColors)),
                          enabledBorder:
                          OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide(color: kmColors)),
                          disabledBorder:
                          OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide(color: kmColors)),
                          contentPadding: const EdgeInsets.only(bottom: 0.5),
                          hintText: 'ابحث عن عامل توصيل',
                          hintStyle: mainStyle,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          body: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: loading
                ? const Loader()
                : ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
              primary: false,
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: state.shoppersState.shoppers == null ? 0 : filterShoppers(state.shoppersState.shoppers).length,
              itemBuilder: (BuildContext context, index) {
                final shopper = filterShoppers(state.shoppersState.shoppers)[index];
                return ShopperWidget(shopper: shopper);
              },
            ),
          ),
        );
      },
    );
  }

  List<ShopperEntity> filterShoppers(List<ShopperEntity> shoppers) {
    List<ShopperEntity> filteredShoppers = shoppers
        .where((shopper) => shopper.name.toLowerCase().contains(searchTerm.toLowerCase()))
        .toList();
    return filteredShoppers;
  }
}
