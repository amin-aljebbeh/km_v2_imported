import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kammun_app/utils/utils_importer.dart';
import 'package:kammun_app/views/add_address/add_address_view.dart';
import 'package:kammun_app/views/deliver_to/deliver_to_view.dart';
import 'package:kammun_app/views/loading/LoadingServices.dart';
import 'package:kammun_app/views/loading/user_services.dart';

import '../../Services.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  void onrRemove(item) {
    Services.removeUserAddress(
        LoadingScreenServices.userAddress[item].id.toString());
    setState(() {
      LoadingScreenServices.userAddress.removeAt(item);

      if (DeliverToView.selectedIndex != null &&
          DeliverToView.selectedIndex > 0) DeliverToView.selectedIndex--;
    });
  }

  Widget _showDeleteButton({int index}) {
    final GestureDetector showConfirmButtonWithGesture = new GestureDetector(
      onTap: () {
        onrRemove(index);
      },
      child: new Container(
        height: 35.0,
        width: 125,
        decoration: new BoxDecoration(
            color: UtilsImporter().colorUtils.primarycolor,
            borderRadius: new BorderRadius.all(Radius.circular(6.0))),
        child: new Center(
          child: new Text(
            UtilsImporter().stringUtils.delete.toUpperCase(),
            style: new TextStyle(
                color: Colors.white,
                fontSize: 15.0,
                fontWeight: FontWeight.w500,
                fontFamily: UtilsImporter().stringUtils.HKGrotesk),
          ),
        ),
      ),
    );

    return new Padding(
        padding: EdgeInsets.only(left: 0.0, right: 0.0, top: 0.0, bottom: 5),
        child: showConfirmButtonWithGesture);
  }

  Widget _showEidte({int index}) {
    final GestureDetector showConfirmButtonWithGesture = new GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            new MaterialPageRoute(
                builder: (context) => new AddAddressView(
                      isFromDeliveryScreen: false,
                      addressIndex: index,
                    )));
      },
      child: new Container(
        height: 35.0,
        width: 125,
        decoration: new BoxDecoration(
            color: UtilsImporter().colorUtils.primarycolor,
            borderRadius: new BorderRadius.all(Radius.circular(6.0))),
        child: new Center(
          child: new Text(
            UtilsImporter().stringUtils.edit_address.toUpperCase(),
            style: new TextStyle(
                color: Colors.white,
                fontSize: 15.0,
                fontWeight: FontWeight.w500,
                fontFamily: UtilsImporter().stringUtils.HKGrotesk),
          ),
        ),
      ),
    );

    return new Padding(
        padding: EdgeInsets.only(left: 0.0, right: 0.0, top: 0.0, bottom: 5),
        child: showConfirmButtonWithGesture);
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
                      icon: Icon(Icons.arrow_back_ios,
                          color: Theme.of(context).primaryColorDark, size: 45),
                      onPressed: () {
                        Navigator.of(context).pop();
                      }),
                  InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        UtilsImporter().stringUtils.profile_info,
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontFamily: UtilsImporter().stringUtils.HKGrotesk,
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
                          fontWeight: FontWeight.w700,
                          fontFamily: UtilsImporter().stringUtils.HKGrotesk,
                          fontSize: 20),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 30.0, right: 0, bottom: 30, top: 10),
                child: Container(
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
                        LoadingScreenServices.userNumber,
                        style: TextStyle(
                            fontFamily: UtilsImporter().stringUtils.HKGrotesk,
                            fontSize: 25,
                            color: Colors.black),
                      ),
                    ),

                    // subtitle: Text(
                    //   "0957570213",
                    //   style: TextStyle(
                    //       fontFamily: UtilsImporter().stringUtils.HKGrotesk,
                    //       fontWeight: FontWeight.bold,
                    //       fontSize: 30),
                    // ),
                    onTap: () {},
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Text(
                    UtilsImporter().stringUtils.addressTitle,
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontFamily: UtilsImporter().stringUtils.HKGrotesk,
                        fontSize: 20),
                  ),
                ),
              ),
              Expanded(
                child: ListView(
                  children: <Widget>[
                    LoadingScreenServices.userAddress.length != 0
                        ? ListView.builder(
                            primary: false,
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount: LoadingScreenServices.userAddress == null
                                ? 0
                                : LoadingScreenServices.userAddress.length,
                            itemBuilder: (BuildContext context, int index) {
                              return new GestureDetector(
                                behavior: HitTestBehavior.translucent,
                                child: Container(
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        left: 0, right: 0, top: 0),
                                    child: cardBody(index, context),
                                  ),
                                ),
                              );
                            },
                          )
                        : Padding(
                            padding: const EdgeInsets.only(
                                left: 30.0, right: 0, bottom: 30, top: 10),
                            child: Container(
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
                              child: ListTile(
                                leading: Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Icon(
                                    FontAwesomeIcons.addressCard,
                                    color: UtilsImporter().colorUtils.kmColors,
                                    size: 30,
                                  ),
                                ),
                                title: Padding(
                                  padding: const EdgeInsets.only(top: 5.0),
                                  child: Text(
                                    "لايوجد عنوان مسجل ",
                                    style: TextStyle(
                                        fontFamily: UtilsImporter()
                                            .stringUtils
                                            .HKGrotesk,
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
                          child: Text(
                              UtilsImporter().stringUtils.add_new_address,
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: UtilsImporter().colorUtils.greycolor,
                                  fontFamily:
                                      UtilsImporter().stringUtils.HKGrotesk,
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
                    _showDeleteButton(index: index),
                    _showEidte(index: index),
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
