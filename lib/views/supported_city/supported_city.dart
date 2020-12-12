import 'package:flutter/material.dart';
import 'package:kammun_app/utils/utils_importer.dart';
import 'package:kammun_app/views/loading/LoadingServices.dart';
import 'package:kammun_app/views/login/login_view.dart';

class SupportedCity extends StatefulWidget {
  @override
  _SupportedCityState createState() => _SupportedCityState();
}

class _SupportedCityState extends State<SupportedCity> {
  TextEditingController _searchBarController = new TextEditingController();
  String filter;
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
            controller: _searchBarController,
            onSubmitted: (_) {
              // Navigator.push(
              //     context,
              //     new MaterialPageRoute(
              //         builder: (context) => new ProductsView(
              //               queryString: _searchController.text,
              //               categoryId: "0",
              //             )));
            },
            cursorColor: UtilsImporter().colorUtils.primarycolor,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.search),
              contentPadding: const EdgeInsets.only(top: 4.0),
              hintText: "ابحث عن منطقتك",
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

  @override
  void initState() {
    super.initState();

    _searchBarController.addListener(() {
      setState(() {
        filter = _searchBarController.text;
      });
    });
  }

  @override
  void dispose() {
    _searchBarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("------ supported city name ------");
    print(LoginScreen.selectedValue);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: _showSearchTxtFld(),
      ),
      body: Container(
        padding: EdgeInsets.only(top: 20),
        child: ListView.builder(
          itemCount: LoadingScreenServices.supportedCityOriginal.data.length,
          itemBuilder: (BuildContext context, int index) {
            return filter == null || filter == ""
                ? GestureDetector(
                    onTap: () {
                      setState(() {
                        LoginScreen.selectedValue = LoadingScreenServices
                            .supportedCityOriginal.data[index].name;
                      });
                    },
                    behavior: HitTestBehavior.translucent,
                    child: SupportedCityCardView(
                      name: LoadingScreenServices
                          .supportedCityOriginal.data[index].name,
                      id: LoadingScreenServices
                          .supportedCityOriginal.data[index].id,
                      isActive: LoadingScreenServices
                          .supportedCityOriginal.data[index].isActive,
                      deliveryPrice: LoadingScreenServices
                          .supportedCityOriginal.data[index].deliveryPrice,
                      supportPhoneNumber: LoadingScreenServices
                          .supportedCityOriginal.data[index].supportPhoneNumber,
                      maintenanceMessages: LoadingScreenServices
                          .supportedCityOriginal
                          .data[index]
                          .maintenanceMessages,
                    ),
                  )
                : LoadingScreenServices.supportedCityOriginal.data[index].name
                        .toLowerCase()
                        .contains(filter.toLowerCase())
                    ? GestureDetector(
                        onTap: () {
                          setState(() {
                            LoginScreen.selectedValue = LoadingScreenServices
                                .supportedCityOriginal.data[index].name;
                          });
                          Navigator.of(context).pushNamedAndRemoveUntil(
                            LoginScreen.routeName,
                            (Route<dynamic> route) => false,
                          );
                        },
                        behavior: HitTestBehavior.translucent,
                        child: SupportedCityCardView(
                          name: LoadingScreenServices
                              .supportedCityOriginal.data[index].name,
                          id: LoadingScreenServices
                              .supportedCityOriginal.data[index].id,
                          isActive: LoadingScreenServices
                              .supportedCityOriginal.data[index].isActive,
                          deliveryPrice: LoadingScreenServices
                              .supportedCityOriginal.data[index].deliveryPrice,
                          supportPhoneNumber: LoadingScreenServices
                              .supportedCityOriginal
                              .data[index]
                              .supportPhoneNumber,
                          maintenanceMessages: LoadingScreenServices
                              .supportedCityOriginal
                              .data[index]
                              .maintenanceMessages,
                        ),
                      )
                    : Container();
          },
        ),
      ),
    );
  }
}

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
      // decoration: BoxDecoration(
      //     borderRadius: BorderRadius.only(
      //         Radius.circular(10.0) //                 <--- border radius here
      //         ),
      //     border: Border.all(
      //         color: UtilsImporter().colorUtils.primarycolor, width: 2)),
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
                                      fontFamily:
                                          UtilsImporter().stringUtils.HKGrotesk,
                                      fontSize: 18),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Center(
                            child: Text(widget.deliveryPrice,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color:
                                        UtilsImporter().colorUtils.primarycolor,
                                    fontFamily:
                                        UtilsImporter().stringUtils.HKGrotesk,
                                    fontSize: 18)),
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
            color: UtilsImporter().colorUtils.primarycolor,
            thickness: 2.5,
          )
        ],
      ),
    );
  }
}
