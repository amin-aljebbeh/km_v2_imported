import 'package:flutter/material.dart';

import '../core/core_importer.dart';

class KAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool isFromStore;
  final GlobalKey<ScaffoldState> scaffoldKey;
  final TextEditingController searchController;

  const KAppBar({Key key, this.scaffoldKey, this.isFromStore = false, this.searchController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
        converter: (store) => store.state,
        distinct: true,
        builder: (context, state) {
          return AppBar(
            iconTheme: const IconThemeData(color: Colors.transparent),
            backgroundColor: ColorUtils.kmColors,
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
                        padding: const EdgeInsets.only(top: 8.0, right: 15),
                        child: isFromStore
                            ? InkWell(
                                onTap: () => scaffoldKey.currentState.openDrawer(),
                                child: const Icon(Icons.menu, color: Colors.white, size: 40),
                              )
                            : state.productsState.productsType != ProductsViewTypes.favorite
                                ? const PopArrow()
                                : const SizedBox(width: 40),
                      ),
                      const AppBarKammunImage(),
                      const Padding(padding: EdgeInsets.only(top: 15.0, left: 20), child: CartIcon()),
                    ],
                  ),
                  StoreSearchTextField(scaffoldKey: scaffoldKey, searchController: searchController),
                ],
              ),
            ),
          );
        });
  }

  @override
  Size get preferredSize => const Size.fromHeight(105.0);
}
