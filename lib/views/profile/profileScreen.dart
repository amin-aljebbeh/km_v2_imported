import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kammun_app/utils/tools.dart';
import 'package:kammun_app/utils/utils_importer.dart';
import 'package:kammun_app/views/Wedgit/kammun_button.dart';
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
    bool success = await Services.removeUserAddress(
        LoadingScreenServices.userAddress[item].id.toString());

    if (success) {
      setState(() {
        isLoading = false;
        isError = false;
        LoadingScreenServices.userAddress.removeAt(item);

        if (DeliverToView.selectedIndex != null &&
            DeliverToView.selectedIndex > 0) DeliverToView.selectedIndex--;
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
          child: ListView(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  IconButton(
                      icon: Icon(Icons.arrow_back_ios,
                          color: Theme.of(context).primaryColorDark, size: 45),
                      onPressed: () {
                        Navigator.of(context).pop();
                      }),
                  InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              SizedBox(height: 5),
                              Text(
                                LoadingScreenServices.name,
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontFamily:
                                        UtilsImporter().stringUtils.HKGrotesk,
                                    fontSize: 30),
                              ),
                              Text(
                                LoadingScreenServices.userName,
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontFamily:
                                        UtilsImporter().stringUtils.HKGrotesk,
                                    fontSize: 15),
                              ),
                            ],
                          ),
                          SizedBox(
                            width: 35,
                          ),
                        ],
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
                          fontWeight: FontWeight.w700,
                          fontFamily: UtilsImporter().stringUtils.HKGrotesk,
                          fontSize: 20),
                    ),
                  ),
                ),
              ),
              Center(
                child: Container(
                  margin: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                          color: UtilsImporter().colorUtils.primarycolor,
                          spreadRadius: 3),
                    ],
                  ),
                  child: ListTile(
                    leading: Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Icon(
                        FontAwesomeIcons.phone,
                        color: UtilsImporter().colorUtils.kmColors,
                        size: 30,
                      ),
                    ),
                    title: Padding(
                      padding: const EdgeInsets.only(top: 5.0),
                      child: Text(
                        LoadingScreenServices.PhoneNumber ?? "لا يوجد",
                        style: TextStyle(
                            fontFamily: UtilsImporter().stringUtils.HKGrotesk,
                            fontSize: 25,
                            color: Colors.black),
                      ),
                    ),
                    onTap: () {},
                  ),
                ),
              ),
              Services.roles.isNotEmpty
                  ? Column(
                      children: [
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 20.0),
                            child: Center(
                              child: Text(
                                "المستودع",
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontFamily:
                                        UtilsImporter().stringUtils.HKGrotesk,
                                    fontSize: 20),
                              ),
                            ),
                          ),
                        ),
                        Center(
                          child: Container(
                            margin: EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                    color:
                                        UtilsImporter().colorUtils.primarycolor,
                                    spreadRadius: 3),
                              ],
                            ),
                            child: Center(
                              child: Column(
                                children: LoadingScreenServices.subWarehouses
                                    .map((data) => Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                          ),
                                          child: Text(
                                            "${data.name}",
                                            style: TextStyle(
                                                fontFamily: UtilsImporter()
                                                    .stringUtils
                                                    .HKGrotesk,
                                                fontSize: 25,
                                                color: Colors.black),
                                          ),
                                        ))
                                    .toList(),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: Text(
                              "الجهة المفضلة لاستخدام الهاتف",
                              style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontFamily:
                                      UtilsImporter().stringUtils.HKGrotesk,
                                  fontSize: 20),
                            ),
                          ),
                        ),
                        Center(
                          child: Container(
                            margin: EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                    color:
                                        UtilsImporter().colorUtils.primarycolor,
                                    spreadRadius: 3),
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                IconButton(
                                  icon: Icon(
                                    Icons.library_add_check_outlined,
                                    color: LoadingScreenServices.preferLeftSide
                                        ? UtilsImporter()
                                            .colorUtils
                                            .searchgreycolor
                                        : UtilsImporter().colorUtils.kmColors2,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      LoadingScreenServices.preferLeftSide
                                          ? LoadingScreenServices
                                              .setPreferLeftSide(false)
                                          : Tools.logToConsole('');
                                    });
                                  },
                                ), //right side
                                IconButton(
                                  icon: Icon(
                                    Icons.library_add_check_outlined,
                                    color: LoadingScreenServices.preferLeftSide
                                        ? UtilsImporter().colorUtils.kmColors2
                                        : UtilsImporter()
                                            .colorUtils
                                            .searchgreycolor,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      LoadingScreenServices.preferLeftSide
                                          ? Tools.logToConsole('')
                                          : LoadingScreenServices
                                              .setPreferLeftSide(true);
                                    });
                                  },
                                ), //left side
                              ],
                            ),
                          ),
                        ),
                        Services.shopper != null
                            ? Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Center(
                                      child: Text(
                                        "المستوى",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            fontFamily: UtilsImporter()
                                                .stringUtils
                                                .HKGrotesk,
                                            fontSize: 20),
                                      ),
                                    ),
                                  ),
                                  Center(
                                    child: Container(
                                      margin: EdgeInsets.all(15),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.white,
                                        boxShadow: [
                                          BoxShadow(
                                              color: UtilsImporter()
                                                  .colorUtils
                                                  .primarycolor,
                                              spreadRadius: 3),
                                        ],
                                      ),
                                      child: Center(
                                        child: Text(
                                          UtilsImporter()
                                                  .stringUtils
                                                  .shopperLevels[
                                              Services.shopper.levelId - 1],
                                          style: TextStyle(
                                              fontFamily: UtilsImporter()
                                                  .stringUtils
                                                  .HKGrotesk,
                                              fontSize: 25,
                                              color: Colors.black),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : Container(),
                      ],
                    )
                  : Container(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Text(
                    "تسجيل الخروج",
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontFamily: UtilsImporter().stringUtils.HKGrotesk,
                        fontSize: 20),
                  ),
                ),
              ),
              Center(
                child: Container(
                  margin: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                          color: UtilsImporter().colorUtils.primarycolor,
                          spreadRadius: 3),
                    ],
                  ),
                  child: ListTile(
                    leading: Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: IconButton(
                        onPressed: () {
                          Services.logOutAdmin(context);
                        },
                        icon: Icon(
                          Icons.logout,
                          color: UtilsImporter().colorUtils.kmColors,
                          size: 30,
                        ),
                      ),
                    ),
                    title: Padding(
                      padding: const EdgeInsets.only(top: 5.0),
                      child: Text(
                        "تسجيل الخروج",
                        style: TextStyle(
                            fontFamily: UtilsImporter().stringUtils.HKGrotesk,
                            fontSize: 25,
                            color: Colors.black),
                      ),
                    ),
                    onTap: () {},
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Column cardBody(int index, BuildContext context) {
    return Column(children: <Widget>[
      Padding(
        padding: EdgeInsets.only(left: 20, top: 10),
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                  Radius.circular(5.0) //         <--- border radius here
                  ),
              border: Border.all(
                width: 2,
                color: UtilsImporter().colorUtils.kmColors,
              )),
          child: Card(
            elevation: 1.0,
            color: Theme.of(context).primaryColorLight,
            child: Column(
              children: [
                Row(
                  children: <Widget>[
                    SizedBox(width: 10),
                    Expanded(
                      child: Container(
                        child: Wrap(
                          direction: Axis.horizontal,
                          children: <Widget>[
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    LoadingScreenServices
                                        .userAddress[index].supportedCityName,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontFamily: UtilsImporter()
                                            .stringUtils
                                            .HKGrotesk,
                                        fontSize: 20),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    LoadingScreenServices
                                        .userAddress[index].street,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        color: UtilsImporter()
                                            .colorUtils
                                            .greycolor,
                                        fontFamily: UtilsImporter()
                                            .stringUtils
                                            .HKGrotesk,
                                        fontSize: 20),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    LoadingScreenServices
                                        .userAddress[index].building,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        color: UtilsImporter()
                                            .colorUtils
                                            .greycolor,
                                        fontFamily: UtilsImporter()
                                            .stringUtils
                                            .HKGrotesk,
                                        fontSize: 20),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    LoadingScreenServices
                                        .userAddress[index].description,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        color: UtilsImporter()
                                            .colorUtils
                                            .greycolor,
                                        fontFamily: UtilsImporter()
                                            .stringUtils
                                            .HKGrotesk,
                                        fontSize: 20),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Divider(
                    color: UtilsImporter().colorUtils.kmColors,
                    thickness: 3,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  //    crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    KammunButton(
                      text: UtilsImporter().stringUtils.delete.toUpperCase(),
                      width: 125,
                      height: 35,
                      color: UtilsImporter().colorUtils.primarycolor,
                      onTap: () {
                        onrRemove(index);
                      },
                    ),
                    // _showDeleteButton(index: index),
                    KammunButton(
                      text: UtilsImporter().stringUtils.edit.toUpperCase(),
                      width: 125,
                      height: 35,
                      color: UtilsImporter().colorUtils.primarycolor,
                      onTap: () {
                        Navigator.push(
                          context,
                          new MaterialPageRoute(
                            builder: (context) => new AddAddressView(
                              isFromDeliveryScreen: false,
                              addressIndex: index,
                            ),
                          ),
                        );
                      },
                    ),
                    // _showEdit(index: index),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    ]);
  }
}
