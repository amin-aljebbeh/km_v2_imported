import 'package:kammun_app/features/products_view/products_view.dart';

import '../../core/core_importer.dart';

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
      child: Container(
        height: 40.0,
        decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(6.0))),
        child: TextField(
          controller: searchController,
          onSubmitted: (_) => submit(context),
          cursorColor: primaryColor,
          decoration: InputDecoration(
            prefixIcon: SizedBox(
              width: MediaQuery.of(context).size.width * 0.25,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  BarcodeIcon(
                    onPressed: onSubmit ?? () {},
                    requestType: BarcodeRequestType.search,
                    scaffoldKey: scaffoldKey,
                    color: primaryColor,
                  ),
                  IconButton(icon: Icon(Icons.search, color: primaryColor), onPressed: () => submit(context)),
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
            hintText: search,
            hintStyle: mainStyle,
          ),
        ),
      ),
    );
  }

  submit(BuildContext context) {
    if (searchController.text.isNotEmpty) {
      if (onSubmit != null) onSubmit();
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => ProductsView(queryString: searchController.text, categoryId: '0')));
    }
  }
}
