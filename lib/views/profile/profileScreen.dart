import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kammun_app/utils/tools.dart';
import 'package:kammun_app/views/loading/LoadingServices.dart';
import 'package:kammun_app/utils/utils_importer.dart';

import '../../Services.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  bool isLoading = false;
  bool isError = false;
  AnimationController animationController;
  Animation animation;

  @override
  void initState() {
    super.initState();

    animationController = AnimationController(
      duration: Duration(seconds: 5),
      vsync: this,
    );
    animation =
        CurvedAnimation(parent: animationController, curve: Curves.decelerate);
    animationController.forward();
    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        animationController.reverse(from: 1.0);
      } else if (status == AnimationStatus.dismissed) {
        animationController.forward();
      }
    });

    animationController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColorLight,
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: RichText(
                textDirection: TextDirection.ltr,
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: LoadingScreenServices.name,
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontFamily: StringUtils.fontFamilyHKGrotesk,
                          fontSize: 30),
                    ),
                    TextSpan(text: '\n'),
                    TextSpan(
                      text: LoadingScreenServices.userName,
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontFamily: StringUtils.fontFamilyHKGrotesk,
                          fontSize: 15),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        backgroundColor: ColorUtils.kmColors,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(left: 10, top: 10, right: 10, bottom: 10),
          child: ListView(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.85,
                child: ListView(
                  children: [
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Center(
                          child: Text(
                            "الرقم الشخصي",
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontFamily: StringUtils.fontFamilyHKGrotesk,
                              fontSize: 20,
                            ),
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
                              color: ColorUtils.kmColors,
                              spreadRadius: 3,
                            ),
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
                              LoadingScreenServices.phoneNumber ?? "لا يوجد",
                              style: TextStyle(
                                fontFamily: StringUtils.fontFamilyHKGrotesk,
                                fontSize: 25,
                                color: Colors.black,
                              ),
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
                                            StringUtils.fontFamilyHKGrotesk,
                                        fontSize: 20,
                                      ),
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
                                        color: ColorUtils.kmColors,
                                        spreadRadius: 3,
                                      ),
                                    ],
                                  ),
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children:
                                          LoadingScreenServices.subWarehouses
                                              .map(
                                                (subWarehouse) => Container(
                                                  padding: EdgeInsets.all(5),
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                  ),
                                                  child: Text(
                                                    "${subWarehouse.name}",
                                                    style: TextStyle(
                                                      fontFamily: StringUtils
                                                          .fontFamilyHKGrotesk,
                                                      fontSize: 25,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ),
                                              )
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
                                          StringUtils.fontFamilyHKGrotesk,
                                      fontSize: 20,
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
                                        color: ColorUtils.kmColors,
                                        spreadRadius: 3,
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      IconButton(
                                        icon: Icon(
                                          Icons.library_add_check_outlined,
                                          color: LoadingScreenServices
                                                  .preferLeftSide
                                              ? ColorUtils.searchGreyColor
                                              : ColorUtils.kmColors2,
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
                                          color: LoadingScreenServices
                                                  .preferLeftSide
                                              ? ColorUtils.kmColors2
                                              : ColorUtils.searchGreyColor,
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
                            ],
                          )
                        : Container(),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: Text(
                          StringUtils.logout,
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontFamily: StringUtils.fontFamilyHKGrotesk,
                            fontSize: 20,
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
                              color: ColorUtils.kmColors,
                              spreadRadius: 3,
                            ),
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
                                color: ColorUtils.kmColors,
                                size: 30,
                              ),
                            ),
                          ),
                          title: Padding(
                            padding: const EdgeInsets.only(top: 5.0),
                            child: Text(
                              StringUtils.logout,
                              style: TextStyle(
                                fontFamily: StringUtils.fontFamilyHKGrotesk,
                                fontSize: 25,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          onTap: () {},
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
