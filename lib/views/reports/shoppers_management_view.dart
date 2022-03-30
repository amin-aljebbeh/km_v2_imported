import 'package:flutter/material.dart';
import 'package:kammun_app/utils/utils_importer.dart';
import 'package:kammun_app/views/loading/LoadingServices.dart';
import 'package:kammun_app/views/widget/widgets_importer.dart';

import '../../Services.dart';

class ShopperManagementView extends StatefulWidget {
  const ShopperManagementView({Key key}) : super(key: key);

  @override
  _ShopperManagementViewState createState() => _ShopperManagementViewState();
}

class _ShopperManagementViewState extends State<ShopperManagementView> {
  bool loading;

  loadShopper() async {
    await Services.getShoppers();
    setState(() {
      loading = false;
    });
  }

  @override
  void initState() {
    loading = true;
    loadShopper();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'فريق التوصيل',
          style: mainStyle,
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
                itemCount:
                    LoadingScreenServices.allShoppers == null ? 0 : LoadingScreenServices.allShoppers.length,
                itemBuilder: (BuildContext context, int index) {
                  return ShopperWidget(shopper: LoadingScreenServices.allShoppers[index]);
                },
              ),
      ),
    );
  }
}
