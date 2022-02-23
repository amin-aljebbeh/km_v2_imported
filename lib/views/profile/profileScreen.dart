import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kammun_app/utils/utils_importer.dart';
import 'package:kammun_app/views/widget/address_widget.dart';
import 'package:kammun_app/views/widget/widgets_importer.dart';
import 'package:kammun_app/views/add_address/add_address_view.dart';
import 'package:kammun_app/views/deliver_to/deliver_to_view.dart';
import 'package:kammun_app/views/loading/LoadingServices.dart';

import '../../Services.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isLoading = false;
  bool isError = false;

  void onrRemove(item) async {
    setState(() {
      isLoading = true;
      isError = false;
    });
    bool success = await Services.removeUserAddress(LoadingScreenServices.userAddress[item].id.toString());

    if (success) {
      setState(() {
        isLoading = false;
        isError = false;
        LoadingScreenServices.userAddress.removeAt(item);

        if (DeliverToView.selectedIndex != null && DeliverToView.selectedIndex > 0) DeliverToView.selectedIndex--;
      });
    } else {
      setState(() {
        isLoading = false;
        isError = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColorLight,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(left: 0, top: 10, right: 20, bottom: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  IconButton(
                      icon: Icon(Icons.arrow_back_ios, color: Theme.of(context).primaryColorDark, size: 45),
                      onPressed: () {
                        Navigator.of(context).pop();
                      }),
                  InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        StringUtils.profileInfo,
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontFamily: StringUtils.fontFamilyHKGrotesk,
                            fontSize: 30),
                      )),
                ],
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 30.0),
                  child: Center(
                    child: Text(
                      "الرقم الشخصي",
                      style: TextStyle(
                          fontWeight: FontWeight.w700, fontFamily: StringUtils.fontFamilyHKGrotesk, fontSize: 20),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 30.0, right: 0, bottom: 30, top: 10),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(color: ColorUtils.primaryColor, spreadRadius: 3),
                    ],
                  ),
                  child: ListTile(
                    leading: Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Icon(
                        FontAwesomeIcons.phone,
                        color: ColorUtils.kmColors,
                        size: 30,
                      ),
                    ),
                    title: Padding(
                      padding: const EdgeInsets.only(top: 5.0),
                      child: Text(
                        LoadingScreenServices.userNumber,
                        style: TextStyle(
                            fontFamily: StringUtils.fontFamilyHKGrotesk, fontSize: 25, color: Colors.black),
                      ),
                    ),
                    onTap: () {},
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Text(
                    StringUtils.addressTitle,
                    style: TextStyle(
                        fontWeight: FontWeight.w700, fontFamily: StringUtils.fontFamilyHKGrotesk, fontSize: 20),
                  ),
                ),
              ),
              isLoading
                  ? Container(
                      width: double.infinity,
                      height: 200,
                      child: Center(child: Loader()),
                    )
                  : Expanded(
                      child: ListView(
                        children: <Widget>[
                          isError
                              ? Padding(
                                  padding: const EdgeInsets.only(left: 10.0, right: 0, bottom: 0, top: 10),
                                  child: AlertMessages(
                                    text: " يرجى المحاولى مرة أُخرى و التأكد من إتصالك بالإنترنت",
                                    messageType: "internetError",
                                    headerText: " حدث خطأ اثناء محاولة حذف العنوان ",
                                  ),
                                )
                              : Container(),
                          LoadingScreenServices.userAddress.length != 0
                              ? ListView.builder(
                                  primary: false,
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  itemCount: LoadingScreenServices.userAddress == null
                                      ? 0
                                      : LoadingScreenServices.userAddress.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    return AddressWidget(
                                      onRemove: () => onrRemove(index),
                                      index: index,
                                    );
                                  },
                                )
                              : Padding(
                                  padding: const EdgeInsets.only(left: 30.0, right: 0, bottom: 30, top: 10),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(color: ColorUtils.primaryColor, spreadRadius: 3),
                                      ],
                                    ),
                                    child: ListTile(
                                      leading: Padding(
                                        padding: const EdgeInsets.only(top: 8.0),
                                        child: Icon(
                                          FontAwesomeIcons.addressCard,
                                          color: ColorUtils.kmColors,
                                          size: 30,
                                        ),
                                      ),
                                      title: Padding(
                                        padding: const EdgeInsets.only(top: 5.0),
                                        child: Text(
                                          "لايوجد عنوان مسجل ",
                                          style: TextStyle(
                                              fontFamily: StringUtils.fontFamilyHKGrotesk,
                                              fontSize: 25,
                                              color: Colors.black),
                                        ),
                                      ),
                                      onTap: () {},
                                    ),
                                  ),
                                ),
                          Align(
                              alignment: Alignment.center,
                              child: FlatButton(
                                padding: EdgeInsets.only(left: 30.0, top: 10.0),
                                child: Text(StringUtils.addNewAddress,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: ColorUtils.greyColor,
                                        fontFamily: StringUtils.fontFamilyHKGrotesk,
                                        fontSize: 17)),
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      new MaterialPageRoute(
                                          builder: (context) => new AddAddressView(
                                                isFromDeliveryScreen: false,
                                              )));
                                },
                              )),
                        ],
                      ),
                    )
            ],
          ),
        ),
      ),
    );
  }
}
