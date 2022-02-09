import 'package:flutter/material.dart';
import 'package:kammun_app/utils/utils_importer.dart';
import 'package:kammun_app/views/Wedgit/AlertMessages.dart';
import 'package:kammun_app/views/Wedgit/widgets_importer.dart';
import 'package:kammun_app/views/loading/LoadingServices.dart';
import 'package:kammun_app/views/restart/kammunapp_restart.dart';
import 'package:kammun_app/views/supported_city/services/supported_city_services.dart';

class SupportedCityWidget extends StatefulWidget {
  @override
  _SupportedCityWidgetState createState() => _SupportedCityWidgetState();
}

class _SupportedCityWidgetState extends State<SupportedCityWidget> {
  TextEditingController _searchBarController = new TextEditingController();
  String filter;
  bool isLoading = false;
  bool isError = false;
  String errorMessage = "حدث خطأ أثناء محاولة جلب البيانات يرجى التحقق من إتصالك بالإانترنت و المحاولة مجدداً";

  Widget _showSearchTxtFld() {
    final GestureDetector searchButtonWithGesture = new GestureDetector(
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
        child: new Container(
          height: 40.0,
          decoration:
              new BoxDecoration(color: Colors.white, borderRadius: new BorderRadius.all(Radius.circular(6.0))),
          child: TextField(
            controller: _searchBarController,
            onSubmitted: (_) {},
            cursorColor: ColorUtils.primaryColor,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.search),
              contentPadding: const EdgeInsets.only(top: 4.0),
              hintText: "ابحث عن منطقتك",
              hintStyle: TextStyle(
                fontFamily: StringUtils.fontFamilyHKGrotesk,
              ),
            ),
          ),
        ),
      ),
    );

    return new Padding(padding: EdgeInsets.only(left: 0.0, right: 0.0, top: 5.0), child: searchButtonWithGesture);
  }

  @override
  void initState() {
    super.initState();

    _getSupportedCity();

    _searchBarController.addListener(() {
      setState(() {
        filter = _searchBarController.text;
      });
    });
  }

  void _showDialog({title, body}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text(
            "$title",
            style: TextStyle(
              fontFamily: StringUtils.fontFamilyHKGrotesk,
            ),
          ),
          content: new Text(
            "$body",
            style: TextStyle(
              fontFamily: StringUtils.fontFamilyHKGrotesk,
            ),
          ),
          scrollable: true,
          actions: <Widget>[
            new FlatButton(
              child: new Text(
                "إغلاق",
                style: TextStyle(fontFamily: StringUtils.fontFamilyHKGrotesk),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  _getSupportedCity() async {
    setState(() {
      isLoading = true;
    });

    bool success = await LoadingScreenServices().getSupportedCity();

    if (success) {
      setState(() {
        isLoading = false;
        isError = false;
      });
      WidgetsBinding.instance.addPostFrameCallback((_) => _showDialog(
          title: 'يرجى إختيار أقرب منطقة إليك',
          body:
              "بالقائمة التالية تجد المناطق المدعومة للتوصيل ضمن كمّون إذا كانت منطقتكم غير مدعومة بعد لا تقلق بإمكانك اختيار اي منطقة قريبة إليك والإستفادة من خدمة متابعة أسعار المواد الغذائية والإستهلاكية بشكل مستمر و سوف يقوم تطبيق كمّون بالتوسع قريبا و دعم مناطق متعددة"));
    } else {
      setState(() {
        isLoading = false;
        isError = true;
        errorMessage = "حدث خطأ أثناء محاولة جلب البيانات يرجى التحقق من إتصالك بالإانترنت و المحاولة مجدداً";
      });
    }
  }

  _updateUserSupportedCity({String supportedCityId}) async {
    setState(() {
      isLoading = true;
    });

    bool success = await SupportedCityServices.updateUserSupportedCity(supportedCityId: supportedCityId);
    if (success) {
      setState(() {
        isLoading = false;
        isError = false;
      });
      KammunRestart.restartApp(context);
    } else {
      setState(() {
        isLoading = false;
        isError = true;
        errorMessage =
            "حدث خطأ أثناء محاولتك إختيار المدينة الأقرب إليك يرجى التأكد من إتصالك بالإانترنت و المحاولة مجدداً";
      });
    }
  }

  @override
  void dispose() {
    _searchBarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: _showSearchTxtFld(),
      ),
      body: Container(
        padding: EdgeInsets.only(top: 20),
        child: isLoading
            ? Center(child: Loader())
            : Column(
                children: [
                  isError
                      ? AlertMessages(
                          text: errorMessage,
                          messageType: "internetError",
                          headerText: "حدث خطأ",
                        )
                      : Container(),
                  Expanded(
                    child: ListView.builder(
                      itemCount: LoadingScreenServices.supportedCityOriginal.data.length,
                      itemBuilder: (BuildContext context, int index) {
                        return filter == null || filter == ""
                            ? GestureDetector(
                                onTap: () {
                                  _updateUserSupportedCity(
                                      supportedCityId:
                                          LoadingScreenServices.supportedCityOriginal.data[index].id.toString());
                                },
                                behavior: HitTestBehavior.translucent,
                                child: SupportedCityCardView(
                                  name: LoadingScreenServices.supportedCityOriginal.data[index].name,
                                  id: LoadingScreenServices.supportedCityOriginal.data[index].id,
                                  isActive: LoadingScreenServices.supportedCityOriginal.data[index].isActive,
                                  deliveryPrice: LoadingScreenServices
                                      .supportedCityOriginal.data[index].deliveryPrice
                                      .split(".")[0],
                                  supportPhoneNumber:
                                      LoadingScreenServices.supportedCityOriginal.data[index].supportPhoneNumber,
                                  maintenanceMessages:
                                      LoadingScreenServices.supportedCityOriginal.data[index].maintenanceMessages,
                                ),
                              )
                            : LoadingScreenServices.supportedCityOriginal.data[index].name
                                    .toLowerCase()
                                    .contains(filter.toLowerCase())
                                ? GestureDetector(
                                    onTap: () {
                                      _updateUserSupportedCity(
                                          supportedCityId: LoadingScreenServices
                                              .supportedCityOriginal.data[index].id
                                              .toString());
                                    },
                                    behavior: HitTestBehavior.translucent,
                                    child: SupportedCityCardView(
                                      name: LoadingScreenServices.supportedCityOriginal.data[index].name,
                                      id: LoadingScreenServices.supportedCityOriginal.data[index].id,
                                      isActive: LoadingScreenServices.supportedCityOriginal.data[index].isActive,
                                      deliveryPrice:
                                          LoadingScreenServices.supportedCityOriginal.data[index].deliveryPrice,
                                      supportPhoneNumber: LoadingScreenServices
                                          .supportedCityOriginal.data[index].supportPhoneNumber,
                                      maintenanceMessages: LoadingScreenServices
                                          .supportedCityOriginal.data[index].maintenanceMessages,
                                    ),
                                  )
                                : Container();
                      },
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

//TODO
class SupportedCityCardView extends StatefulWidget {
  final int id;
  final String name;
  final String deliveryPrice;
  final String isActive;
  final String supportPhoneNumber;
  final String maintenanceMessages;

  SupportedCityCardView({
    this.id,
    this.name,
    this.deliveryPrice,
    this.isActive,
    this.supportPhoneNumber,
    this.maintenanceMessages,
  });

  @override
  State<StatefulWidget> createState() {
    return SupportedCityCardViewState();
  }
}

class SupportedCityCardViewState extends State<SupportedCityCardView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColorLight,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                    child: Container(
                  child: Wrap(
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Wrap(
                            children: <Widget>[
                              Center(
                                child: Text(
                                  widget.name,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontFamily: StringUtils.fontFamilyHKGrotesk,
                                      fontSize: 18),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Center(
                            child: Wrap(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text("إجرة التوصيل:",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          color: ColorUtils.primaryColor,
                                          fontFamily: StringUtils.fontFamilyHKGrotesk,
                                          fontSize: 18)),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(widget.deliveryPrice,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          color: ColorUtils.primaryColor,
                                          fontFamily: StringUtils.fontFamilyHKGrotesk,
                                          fontSize: 18)),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                )),
              ],
            ),
          ),
          SizedBox(height: 4),
          Divider(
            color: ColorUtils.primaryColor,
            thickness: 2.5,
          )
        ],
      ),
    );
  }
}
