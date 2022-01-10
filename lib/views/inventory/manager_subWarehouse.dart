import 'package:flutter/material.dart';
import 'package:kammun_app/models/sub_warehouse_model.dart';
import 'package:kammun_app/utils/Loader.dart';
import 'package:kammun_app/views/Wedgit/widgets_importer.dart';
import 'package:kammun_app/views/inventory/sub_warehouse_products.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'services/inventory_services.dart';
import 'package:kammun_app/utils/utils_importer.dart';

class GetSubWarehouse extends StatefulWidget {
  const GetSubWarehouse({Key key}) : super(key: key);

  @override
  _GetSubWarehouseState createState() => _GetSubWarehouseState();
}

class _GetSubWarehouseState extends State<GetSubWarehouse> {
  bool isLoading = false;
  bool isError = false;

  List<SubWarehouse> listOfWubWarehouse = [];

  _getSubWarehouse() async {
    setState(() {
      isLoading = true;
      isError = false;
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();

    List<SubWarehouse> response = await InventoryServices.getSubWarehoused(
        adminId: prefs.getString("adminId"));
    if (response != null) {
      setState(() {
        listOfWubWarehouse.addAll(response);
        isLoading = false;
        isError = false;
      });
    } else {
      setState(() {
        isLoading = false;
        isError = true;
      });
    }
  }

  @override
  void initState() {
    _getSubWarehouse();
    super.initState();
  }

  int _selectedSubWarehouseValue = -1;
  bool selected = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          StringUtils.kammun,
          style: TextStyle(
            fontFamily: StringUtils.fontFamilyHKGrotesk,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Container(
        child: isLoading
            ? Loader()
            : Padding(
                padding: const EdgeInsets.all(20.0),
                child: ListView(
                  children: [
                    Text(
                      "يرجى إختيار المستودع التابع لهذه المادة",
                      style: TextStyle(
                        fontFamily: StringUtils.fontFamilyHKGrotesk,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    ListTile(
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 10.0, vertical: 0.0),
                      title: Column(
                        children: listOfWubWarehouse
                            .map((data) => Container(
                                  decoration: BoxDecoration(
                                      color: Theme.of(context)
                                          .scaffoldBackgroundColor),
                                  child: RadioListTile(
                                    controlAffinity:
                                        ListTileControlAffinity.trailing,
                                    activeColor: Theme.of(context).primaryColor,
                                    title: Text(
                                      "${data.name}",
                                      style: TextStyle(
                                        fontFamily:
                                            StringUtils.fontFamilyHKGrotesk,
                                      ),
                                    ),
                                    groupValue: _selectedSubWarehouseValue,
                                    value: data.id,
                                    onChanged: (val) {
                                      setState(() {
                                        selected = true;
                                        _selectedSubWarehouseValue = data.id;
                                      });
                                    },
                                  ),
                                ))
                            .toList(),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    KammunButton(
                      height: 50,
                      text: StringUtils.next,
                      color: selected
                          ? Theme.of(context).primaryColor
                          : ColorUtils.searchGreyColor,
                      onTap: () {
                        if (selected)
                          Navigator.push(
                            context,
                            new MaterialPageRoute(
                              builder: (context) => new SubWarehouseProducts(
                                subWarehouseId:
                                    _selectedSubWarehouseValue.toString(),
                              ),
                            ),
                          );
                        else
                          Toast.show('يرجى اختيار المستودع', context,
                              duration: Toast.LENGTH_LONG,
                              gravity: Toast.CENTER);
                      },
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
