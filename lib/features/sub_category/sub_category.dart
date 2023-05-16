import 'package:kammun_app/features/sub_category/sub_category_widget.dart';
import 'package:responsive_flutter/responsive_flutter.dart';

import '../../core/core_importer.dart';

class SubCategory extends StatelessWidget {
  static int cartCount = 0;
  final List<CategoryOriginalData> subCategory;
  final bool forProductAdding;
  final GlobalKey<ScaffoldState> scaffoldKey;
  final String supplierCode;

  SubCategory({Key key, this.subCategory, this.forProductAdding = false, this.scaffoldKey, this.supplierCode})
      : super(key: key);

  final TextEditingController searchController = TextEditingController();
  final GlobalKey<ScaffoldState> myScaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: myScaffoldKey,
      appBar: PreferredSize(
        child: AppBar(
          leading: Padding(
            padding: const EdgeInsets.only(top: 8.0, right: 25),
            child: IconButton(
              icon: const Icon(Icons.shopping_cart, size: 35, color: Colors.white),
              onPressed: () {
                if (!forProductAdding) {
                  Navigator.of(context).pushNamedAndRemoveUntil(CartView.routeName, (Route<dynamic> route) => false);
                }
              },
            ),
          ),
          backgroundColor: const Color.fromARGB(255, 210, 178, 2),
          automaticallyImplyLeading: false,
          flexibleSpace: SafeArea(
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                        padding: EdgeInsets.only(right: MediaQuery.of(context).size.width / 3.5),
                        child: const AppBarKammunImage()),
                    Padding(
                      padding: const EdgeInsets.only(top: 5.0, left: 0),
                      child: IconButton(
                        onPressed: () => Navigator.of(context).pop(true),
                        icon: const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 40),
                      ),
                    ),
                  ],
                ),
                if (!forProductAdding)
                  StoreSearchTextField(searchController: searchController, scaffoldKey: myScaffoldKey),
              ],
            ),
          ),
        ),
        preferredSize: const Size.fromHeight(105),
      ),
      body: subCategory.isEmpty
          ? Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.only(left: 75.0, right: 90.0),
                child: Center(
                  child: Text("لا يوجد اصناف متوفرة حالياً، سيتم إضافة اصناف في المستقبل",
                      style: mainStyle.copyWith(
                          color: primaryColor,
                          fontSize: ResponsiveFlutter.of(context).fontSize(3),
                          fontWeight: FontWeight.bold)),
                ),
              ),
            )
          : ListView.builder(
              primary: false,
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
              itemCount: subCategory == null ? 0 : subCategory.length,
              itemBuilder: (BuildContext context, int index) {
                return SubCategoryWidget(
                    forProductAdding: forProductAdding,
                    scaffoldKey: scaffoldKey,
                    subCategory: subCategory[index],
                    supplierCode: supplierCode);
              },
            ),
    );
  }
}
