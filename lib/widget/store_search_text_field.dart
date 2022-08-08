import 'package:flutter/material.dart';
import 'package:kammun_app/core/core_importer.dart';
import '../modules/products/view/products_view.dart';

class StoreSearchTextField extends StatelessWidget {
  final TextEditingController searchController;
  final Function onSubmit;
  final GlobalKey<ScaffoldState> scaffoldKey;

  const StoreSearchTextField({Key key, @required this.searchController, this.onSubmit, this.scaffoldKey})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 5),
      child: Row(
        children: [
          Container(
            width: MediaQuery.of(context).size.width - 75,
            height: 40.0,
            decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(6.0))),
            child: TextField(
              controller: searchController,
              onSubmitted: (_) => submit(context),
              cursorColor: ColorUtils.primaryColor,
              decoration: InputDecoration(
                border: InputBorder.none,
                prefixIcon: IconButton(
                  icon: Icon(Icons.search, color: ColorUtils.primaryColor),
                  onPressed: () => submit(context),
                ),
                contentPadding: const EdgeInsets.only(bottom: 0.5),
                hintText: StringUtils.search,
                hintStyle: mainStyle,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: BarcodeIcon(onPressed: onSubmit ?? () {}),
          ),
        ],
      ),
    );
  }

  submit(BuildContext context) {
    if (searchController.text.isNotEmpty) {
      if (onSubmit != null) onSubmit();
      StoreProvider.of<AppState>(context).dispatch(NoError());
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              ProductsView(productsViewType: ProductsViewTypes.search, queryString: searchController.text),
        ),
      );
    }
  }
}
