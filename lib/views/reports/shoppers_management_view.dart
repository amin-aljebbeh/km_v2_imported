import 'package:flutter/material.dart';
import 'package:kammun_app/utils/utils_importer.dart';
import 'package:kammun_app/views/Wedgit/widgets_importer.dart';
import 'package:kammun_app/views/loading/LoadingServices.dart';

class ShopperManagementView extends StatefulWidget {
  @override
  _ShopperManagementViewState createState() => _ShopperManagementViewState();
}

class _ShopperManagementViewState extends State<ShopperManagementView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'فريق التوصيل',
          style: mainStyle,
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
          primary: false,
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: LoadingScreenServices.allShoppers == null ? 0 : LoadingScreenServices.allShoppers.length,
          itemBuilder: (BuildContext context, int index) {
            return ShopperWidget(shopper: LoadingScreenServices.allShoppers[index]);
          },
        ),
      ),
    );
  }
}
