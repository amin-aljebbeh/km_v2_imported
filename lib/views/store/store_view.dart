import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:kammun_app/utils/utils_importer.dart';
import 'package:kammun_app/views/widget/widgets_importer.dart';
import 'package:kammun_app/views/loading/loading.dart';
import 'package:kammun_app/views/loading/loading_services.dart';
import 'package:kammun_app/views/store/store_view_category_grid.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../service.dart';

class StoreView extends StatefulWidget {
  const StoreView({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return StoreViewState();
  }
}

class StoreViewState extends State<StoreView> {
  TextEditingController searchController = TextEditingController();
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

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
      WidgetsBinding.instance.addPostFrameCallback((_) => Services.showUpdateOrderInstruction(context: context));
    }
  }

  Widget _updateButton() {
    final GestureDetector loginButtonWithGesture = GestureDetector(
      onTap: () => _updateApplication(),
      child: Container(
        height: 50.0,
        decoration:
            BoxDecoration(color: ColorUtils.kmColors, borderRadius: const BorderRadius.all(Radius.circular(6.0))),
        child: Center(
          child: Text(
            " التحديث الآن ",
            style: TextStyle(
                color: Colors.white,
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                fontFamily: StringUtils.fontFamilyHKGrotesk),
          ),
        ),
      ),
    );

    return Padding(
        padding: const EdgeInsets.only(left: 0.0, right: 0.0, top: 10.0), child: loginButtonWithGesture);
  }

  Widget _cancelButton() {
    final GestureDetector loginButtonWithGesture = GestureDetector(
      onTap: () {
        setState(() {
          Services.updateOption = false;
        });
        Navigator.of(context).pop(true);
      },
      child: Container(
        height: 50.0,
        decoration:
            BoxDecoration(color: Colors.grey[700], borderRadius: const BorderRadius.all(Radius.circular(6.0))),
        child: Center(
          child: Text(
            " التحديث لاحقاً ",
            style: TextStyle(
                color: Colors.white,
                fontSize: 20.0,
                fontWeight: FontWeight.w500,
                fontFamily: StringUtils.fontFamilyHKGrotesk),
          ),
        ),
      ),
    );

    return Padding(
        padding: const EdgeInsets.only(left: 0.0, right: 0.0, top: 10.0), child: loginButtonWithGesture);
  }

  void showUpdateDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(1.0),
              topRight: Radius.circular(1.0),
              bottomLeft: Radius.circular(2.0),
              bottomRight: Radius.circular(2.0),
            ),
          ),
          contentPadding: const EdgeInsets.only(top: 10, bottom: 0, right: 10, left: 10),
          titlePadding: const EdgeInsets.all(0),
          title: Container(
            width: double.infinity,
            height: 50,
            color: const Color.fromARGB(255, 247, 247, 247),
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
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        setState(() {
                          Services.updateOption = false;
                        });
                        Navigator.of(context).pop(true);
                      },
                    )
                  ],
                ),
                padding: const EdgeInsets.only(left: 10),
              ),
            ),
          ),
          content: SizedBox(
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
                const Padding(
                  padding: EdgeInsets.only(top: 10),
                ),
                Divider(
                  color: Colors.grey[600],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 2.8,
                      child: _updateButton(),
                    ),
                    SizedBox(
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      drawer: const KDrawer(),
      appBar: PreferredSize(
        child: AppBar(
          iconTheme: const IconThemeData(color: Colors.transparent),

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
                          child: const Icon(
                            Icons.menu,
                            color: Colors.white,
                            size: 40,
                          ),
                        ),
                      ),
                      const AppBarKammunImage(),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: IconButton(
                          icon: const Icon(
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
        preferredSize: const Size.fromHeight(105.0),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _imageCarousel(),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: ColorUtils.kmColors,
                          border: Border.all(color: Colors.white, width: 2.0),
                          borderRadius: BorderRadius.circular(10.0),
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
                        decoration: BoxDecoration(
                          color: ColorUtils.kmColors,
                          border: Border.all(color: Colors.white, width: 2.0),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        height: 10,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const StoreViewCategory(),
              ],
            )),
      ),
    );
  }

  Widget _imageCarousel() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.20,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          color: ColorUtils.searchGreyColor, borderRadius: const BorderRadius.all(Radius.circular(20.0))),
      child: Carousel(
        borderRadius: true,
        boxFit: BoxFit.cover,
        images: LoadingScreenServices.bannerListNetwork,
        autoplay: true,
        animationCurve: Curves.fastLinearToSlowEaseIn,
        animationDuration: const Duration(milliseconds: 1000),
        dotSize: 6.0,
        indicatorBgPadding: 2.0,
        dotBgColor: Colors.transparent,
      ),
    );
  }
}
