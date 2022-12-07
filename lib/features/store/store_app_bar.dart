import '../../core/core_importer.dart';

class StoreAppBar extends StatefulWidget with PreferredSizeWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  const StoreAppBar({Key key, this.scaffoldKey}) : super(key: key);

  @override
  _StoreAppBarState createState() => _StoreAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(105.0);
}

class _StoreAppBarState extends State<StoreAppBar> {
  TextEditingController searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      child: AppBar(
        iconTheme: const IconThemeData(color: Colors.transparent),
        backgroundColor: Services.isShopper()
            ? Services.shopper.status == 1
                ? kmColors
                : searchGreyColor
            : kmColors,
        automaticallyImplyLeading: false,
        flexibleSpace: SafeArea(
          top: true,
          left: false,
          bottom: false,
          right: false,
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 12.0),
                    child: InkWell(
                        onTap: () => widget.scaffoldKey.currentState.openDrawer(),
                        child: const Icon(Icons.menu_rounded, color: Colors.white, size: 40)),
                  ),
                  const AppBarKammunImage(),
                  Services.isShopper()
                      ? Switch(
                          activeColor: Colors.white,
                          value: Services.shopper.status == 1,
                          onChanged: (value) async {
                            bool success = await Services.changeShopperStatusService(
                                shopperId: Services.shopper.id.toString(),
                                newStatus: Services.shopper.status == 1 ? '0' : '1');
                            if (success) {
                              setState(() => Services.shopper.status = Services.shopper.status == 1 ? 0 : 1);
                            } else {
                              Toast.show('يرجى الاتصال بالإنترنت', context,
                                  duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
                            }
                          },
                        )
                      : Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: IconButton(
                            icon: const Icon(Icons.shopping_cart, size: 35, color: Colors.white),
                            onPressed: () => Navigator.of(context)
                                .pushNamedAndRemoveUntil(CartView.routeName, (Route<dynamic> route) => false),
                          ),
                        ),
                ],
              ),
              StoreSearchTextField(searchController: searchController, scaffoldKey: widget.scaffoldKey),
            ],
          ),
        ),
      ),
      preferredSize: const Size.fromHeight(105.0),
    );
  }
}
