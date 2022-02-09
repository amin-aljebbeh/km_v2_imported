import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:kammun_app/models/models_importer.dart';
import 'package:kammun_app/utils/utils_importer.dart';
import 'package:kammun_app/views/order_details/order_deleted_products.dart';

import '../../Services.dart';
import 'order_details_view_main.dart';

// ignore: must_be_immutable
class OrderDetailsTabView extends StatefulWidget {
  int subTotal;
  String total;
  OrdersOriginalData orderData;
  final OrderTypes orderType;
  double remaining;
  double totalDiscount;

  OrderDetailsTabView(
      {Key key, this.orderType, this.orderData, this.subTotal, this.total, this.remaining, this.totalDiscount})
      : super(key: key);

  @override
  _OrderDetailsTabViewState createState() => _OrderDetailsTabViewState();
}

class _OrderDetailsTabViewState extends State<OrderDetailsTabView> {
  bool deletedProducts;

  List<Tab> tabBarList() {
    List<Tab> tabList = [];

    tabList.add(
      Tab(
        child: Text(
          'المنتجات',
          style: naveBarStyle.copyWith(color: Colors.white),
        ),
      ),
    );
    if (deletedProducts)
      tabList.add(
        Tab(
          child: Text(
            'المنتجات المحذوفة',
            style: naveBarStyle.copyWith(color: Colors.white),
          ),
        ),
      );

    return tabList;
  }

  List<Widget> tabViewList() {
    List<Widget> tabList = [];

    tabList.add(
      OrderDetailViewMain(
        subTotal: widget.subTotal,
        total: widget.total.split('.')[0],
        order: widget.orderData,
        orderType: widget.orderType,
        remaining: widget.remaining,
        totalDiscount: widget.totalDiscount,
      ),
    );
    if (deletedProducts)
      tabList.add(
        OrderDeletedProducts(
          subTotal: widget.subTotal,
          total: widget.total.split('.')[0],
          order: widget.orderData,
          orderType: widget.orderType,
        ),
      );
    return tabList;
  }

  @override
  void initState() {
    setState(() {
      deletedProducts = Services.isAdmin() &&
          widget.orderData.products.where((product) => product.pivot.deletedAt != 'null').toList().length > 0;
    });

    super.initState();
  }

  bool isLoading = false;
  bool errorAlert = false;
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: deletedProducts ? 2 : 1,
      child: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            new SliverAppBar(
              title: !Services.isSupplierManager()
                  ? AutoSizeText(
                      widget.orderData.address.street.length > 37
                          ? widget.orderData.address.street.substring(0, 37)
                          : widget.orderData.address.street,
                      maxLines: 1,
                      overflow: TextOverflow.clip,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontFamily: StringUtils.fontFamilyHKGrotesk,
                      ),
                    )
                  : Text(
                      widget.orderData.id.toString().length >= 3
                          ? "#${widget.orderData.id.toString().substring(widget.orderData.id.toString().length - 3, widget.orderData.id.toString().length)}"
                          : '#${widget.orderData.id.toString()}',
                      style: profitStyle.copyWith(
                        color: Colors.purple,
                      ),
                    ),
              pinned: true,
              floating: true,
              bottom: TabBar(
                labelColor: Colors.red,
                indicatorColor: Colors.white,
                unselectedLabelColor: Colors.white,
                tabs: tabBarList(),
              ),
            ),
          ];
        },
        body: new TabBarView(
          children: tabViewList(),
        ),
      ),
    );
  }
}
