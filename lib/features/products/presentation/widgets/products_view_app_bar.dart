import '../../../../core/core_importer.dart';
import '../../../home/presentation/redux/home_action.dart';
import '../redux/products_action.dart';

class ProductsViewAppBar extends StatelessWidget with PreferredSizeWidget {
  const ProductsViewAppBar({Key key, this.scaffoldKey, this.searchController, this.onSubmit}) : super(key: key);
  final GlobalKey<ScaffoldState> scaffoldKey;
  final TextEditingController searchController;
  final Function onSubmit;
  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      child: AppBar(
        backgroundColor: const Color.fromARGB(255, 210, 178, 2),
        automaticallyImplyLeading: false, // hides leading widget
        flexibleSpace: SafeArea(
          top: true,
          left: false,
          bottom: false,
          right: false,
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
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
                  const AppBarKammunImage(),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: InkWell(
                      onTap: () {
                        StoreProvider.of<AppState>(context).dispatch(InitProducts());
                        Navigator.of(context).pop(true);
                      },
                      child: const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 40),
                    ),
                  ),
                ],
              ),
              StoreSearchTextField(
                  scaffoldKey: scaffoldKey, searchController: searchController, onSubmit: () => onSubmit()),
            ],
          ),
        ),
      ),
      preferredSize: const Size.fromHeight(105.0),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(105.0);
}
