import 'package:kammun_app/features/sub_category/sub_category_widget.dart';
import 'package:responsive_flutter/responsive_flutter.dart';

import '../../core/core_importer.dart';

class SubCategory extends StatefulWidget {
  static int cartCount = 0;
  final List<CategoryOriginalData> subCategory;
  final bool forProductAdding;
  final GlobalKey<ScaffoldState> scaffoldKey;
  final String supplierCode;

  const SubCategory({Key key, this.subCategory, this.forProductAdding = false, this.scaffoldKey, this.supplierCode})
      : super(key: key);

  @override
  _SubCategoryState createState() => _SubCategoryState();
}

class _SubCategoryState extends State<SubCategory> {
  TextEditingController searchController = TextEditingController();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: PreferredSize(
        child: AppBar(
          leading: Padding(
            padding: const EdgeInsets.only(top: 8.0, right: 25),
            child: IconButton(
              icon: const Icon(Icons.shopping_cart, size: 35, color: Colors.white),
              onPressed: () {
                if (!widget.forProductAdding) {
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
                    const Padding(padding: EdgeInsets.only(top: 10), child: AppBarKammunImage()),
                    Padding(
                      padding: const EdgeInsets.only(top: 5.0, left: 0),
                      child: IconButton(
                        onPressed: () => Navigator.of(context).pop(true),
                        icon: const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 40),
                      ),
                    ),
                  ],
                ),
                if (!widget.forProductAdding)
                  StoreSearchTextField(searchController: searchController, scaffoldKey: scaffoldKey),
              ],
            ),
          ),
        ),
        preferredSize: const Size.fromHeight(105),
      ),
      body: widget.subCategory.isEmpty
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
              itemCount: widget.subCategory == null ? 0 : widget.subCategory.length,
              itemBuilder: (BuildContext context, int index) {
                return SubCategoryWidget(
                    forProductAdding: widget.forProductAdding,
                    scaffoldKey: widget.scaffoldKey,
                    subCategory: widget.subCategory[index],
                    supplierCode: widget.supplierCode);
              },
            ),
    );
  }
}
