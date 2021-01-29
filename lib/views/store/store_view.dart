import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:kammun_app/utils/tools.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kammun_app/utils/utils_importer.dart';
import 'package:kammun_app/views/errors_screen/internet_error.dart';
import 'package:kammun_app/views/loading/Loading.dart';
import 'package:kammun_app/views/loading/LoadingServices.dart';
import 'package:kammun_app/views/products_view/products_view.dart';
import 'package:kammun_app/views/store/store_view_category_grid.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io' show Platform;
import '../../Services.dart';
import 'package:share/share.dart';

class StoreView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return StoreViewState();
  }
}

class StoreViewState extends State<StoreView> {
  TextEditingController searchController = new TextEditingController();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController _searchController = TextEditingController();

  final FocusNode _searchNameFocus = FocusNode();
// Color.fromARGB(255, 210, 178, 2) كموني
//Color.fromARGB(255, 53, 99, 124) كجلي
  bool isDarkThemeMode = false;
  // Future getCategories;

  _updateApplication() async {
    String url = LoadingScreen.updateUrl;

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  void initState() {
    super.initState();

    // if (LoadingScreenServices.bannerListNetwork.length == 0 ||
    //     LoadingScreenServices.categoryList.length == 0) {
    //   Navigator.push(context,
    //       new MaterialPageRoute(builder: (context) => new InternetError()));
    // }
    bool isThereOrderUnderUbdate = false;
    for (int i = 0; i < LoadingScreenServices.myOrdersList.length; i++) {
      if (LoadingScreenServices.myOrdersList[i].underUpdate == "1" &&
          int.parse(LoadingScreenServices.myOrdersList[i].orderStatusId) < 3) {
        isThereOrderUnderUbdate = true;
      }
    }
    if (Services.updateOption)
      WidgetsBinding.instance.addPostFrameCallback((_) => showUpdateDialog());

    if (isThereOrderUnderUbdate) {
      WidgetsBinding.instance.addPostFrameCallback(
          (_) => _showUpdateOrderInstruction(context: context));
    }
  }

  Widget _updateButton() {
    final GestureDetector loginButtonWithGesture = new GestureDetector(
      onTap: () => _updateApplication(),
      child: new Container(
        height: 50.0,
        decoration: new BoxDecoration(
            color: UtilsImporter().colorUtils.kmColors,
            borderRadius: new BorderRadius.all(Radius.circular(6.0))),
        child: new Center(
          child: new Text(
            " التحديث الآن ",
            style: new TextStyle(
                color: Colors.white,
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                fontFamily: UtilsImporter().stringUtils.HKGrotesk),
          ),
        ),
      ),
    );

    return Padding(
        padding: EdgeInsets.only(left: 0.0, right: 0.0, top: 10.0),
        child: loginButtonWithGesture);
  }

  Widget _okButton() {
    final GestureDetector loginButtonWithGesture = new GestureDetector(
      onTap: () => Navigator.of(context).pop(),
      child: new Container(
        height: 50.0,
        decoration: new BoxDecoration(
            color: UtilsImporter().colorUtils.primarycolor,
            borderRadius: new BorderRadius.all(Radius.circular(6.0))),
        child: new Center(
          child: new Text(
            "موافق",
            style: new TextStyle(
                color: Colors.white,
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                fontFamily: UtilsImporter().stringUtils.HKGrotesk),
          ),
        ),
      ),
    );

    return Padding(
        padding: EdgeInsets.only(left: 0.0, right: 0.0, top: 10.0),
        child: loginButtonWithGesture);
  }

  Widget _cancelButton() {
    final GestureDetector loginButtonWithGesture = new GestureDetector(
      onTap: () {
        setState(() {
          Services.updateOption = false;
        });
        Navigator.of(context).pop(true);
      },
      child: new Container(
        height: 50.0,
        decoration: new BoxDecoration(
            color: Colors.grey[700],
            borderRadius: new BorderRadius.all(Radius.circular(6.0))),
        child: new Center(
          child: new Text(
            " التحديث لاحقاً ",
            style: new TextStyle(
                color: Colors.white,
                fontSize: 20.0,
                fontWeight: FontWeight.w500,
                fontFamily: UtilsImporter().stringUtils.HKGrotesk),
          ),
        ),
      ),
    );

    return Padding(
        padding: EdgeInsets.only(left: 0.0, right: 0.0, top: 10.0),
        child: loginButtonWithGesture);
  }

  void showUpdateDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(1.0),
              topRight: Radius.circular(1.0),
              bottomLeft: Radius.circular(2.0),
              bottomRight: Radius.circular(2.0),
            ),
          ),
          contentPadding:
              EdgeInsets.only(top: 10, bottom: 0, right: 10, left: 10),
          titlePadding: EdgeInsets.all(0),
          title: Container(
            width: double.infinity,
            height: 50,
            color: Color.fromARGB(255, 247, 247, 247),
            child: Align(
              child: Padding(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(right: 10.0),
                      child: Text(
                        "تحديث متوفر",
                        style: TextStyle(
                            fontSize: 17,
                            color: UtilsImporter().colorUtils.primarycolor,
                            fontWeight: FontWeight.bold,
                            fontFamily: UtilsImporter().stringUtils.HKGrotesk),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () {
                        setState(() {
                          Services.updateOption = false;
                        });
                        Navigator.of(context).pop(true);
                      },
                    )
                  ],
                ),
                padding: EdgeInsets.only(left: 10),
              ),
            ),
          ),
          content: Container(
            height: 150,
            child: Column(
              children: <Widget>[
                RichText(
                  text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                        text: "إصدار جديد من التطبيق اصبح متوفراً ! ",
                        style: TextStyle(
                            color: Colors.grey[900],
                            fontSize: 20,
                            fontWeight: FontWeight.normal,
                            fontFamily: UtilsImporter().stringUtils.HKGrotesk),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10),
                ),
                new Divider(
                  color: Colors.grey[600],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width / 2.8,
                      child: _updateButton(),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width / 2.8,
                      child: _cancelButton(),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  _showUpdateOrderInstruction({BuildContext context}) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Stack(
              overflow: Overflow.visible,
              children: <Widget>[
                Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "لديك طلب قيد التعديل",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                            fontFamily: UtilsImporter().stringUtils.HKGrotesk,
                            fontSize: 18),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "يرجى التأكد من تثبيت الطلب بعد الإنتهاء من تعديله، يمكنك مشاهدة محتويات الطلب ضمن سلة المشتريات أو مراجعة الطلب ضمن صفحة الطلبات",
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: Colors.grey[800],
                            fontFamily: UtilsImporter().stringUtils.HKGrotesk,
                            fontSize: 18),
                      ),
                    ),
                    _okButton(),
                  ],
                ),
              ],
            ),
          );
        });
  }

  _openUrl(String selected) async {
    String url = "";
    if (selected == "whatsapp") {
      url = 'whatsapp://send?phone=' +
          LoadingScreenServices.supportPhoneNumber.toString();
    } else if (selected == "messenger") {
      url = LoadingScreenServices.companyInformation.messengerUrl;
    } else if (selected == "facebook") {
      url = "fb://page/" +
          LoadingScreenServices.companyInformation.facebookUrl.toString();
    } else if (selected == "instagram") {
      url = LoadingScreenServices.companyInformation.instagramUrl.toString();
    } else if (selected == "website") {
      url = LoadingScreenServices.companyInformation.websiteUrl.toString();
    } else if (selected == "email") {
      String platform = "Android";
      if (Platform.isIOS) {
        platform = "iPhone";
      }
      url =
          "mailto:${LoadingScreenServices.companyInformation.email}?subject=Support Request From $platform Application&body=";
    } else if (selected == "number") {
      Tools.logToConsole("-------- Support number ----------");

      url = "tel:${LoadingScreenServices.supportPhoneNumber.toString()}";
    }

    launch(url);
    // if (await canLaunch(url)) {
    //   await launch(url);
    // } else {
    //   Tools.logToConsole(url);
    //   throw 'Could not launch $url';
    // }
  }

  _shareApp() {
    String infoMessage =
        "تطبيق كمّون لتوصيل المنتجات الغذائية لباب بيتك و بأسعار منافسة\n";
    String androidGrating = "\n لتحميل التطبيق على الأندوريد \n";

    String androidUrl = androidGrating + LoadingScreenServices.iOSShareUrl;
    String iosGrating = "\n لتحميل التطبيق على الآيفون \n";
    String iPhoneUrl = iosGrating + LoadingScreenServices.androidShareUrl;

    Share.share(infoMessage + androidUrl + iPhoneUrl);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      drawer: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width / 1.5,
            child: Drawer(
              child: Container(
                color: Colors.white,
                child: ListView(
                  primary: false,
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width / 1.5,
                      height: 60,
                      child: Align(
                        alignment: Alignment.topRight,
                        child: DrawerHeader(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                  color: UtilsImporter().colorUtils.kmColors)),
                          child: InkWell(
                            onTap: () => Navigator.of(context).pop(),
                            child: Container(
                              width: MediaQuery.of(context).size.width / 1.5,
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Icon(
                                  Icons.arrow_back_ios,
                                  //color: Colors.white,
                                  color: UtilsImporter().colorUtils.kmColors,
                                ),
                              ),
                            ),
                          ),
                          // decoration: BoxDecoration(
                          //   color: UtilsImporter().colorUtils.primarycolor,
                          // ),
                        ),
                      ),
                    ),
                    Container(
                        child: Image.asset(
                          //  "assets/logobw.png",
                          "assets/kmlogoo.png",
                          width: 250,
                          height: 200,
                        ),

                        //color: UtilsImporter().colorUtils.kmColors,
                        color: Colors.white),
                    Divider(
                      color: UtilsImporter().colorUtils.kmColors,
                      // height: 20,
                    ),
                    ListTile(
                      leading: Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Icon(
                          Icons.phone,
                          color: UtilsImporter().colorUtils.kmColors,
                          size: 30,
                        ),
                      ),
                      title: Text(
                        "الإتصال بكمون",
                        style: TextStyle(
                          fontFamily: UtilsImporter().stringUtils.HKGrotesk,
                        ),
                      ),
                      // subtitle: Text(
                      //   LoadingScreenServices
                      //       .companyInformation.supportNumber,
                      //   style: TextStyle(
                      //       fontFamily: UtilsImporter().stringUtils.HKGrotesk,
                      //       fontWeight: FontWeight.bold),
                      // ),
                      onTap: () => _openUrl("number"),
                    ),
                    InkWell(
                      // onTap: _sendEmailToKammun,
                      child: ListTile(
                        leading: Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Icon(
                            Icons.share,
                            color: UtilsImporter().colorUtils.kmColors,
                            size: 30,
                          ),
                        ),
                        title: Text("إرسال التطبيق للأصدقاء",
                            style: TextStyle(
                                fontFamily:
                                    UtilsImporter().stringUtils.HKGrotesk)),
                        // subtitle: Text(
                        //   //'support@kammun.com',
                        //   "بدعمكم نستمر",

                        //   style: TextStyle(
                        //       fontFamily: UtilsImporter().stringUtils.HKGrotesk,
                        //       fontWeight: FontWeight.bold),
                        // ),
                        onTap: () => _shareApp(),
                      ),
                    ),
                    ListTile(
                      leading: Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Icon(
                          Icons.info_outline,
                          color: UtilsImporter().colorUtils.kmColors,
                          size: 30,
                        ),
                      ),
                      title: Text("الملف الشخصي",
                          style: TextStyle(
                              fontFamily:
                                  UtilsImporter().stringUtils.HKGrotesk)),
                      // subtitle: Text(
                      //   // 'www.kammun.com',
                      //   LoadingScreenServices
                      //       .companyInformation.websiteUrl,

                      //   style: TextStyle(
                      //       fontFamily: UtilsImporter().stringUtils.HKGrotesk,
                      //       fontWeight: FontWeight.bold),
                      // ),
                      onTap: () {
                        Navigator.of(context).pushNamed('/profile');
                      },
                    ),
                    Divider(
                      color: UtilsImporter().colorUtils.kmColors,
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            InkWell(
                              onTap: () => _openUrl("facebook"),
                              child: Icon(
                                FontAwesomeIcons.facebookF,
                                color: UtilsImporter().colorUtils.primarycolor,
                                size: 30,
                              ),
                            ),
                            InkWell(
                              onTap: () => _openUrl("instagram"),
                              child: Icon(
                                FontAwesomeIcons.instagram,
                                color: UtilsImporter().colorUtils.primarycolor,
                                size: 30,
                              ),
                            ),
                            InkWell(
                              onTap: () => _openUrl("messenger"),
                              child: Icon(
                                FontAwesomeIcons.facebookMessenger,
                                color: UtilsImporter().colorUtils.primarycolor,
                                size: 30,
                              ),
                            ),
                            InkWell(
                              onTap: () => _openUrl("whatsapp"),
                              child: Icon(
                                FontAwesomeIcons.whatsapp,
                                color: UtilsImporter().colorUtils.primarycolor,
                                size: 30,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      appBar: PreferredSize(
        child: AppBar(
          iconTheme: new IconThemeData(color: Colors.transparent),

          backgroundColor: Color.fromARGB(255, 210, 178, 2),
          automaticallyImplyLeading: false, // hides leading widget
          flexibleSpace: SafeArea(
            top: true,
            left: false,
            bottom: false,
            right: false,
            child: Column(
              children: <Widget>[
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                          padding: const EdgeInsets.only(top: 12.0),
                          child: InkWell(
                            onTap: () {
                              _scaffoldKey.currentState.openDrawer();
                            },
                            child: Icon(
                              Icons.menu,
                              color: Colors.white,
                              size: 40,
                            ),
                          )),
                      Padding(
                        padding: const EdgeInsets.only(top: 5.0),
                        child: Transform.scale(
                          scale: 2,
                          child: Image.asset(
                            "assets/logobw.png",
                            width: 150,
                            height: 50,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: IconButton(
                          icon: Icon(
                            Icons.shopping_cart,
                            size: 35,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            Navigator.of(context).pushNamedAndRemoveUntil(
                                '/cart', (Route<dynamic> route) => false);
                          },
                        ),
                      ),
                    ]),
                _showSearchTxtFld(),
              ],
            ),
          ),
        ),
        preferredSize: Size.fromHeight(105.0),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _ImageCarousel(),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          decoration: new BoxDecoration(
                            color: UtilsImporter().colorUtils.kmColors,
                            border:
                                new Border.all(color: Colors.white, width: 2.0),
                            borderRadius: new BorderRadius.circular(10.0),
                          ),
                          height: 10,
                        ),
                      ),
                      Text(
                        "  " +
                            UtilsImporter().stringUtils.shopbycategory +
                            "  ",
                        style: TextStyle(
                            color: UtilsImporter().colorUtils.primarycolor,
                            fontWeight: FontWeight.w900,
                            fontFamily: UtilsImporter().stringUtils.HKGrotesk,
                            fontSize: 22),
                      ),
                      Expanded(
                        child: Container(
                          decoration: new BoxDecoration(
                            color: UtilsImporter().colorUtils.kmColors,
                            border:
                                new Border.all(color: Colors.white, width: 2.0),
                            borderRadius: new BorderRadius.circular(10.0),
                          ),
                          height: 10,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  StoreViewCategory(),
                ],
              ),
            )),
      ),
    );
  }

  Widget _ShowSearchInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
      child: new TextField(
        controller: searchController,
        maxLines: 1,
        focusNode: _searchNameFocus,
        textInputAction: TextInputAction.next,
        autofocus: true,
        onSubmitted: (term) {
          _searchNameFocus.unfocus();
        },
        style: new TextStyle(
            fontFamily: UtilsImporter().stringUtils.HKGrotesk,
            fontWeight: FontWeight.w500,
            fontSize: 16.0,
            color: Theme.of(context).primaryColorDark),
        decoration: InputDecoration(
            labelText: UtilsImporter().stringUtils.full_name,
            labelStyle: TextStyle(
              color: UtilsImporter().colorUtils.greycolor,
              fontFamily: UtilsImporter().stringUtils.HKGrotesk,
            ),
            border: new UnderlineInputBorder(
                borderSide: new BorderSide(
                    color: UtilsImporter().colorUtils.primarycolor))),
      ),
    );
  }

  // 1
  Widget _showSearchTxtFld() {
    final GestureDetector searchButtonWithGesture = new GestureDetector(
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
        child: new Container(
          height: 40.0,
          decoration: new BoxDecoration(
              color: Colors.white,
              borderRadius: new BorderRadius.all(Radius.circular(6.0))),
          child: TextField(
            controller: _searchController,
            onSubmitted: (_) {
              Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (context) => new ProductsView(
                            queryString: _searchController.text,
                            categoryId: "0",
                          )));
            },
            cursorColor: UtilsImporter().colorUtils.primarycolor,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.search),
              contentPadding: const EdgeInsets.only(bottom: 0.5),
              hintText: "بحث",
              hintStyle: TextStyle(
                fontFamily: UtilsImporter().stringUtils.HKGrotesk,
              ),
            ),
          ),
        ),
      ),
    );

    return new Padding(
        padding: EdgeInsets.only(left: 0.0, right: 0.0, top: 5.0),
        child: searchButtonWithGesture);
  }

  Widget _ImageCarousel() {
    return new Container(
      // height: 200.0,
      height: MediaQuery.of(context).size.height * 0.30,

      decoration: new BoxDecoration(
          color: UtilsImporter().colorUtils.searchgreycolor,
          borderRadius: new BorderRadius.all(Radius.circular(20.0))),
      child: new Carousel(
        borderRadius: true,
        boxFit: BoxFit.fill,
        images: LoadingScreenServices.bannerListNetwork,
        autoplay: true,
        animationCurve: Curves.fastLinearToSlowEaseIn,
        animationDuration: Duration(milliseconds: 1000),
        dotSize: 6.0,
        indicatorBgPadding: 2.0,
      ),
    );
  }
}
