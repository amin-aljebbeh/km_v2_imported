import 'package:flutter/material.dart';
import 'package:kammun_app/utils/Styles.dart';
import 'package:kammun_app/utils/utils_importer.dart';
import 'package:kammun_app/views/Wedgit/k_searchable_dropdown.dart';
import 'package:kammun_app/views/Wedgit/transaction_widget.dart';

import '../../Services.dart';

class ShopperAccountStatement extends StatefulWidget {
  @override
  _ShopperAccountStatementState createState() =>
      _ShopperAccountStatementState();
}

class _ShopperAccountStatementState extends State<ShopperAccountStatement> {
  String shopperFilter;
  bool selected;

  @override
  void initState() {
    selected = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColorLight,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          'كشف حساب متسوق',
          style: mainStyle,
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(left: 20, top: 0, right: 20, bottom: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Services.isOperationManager()
                  ? Padding(
                      padding: const EdgeInsets.only(
                          left: 0, top: 015, right: 0, bottom: 15),
                      child: KSearchableDropdown(
                        hint: UtilsImporter().stringUtils.chooseShopper,
                        search: shopperFilter,
                        items: Services.shoppersNameList(),
                        onChanged: (value) {
                          setState(
                            () {
                              shopperFilter = value;
                              selected = true;
                            },
                          );
                        },
                      ),
                    )
                  : Container(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    '3550.0',
                    style: profitStyle,
                  ),
                  Text(
                    '3550.0',
                    style: profitStyle.copyWith(
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
              Services.isShopper() ||
                      (Services.isOperationManager() && selected)
                  ? Container(
                      height: MediaQuery.of(context).size.height * 0.75,
                      child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: 100,
                        itemBuilder: (BuildContext context, int index) {
                          return Transaction(
                            des: index % 5 == 0 && index % 3 != 0,
                            newTransaction: index.isEven && index % 3 == 0,
                          );
                        },
                      ),
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}
