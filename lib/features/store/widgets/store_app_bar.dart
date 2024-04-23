import 'package:location/location.dart';

import '../../../core/core_importer.dart';
import '../../home/presentation/redux/home_action.dart';
import 'location_permission.dart';

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
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      distinct: true,
      builder: (context, state) {
        return PreferredSize(
          child: AppBar(
            iconTheme: const IconThemeData(color: Colors.transparent),
            backgroundColor: Services.hasRole(context, shopperRole)
                ? state.shoppersState.shopper.status == 1
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
                      Services.hasRole(context, shopperRole)
                          ? Switch(
                              activeColor: Colors.white,
                              value: state.shoppersState.shopper.status == 1,
                              onChanged: (value) async {
                                if (state.shoppersState.shopper.status == 0) {
                                  await locationPermission(
                                      context: context,
                                      onGrant: () {
                                        Location location = Location();
                                        location.getLocation().then((locationValue) async {
                                          changeStatus(
                                                  location: locationValue,
                                                  newStatus: state.shoppersState.shopper.status == 1 ? '0' : '1',
                                                  shopperId: state.shoppersState.shopper.id.toString())
                                              .then((success) {
                                            if (success) {
                                              setState(() => state.shoppersState.shopper.status = value ? 1 : 0);
                                            }
                                          });
                                        });
                                      });
                                } else {
                                  changeStatus(
                                          location: LocationData.fromMap({}),
                                          newStatus: state.shoppersState.shopper.status == 1 ? '0' : '1',
                                          shopperId: state.shoppersState.shopper.id.toString())
                                      .then((success) {
                                    if (success) {
                                      setState(() => state.shoppersState.shopper.status = value ? 1 : 0);
                                    }
                                  });
                                }
                              },
                            )
                          : Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: IconButton(
                                icon: const Icon(Icons.shopping_cart, size: 35, color: Colors.white),
                                onPressed: () {
                                  StoreProvider.of<AppState>(context).dispatch(SetPageIndex(index: 1));

                                  Navigator.of(context)
                                      .pushNamedAndRemoveUntil(HomePage.routeName, (Route<dynamic> route) => false);
                                },
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
      },
    );
  }

  Future<bool> changeStatus({String shopperId, String newStatus, LocationData location}) async {
    Map<int, String> success = await GeneralApis.changeShopperStatusService(
        shopperId: shopperId, lat: location.latitude, lon: location.longitude, newStatus: newStatus);
    switch (success.keys.first) {
      case successCode:
        return true;
        break;
      case forbiddenError:
        snackBar(message: success.values.first, context: context, success: false);
        return false;
        break;
      case 422:
        snackBar(message: 'الموقع غير صحيح يرجى المحاولة مرة أخرى', context: context, success: false);
        return false;
        break;
      default:
        snackBar(message: 'يرجى الاتصال بالإنترنت والمحاولة مرة أخرى', context: context, success: false);
        return false;
        break;
    }
  }
}
