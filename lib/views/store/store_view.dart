import 'package:carousel_pro/carousel_pro.dart';
import 'package:kammun_app/views/loading/loading_services.dart';
import 'package:kammun_app/views/store/store_view_category_grid.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/core_importer.dart';
import '../../core/firebase_init.dart';
import '../management_view/management_view.dart';

class StoreView extends StatefulWidget {
  const StoreView({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => StoreViewState();
}

class StoreViewState extends State<StoreView> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController searchController = TextEditingController();

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
    if (Services.updateOption)
      WidgetsBinding.instance.addPostFrameCallback((_) => showUpdateDialog());
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
                  bottomRight: Radius.circular(2.0))),
          contentPadding:
              const EdgeInsets.only(top: 10, bottom: 0, right: 10, left: 10),
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
                        'تحديث متوفر',
                        style: TextStyle(
                            fontSize: 17,
                            color: ColorUtils.primaryColor,
                            fontWeight: FontWeight.bold,
                            fontFamily: StringUtils.fontFamily),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        setState(() => Services.updateOption = false);
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
                        text: 'إصدار جديد من التطبيق اصبح متوفراً ! ',
                        style: TextStyle(
                            color: Colors.grey[900],
                            fontSize: 20,
                            fontWeight: FontWeight.normal,
                            fontFamily: StringUtils.fontFamily),
                      ),
                    ],
                  ),
                ),
                const Padding(padding: EdgeInsets.only(top: 10)),
                Divider(color: Colors.grey[600]),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 2.8,
                      child: KammunButton(
                          text: ' التحديث الآن ',
                          height: 50,
                          color: ColorUtils.kmColors,
                          onTap: _updateApplication),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 2.8,
                      child: KammunButton(
                        text: ' التحديث لاحقاً ',
                        height: 50,
                        color: Colors.grey[700],
                        onTap: () {
                          setState(() => Services.updateOption = false);
                          Navigator.of(context).pop(true);
                        },
                      ),
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

  _shareApp() {
    String infoMessage =
        'تطبيق كمّون لتوصيل المنتجات الغذائية لباب بيتك و بأسعار منافسة\n';
    String androidGrating = '\n لتحميل التطبيق على الأندوريد \n';

    String androidUrl = androidGrating + LoadingScreenServices.androidShareUrl;
    String iosGrating = '\n لتحميل التطبيق على الآيفون \n';
    String iPhoneUrl = iosGrating + LoadingScreenServices.iOSShareUrl;

    Share.share(infoMessage + androidUrl + iPhoneUrl);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      drawer: KDrawer(
        children: [
          SideBarRow(
              icon: Icons.phone,
              text: 'الإتصال بكمون',
              onTap: () => Services.openUrl('number')),
          SideBarRow(
              icon: Icons.share,
              text: 'إرسال التطبيق للأصدقاء',
              onTap: () => _shareApp()),
          SideBarRow(
              icon: Icons.person,
              text: StringUtils.profile,
              onTap: () => Navigator.of(context).pushNamed('/profile')),
          if (Services.isOperationManager())
            SideBarRow(
                icon: Icons.supervisor_account_sharp,
                text: 'فريق التوصيل',
                onTap: () =>
                    Navigator.of(context).pushNamed('/ShopperManagementView')),
          if (Services.isShopper())
            SideBarRow(
                icon: Icons.featured_play_list,
                text: 'كشف حساب المتسوق',
                onTap: () =>
                    Navigator.of(context).pushNamed('/ShopperTransactionView')),
          if (Services.isAccounting())
            SideBarRow(
              text: StringUtils.financial,
              icon: Icons.account_balance,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ManagementView(
                    title: StringUtils.financial,
                    children: [
                      SideBarRow(
                          icon: Icons.featured_play_list,
                          text: 'كشف حساب المتسوق',
                          onTap: () => Navigator.of(context)
                              .pushNamed('/AccountantTransactionView')),
                      SideBarRow(
                          icon: Icons.money,
                          text: StringUtils.addTransaction,
                          onTap: () => Navigator.of(context)
                              .pushNamed('/AddTransactionView')),
                      SideBarRow(
                          icon: Icons.account_balance_wallet_outlined,
                          text: 'أرصدة الموردين',
                          onTap: () => Navigator.of(context)
                              .pushNamed('/SupplierAccounts')),
                      SideBarRow(
                          icon: Icons.delivery_dining_rounded,
                          text: 'معلومات المتسوقين',
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const ShopperInformation()))),
                    ],
                  ),
                ),
              ),
            ),
          if (Services.isSupplierManager())
            SideBarRow(
                icon: Icons.account_balance,
                text: 'كشف حساب المورد',
                onTap: () =>
                    Navigator.of(context).pushNamed('/SupplierAccounts')),
          Services.isSupplierManager() ||
                  Services.isProductsController() ||
                  Services.isAdmin()
              ? SideBarRow(
                  icon: Icons.inventory,
                  text: 'إدارة المستودعات',
                  onTap: () => Navigator.of(context)
                      .pushNamed('/subWarehouseManagement'))
              : Container(),
          if (Services.isProductsController())
            SideBarRow(
              text: StringUtils.productManagement,
              icon: Icons.category,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ManagementView(
                      title: StringUtils.productManagement,
                      children: [
                        SideBarRow(
                            icon: Icons.category,
                            text: 'المنتجات المضافة للمستودع',
                            onTap: () => Navigator.of(context)
                                .pushNamed('/products_added_to_warehouse')),
                        SideBarRow(
                            icon: Icons.category_outlined,
                            text: 'المنتجات الغير مضافة للمستودع',
                            onTap: () => Navigator.of(context)
                                .pushNamed('/products_not_added_to_warehouse')),
                        Services.isAdmin()
                            ? SideBarRow(
                                icon: Icons.category_rounded,
                                text: 'جميع المنتجات',
                                onTap: () => Navigator.of(context)
                                    .pushNamed('/all_products'))
                            : Container(),
                        SideBarRow(
                            icon: Icons.fact_check,
                            text: StringUtils.inventory,
                            onTap: () =>
                                Navigator.of(context).pushNamed('/Inventory')),
                        SideBarRow(
                            icon: Icons.filter_list_sharp,
                            text: 'فلترة المنتجات',
                            onTap: () => Navigator.of(context)
                                .pushNamed('/products_filter')),
                      ],
                    ),
                  ),
                );
              },
            ),
          if (Services.isAdmin() || Services.isSuperAdmin())
            SideBarRow(
              text: StringUtils.adminPanel,
              icon: Icons.admin_panel_settings,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ManagementView(
                          title: StringUtils.adminPanel,
                          children: [
                            SideBarRow(
                                icon: Icons.table_view_rounded,
                                text: 'تقرير المبيعات',
                                onTap: () => Navigator.of(context)
                                    .pushNamed('/sales_reports')),
                            SideBarRow(
                                icon: Icons.insert_chart_outlined_rounded,
                                text: 'إحصائيات المبيعات',
                                onTap: () => Navigator.of(context)
                                    .pushNamed('/sales_charts')),
                            SideBarRow(
                                icon: Icons.payment,
                                text: 'الأرباح والمستحقات المالية',
                                onTap: () => Navigator.of(context)
                                    .pushNamed('/financial_report_view')),
                            SideBarRow(
                                icon: Icons.attach_money,
                                text: 'تغير الأسعار',
                                onTap: () => Navigator.of(context)
                                    .pushNamed('/priceChange')),
                          ],
                        )),
              ),
            ),
          SideBarRow(
              icon: Icons.logout,
              text: 'تسجيل الخروج',
              onTap: () async => await Services.logOutAdmin(context)),
          Divider(color: ColorUtils.kmColors, height: 20),
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: const <Widget>[
                  MediaIcon(icon: FontAwesomeIcons.facebookF, url: 'facebook'),
                  MediaIcon(icon: FontAwesomeIcons.instagram, url: 'instagram'),
                  MediaIcon(
                      icon: FontAwesomeIcons.facebookMessenger,
                      url: 'messenger'),
                  MediaIcon(icon: FontAwesomeIcons.whatsapp, url: 'whatsapp'),
                ],
              ),
            ),
          ),
        ],
      ),
      appBar: PreferredSize(
        child: AppBar(
          iconTheme: const IconThemeData(color: Colors.transparent),
          backgroundColor: Services.isShopper()
              ? Services.shopper.status == 1
                  ? ColorUtils.kmColors
                  : ColorUtils.searchGreyColor
              : ColorUtils.kmColors,
          automaticallyImplyLeading: false,
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
                          onTap: () => scaffoldKey.currentState.openDrawer(),
                          child: const Icon(Icons.menu,
                              color: Colors.white, size: 40)),
                    ),
                    const AppBarKammunImage(),
                    Services.isShopper()
                        ? Switch(
                            activeColor: Colors.white,
                            value: Services.shopper.status == 1,
                            onChanged: (value) async {
                              bool success =
                                  await Services.changeShopperStatusService(
                                      shopperId: Services.shopper.id.toString(),
                                      newStatus: Services.shopper.status == 1
                                          ? '0'
                                          : '1');
                              if (success) {
                                setState(() => Services.shopper.status =
                                    Services.shopper.status == 1 ? 0 : 1);
                              } else {
                                Toast.show('يرجى الاتصال بالإنترنت', context,
                                    duration: Toast.LENGTH_LONG,
                                    gravity: Toast.CENTER);
                              }
                            },
                          )
                        : Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: IconButton(
                              icon: const Icon(Icons.shopping_cart,
                                  size: 35, color: Colors.white),
                              onPressed: () => Navigator.of(context)
                                  .pushNamedAndRemoveUntil(
                                      '/cart', (Route<dynamic> route) => false),
                            ),
                          ),
                  ],
                ),
                StoreSearchTextField(
                    searchController: searchController,
                    scaffoldKey: scaffoldKey),
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
                              border:
                                  Border.all(color: Colors.white, width: 2.0),
                              borderRadius: BorderRadius.circular(10.0)),
                          height: 10)),
                  Text(
                    '  ' + StringUtils.shopByCategory + '  ',
                    style: TextStyle(
                        color: ColorUtils.primaryColor,
                        fontWeight: FontWeight.w900,
                        fontFamily: StringUtils.fontFamily,
                        fontSize: 22),
                  ),
                  Expanded(
                      child: Container(
                          decoration: BoxDecoration(
                              color: ColorUtils.kmColors,
                              border:
                                  Border.all(color: Colors.white, width: 2.0),
                              borderRadius: BorderRadius.circular(10.0)),
                          height: 10)),
                ],
              ),
              const SizedBox(height: 20),
              const StoreViewCategory(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _imageCarousel() {
    return Container(
        height: MediaQuery.of(context).size.height * 0.30,
        decoration: BoxDecoration(
            color: ColorUtils.searchGreyColor,
            borderRadius: const BorderRadius.all(Radius.circular(20.0))),
        child: FirebaseInitPage(
          child: Carousel(
            borderRadius: true,
            boxFit: BoxFit.fill,
            images: LoadingScreenServices.bannerListNetwork,
            autoplay: true,
            animationCurve: Curves.fastLinearToSlowEaseIn,
            animationDuration: const Duration(milliseconds: 1000),
            dotSize: 6.0,
            indicatorBgPadding: 2.0,
          ),
        ));
  }
}
