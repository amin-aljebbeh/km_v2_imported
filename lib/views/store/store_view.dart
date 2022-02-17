import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:kammun_app/utils/utils_importer.dart';
import 'package:kammun_app/views/widget/widgets_importer.dart';
import 'package:kammun_app/views/loading/Loading.dart';
import 'package:kammun_app/views/loading/LoadingServices.dart';
import 'package:kammun_app/views/store/store_view_category_grid.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../Services.dart';

class StoreView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return StoreViewState();
  }
}

class StoreViewState extends State<StoreView> {
  TextEditingController searchController = new TextEditingController();
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  bool isDarkThemeMode = false;

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

    bool isThereOrderUnderUpdate = false;
    for (int i = 0; i < LoadingScreenServices.myOrdersList.length; i++) {
      if (LoadingScreenServices.myOrdersList[i].underUpdate == "1" &&
          int.parse(LoadingScreenServices.myOrdersList[i].orderStatusId) < 3) {
        isThereOrderUnderUpdate = true;
      }
    }
    if (Services.updateOption) WidgetsBinding.instance.addPostFrameCallback((_) => showUpdateDialog());

    if (isThereOrderUnderUpdate) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _showUpdateOrderInstruction(context: context));
    }
  }

  Widget _updateButton() {
    final GestureDetector loginButtonWithGesture = new GestureDetector(
      onTap: () => _updateApplication(),
      child: new Container(
        height: 50.0,
        decoration: new BoxDecoration(
            color: ColorUtils.kmColors, borderRadius: new BorderRadius.all(Radius.circular(6.0))),
        child: new Center(
          child: new Text(
            " التحديث الآن ",
            style: new TextStyle(
                color: Colors.white,
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                fontFamily: StringUtils.fontFamilyHKGrotesk),
          ),
        ),
      ),
    );

    return Padding(padding: EdgeInsets.only(left: 0.0, right: 0.0, top: 10.0), child: loginButtonWithGesture);
  }

  Widget _okButton() {
    final GestureDetector loginButtonWithGesture = new GestureDetector(
      onTap: () => Navigator.of(context).pop(),
      child: new Container(
        height: 50.0,
        decoration: new BoxDecoration(
            color: ColorUtils.primaryColor, borderRadius: new BorderRadius.all(Radius.circular(6.0))),
        child: new Center(
          child: new Text(
            "موافق",
            style: new TextStyle(
                color: Colors.white,
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                fontFamily: StringUtils.fontFamilyHKGrotesk),
          ),
        ),
      ),
    );

    return Padding(padding: EdgeInsets.only(left: 0.0, right: 0.0, top: 10.0), child: loginButtonWithGesture);
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
        decoration:
            new BoxDecoration(color: Colors.grey[700], borderRadius: new BorderRadius.all(Radius.circular(6.0))),
        child: new Center(
          child: new Text(
            " التحديث لاحقاً ",
            style: new TextStyle(
                color: Colors.white,
                fontSize: 20.0,
                fontWeight: FontWeight.w500,
                fontFamily: StringUtils.fontFamilyHKGrotesk),
          ),
        ),
      ),
    );

    return Padding(padding: EdgeInsets.only(left: 0.0, right: 0.0, top: 10.0), child: loginButtonWithGesture);
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
          contentPadding: EdgeInsets.only(top: 10, bottom: 0, right: 10, left: 10),
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
                            color: ColorUtils.primaryColor,
                            fontWeight: FontWeight.bold,
                            fontFamily: StringUtils.fontFamilyHKGrotesk),
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
                            fontFamily: StringUtils.fontFamilyHKGrotesk),
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
                            fontFamily: StringUtils.fontFamilyHKGrotesk,
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
                            fontFamily: StringUtils.fontFamilyHKGrotesk,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      drawer: KDrawer(),
      appBar: PreferredSize(
        child: AppBar(
          iconTheme: new IconThemeData(color: Colors.transparent),

          backgroundColor: ColorUtils.kmColors,
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
                            scaffoldKey.currentState.openDrawer();
                          },
                          child: Icon(
                            Icons.menu,
                            color: Colors.white,
                            size: 40,
                          ),
                        ),
                      ),
                      AppBarKammunImage(),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: IconButton(
                          icon: Icon(
                            Icons.shopping_cart,
                            size: 35,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            Navigator.of(context)
                                .pushNamedAndRemoveUntil('/cart', (Route<dynamic> route) => false);
                          },
                        ),
                      ),
                    ]),
                StoreSearchTextField(
                  scaffoldKey: scaffoldKey,
                  searchController: searchController,
                ),
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
                  _imageCarousel(),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          decoration: new BoxDecoration(
                            color: ColorUtils.kmColors,
                            border: new Border.all(color: Colors.white, width: 2.0),
                            borderRadius: new BorderRadius.circular(10.0),
                          ),
                          height: 10,
                        ),
                      ),
                      Text(
                        "  " + StringUtils.shopByCategory + "  ",
                        style: TextStyle(
                            color: ColorUtils.primaryColor,
                            fontWeight: FontWeight.w900,
                            fontFamily: StringUtils.fontFamilyHKGrotesk,
                            fontSize: 22),
                      ),
                      Expanded(
                        child: Container(
                          decoration: new BoxDecoration(
                            color: ColorUtils.kmColors,
                            border: new Border.all(color: Colors.white, width: 2.0),
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

  Widget _imageCarousel() {
    return new Container(
      height: MediaQuery.of(context).size.height * 0.25,
      decoration: new BoxDecoration(
          color: ColorUtils.searchGreyColor, borderRadius: new BorderRadius.all(Radius.circular(20.0))),
      child: new Carousel(
        borderRadius: true,
        boxFit: BoxFit.cover,
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
