import 'package:flutter/material.dart';
import 'package:kammun_app/utils/utils_importer.dart';
import 'package:kammun_app/views/Wedgit/widgets_importer.dart';
import 'package:kammun_app/views/products_view/products_view.dart';

class StoreSearchTextField extends StatelessWidget {
  final TextEditingController searchController;
  final Function onSubmit;
  final GlobalKey<ScaffoldState> scaffoldKey;

  const StoreSearchTextField({Key key, @required this.searchController, this.onSubmit, this.scaffoldKey})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 5),
        child: new Container(
          height: 40.0,
          decoration:
              new BoxDecoration(color: Colors.white, borderRadius: new BorderRadius.all(Radius.circular(6.0))),
          child: TextField(
            controller: searchController,
            onSubmitted: (_) {
              if (onSubmit != null) onSubmit();
              Navigator.push(
                context,
                new MaterialPageRoute(
                  builder: (context) => new ProductsView(
                    queryString: searchController.text,
                    categoryId: "0",
                  ),
                ),
              );
            },
            cursorColor: ColorUtils.primaryColor,
            decoration: InputDecoration(
              prefixIcon: Container(
                width: MediaQuery.of(context).size.width * 0.19,
                child: Row(
                  children: [
                    BarcodeIcon(
                      onPressed: onSubmit != null ? onSubmit : () {},
                      requestType: BarcodeRequestType.search,
                      scaffoldKey: scaffoldKey,
                    ),
                    Icon(Icons.search),
                  ],
                ),
              ),
              contentPadding: const EdgeInsets.only(bottom: 0.5),
              hintText: StringUtils.search,
              hintStyle: mainStyle,
            ),
          ),
        ),
      ),
    );
  }
}
