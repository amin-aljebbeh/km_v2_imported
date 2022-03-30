import 'dart:io';

import 'package:flutter/material.dart';
import 'package:kammun_app/utils/utils_importer.dart';

import 'inventory_importer.dart';

class ExcelInventory extends StatefulWidget {
  final File file;
  final String subWarehouseId;

  const ExcelInventory({Key key, @required this.subWarehouseId, @required this.file}) : super(key: key);

  @override
  _ExcelInventoryState createState() => _ExcelInventoryState();
}

class _ExcelInventoryState extends State<ExcelInventory> {
  List<Widget> tabList = [];
  List<Widget> screenList = [];

  tabBarList() {
    tabList.add(
      Tab(
        child: Center(
          child: Text(
            'الجرد',
            style: naveBarStyle.copyWith(color: Colors.white),
          ),
        ),
      ),
    );
    tabList.add(
      Tab(
        child: Center(
          child: Text(
            'الأسعار',
            style: naveBarStyle.copyWith(color: Colors.white),
          ),
        ),
      ),
    );
    screenList.add(InventoryFileProduct(
      subWarehouseId: widget.subWarehouseId,
      file: widget.file,
    ));
    screenList.add(PriceFileProduct(
      subWarehouseId: widget.subWarehouseId,
      file: widget.file,
    ));
  }

  @override
  void initState() {
    tabBarList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 1,
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(kToolbarHeight),
            child: Container(
              color: ColorUtils.primaryColor,
              child: SafeArea(
                child: TabBar(
                  indicatorColor: Colors.white,
                  labelColor: Colors.white,
                  tabs: tabList,
                ),
              ),
            ),
          ),
          title: Text(
            StringUtils.inventory,
            style: mainStyle,
          ),
        ),
        body: TabBarView(
          children: screenList,
        ),
      ),
    );
  }
}
