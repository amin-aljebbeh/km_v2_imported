import 'package:flutter/material.dart';
import 'package:kammun_app/utils/Loader.dart';
import 'package:kammun_app/utils/utils_importer.dart';
import 'package:kammun_app/views/Wedgit/AlertMessagess.dart';
import 'package:kammun_app/views/add_address/add_address_view.dart';
import 'package:kammun_app/views/cart/CartViewFinal.dart';
import 'package:kammun_app/views/loading/LoadingServices.dart';
import 'package:kammun_app/views/orders/services/order_services.dart';
import 'package:toast/toast.dart';
import '../../Services.dart';
import 'delivery_method.dart';

class DeliverToView extends StatefulWidget {
  static int selectedIndex;

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return DeliverToViewState();
  }
}

class DeliverToViewState extends State<DeliverToView> {
  bool isLoading = false;
  bool isError = false;
  void onrRemove(item) async {
    setState(() {
      isLoading = true;
      isError = false;
    });
    bool addressDeleted = await Services.removeUserAddress(
        LoadingScreenServices.userAddress[item].id.toString());

    if (addressDeleted) {
      setState(() {
        LoadingScreenServices.userAddress.removeAt(item);

        if (DeliverToView.selectedIndex != null &&
            DeliverToView.selectedIndex > 0) DeliverToView.selectedIndex--;
      });
      isLoading = false;
      isError = false;
    } else {
      setState(() {
        isLoading = false;
        isError = true;
      });
    }
  }

  void changeSelectedAddress(item) {
    setState(() {
      DeliverToView.selectedIndex = item;
      OrderServices.delivery_supported_City_id = LoadingScreenServices
          .userAddress[DeliverToView.selectedIndex].supportedCityId
          .toString();
      Services.delivery_Price = LoadingScreenServices
                  .userAddress[DeliverToView.selectedIndex].deliveryPrice ==
              null
          ? 500
          : LoadingScreenServices
              .userAddress[DeliverToView.selectedIndex].deliveryPrice;
    });
  }

  Column cardBody(int index, BuildContext context) {
    return Column(children: <Widget>[
      InkWell(
        onTap: () {
          changeSelectedAddress(index);
        },
        child: Padding(
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
                      InkWell(
                        onTap: () {
                          changeSelectedAddress(index);
                        },
                        child: Icon(
                            DeliverToView.selectedIndex == index
                                ? Icons.radio_button_checked
                                : Icons.radio_button_unchecked,
                            color: DeliverToView.selectedIndex == index
                                ? UtilsImporter().colorUtils.primarycolor
                                : UtilsImporter().colorUtils.greycolor),
                      ),
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
                      // RaisedButton(
                      //     child: Text(UtilsImporter().stringUtils.delete,
                      //         style: TextStyle(
                      //             fontWeight: FontWeight.w400,
                      //             color: UtilsImporter().colorUtils.greycolor,
                      //             fontFamily:
                      //                 UtilsImporter().stringUtils.HKGrotesk,
                      //             fontSize: 15)),
                      //     onPressed: () {
                      //       onrRemove(index);
                      //     }),

                      _showEidte(index: index),
                      // RaisedButton(
                      //   child: Text(UtilsImporter().stringUtils.edit_address,
                      //       style: TextStyle(
                      //           fontWeight: FontWeight.w400,
                      //           color: UtilsImporter().colorUtils.greycolor,
                      //           fontFamily:
                      //               UtilsImporter().stringUtils.HKGrotesk,
                      //           fontSize: 15)),
                      //   onPressed: () {
                      //     Navigator.push(
                      //         context,
                      //         new MaterialPageRoute(
                      //             builder: (context) => new AddAddressView()));
                      //   },
                      // )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColorLight,
      body: SafeArea(
        child: isLoading
            ? Loader()
            : Padding(
                padding:
                    EdgeInsets.only(left: 0, top: 10, right: 20, bottom: 10),
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
                                color: Theme.of(context).primaryColorDark,
                                size: 45),
                            onPressed: () {
                              Navigator.of(context).pop();
                            }),
                        InkWell(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              UtilsImporter().stringUtils.deliverto,
                              style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontFamily:
                                      UtilsImporter().stringUtils.HKGrotesk,
                                  fontSize: 30),
                            )),
                      ],
                    ),
                    isError
                        ? Padding(
                            padding: EdgeInsets.only(left: 10, top: 0),
                            child: AlertMessages(
                              text:
                                  " يرجى المحاولى مرة أُخرى و التأكد من إتصالك بالإنترنت",
                              messageType: "internetError",
                              headerText: " حدث خطأ اثناء محاولة حذف العنوان ",
                            ),
                          )
                        : Container(),
                    Expanded(
                      child: ListView(
                        children: <Widget>[
                          ListView.builder(
                            primary: false,
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount: LoadingScreenServices.userAddress == null
                                ? 0
                                : LoadingScreenServices.userAddress.length,
                            itemBuilder: (BuildContext context, int index) {
                              return new GestureDetector(
                                behavior: HitTestBehavior.translucent,
                                onTap: () => _onAddressClicked(index),
                                child: Container(
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        left: 0, right: 0, top: 0),
                                    child: cardBody(index, context),
                                  ),
                                ),
                              );
                            },
                          ),
                          Align(
                              alignment: Alignment.center,
                              child: FlatButton(
                                padding: EdgeInsets.only(left: 30.0, top: 10.0),
                                child: Text(
                                    UtilsImporter().stringUtils.add_new_address,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: UtilsImporter()
                                            .colorUtils
                                            .greycolor,
                                        fontFamily: UtilsImporter()
                                            .stringUtils
                                            .HKGrotesk,
                                        fontSize: 17)),
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      new MaterialPageRoute(
                                          builder: (context) =>
                                              new AddAddressView(
                                                isFromDeliveryScreen: true,
                                              )));
                                },
                              )),
                        ],
                      ),
                    ),
                    _showProceedToPayButton()
                  ],
                ),
              ),
      ),
    );
  }

  // Function to be called on click
  void _onAddressClicked(int index) {
    debugPrint("You tapped on item $index");

    setState(() {
      DeliverToView.selectedIndex = index + 1;
    });
  }

  Widget _showProceedToPayButton() {
    final GestureDetector showProceedToPayButtonWithGesture =
        new GestureDetector(
      onTap: _showProceedToPayBtnTapped,
      child: new Container(
        margin: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 10.0),
        height: 50.0,
        decoration: new BoxDecoration(
            color: DeliverToView.selectedIndex != null
                ? UtilsImporter().colorUtils.primarycolor
                : Colors.grey[400],
            borderRadius: new BorderRadius.all(Radius.circular(6.0))),
        child: new Center(
          child: new Text(
            UtilsImporter().stringUtils.proceed_to_pay.toUpperCase(),
            style: new TextStyle(
                color: Colors.white,
                fontSize: 20.0,
                fontWeight: FontWeight.w500,
                fontFamily: UtilsImporter().stringUtils.HKGrotesk),
          ),
        ),
      ),
    );

    return new Padding(
        padding: EdgeInsets.only(left: 0.0, right: 0.0, top: 5.0),
        child: showProceedToPayButtonWithGesture);
  }

  void _showProceedToPayBtnTapped() {
    if (DeliverToView.selectedIndex != null) {
      print(LoadingScreenServices.deliveryMethodsList.length);
      if (LoadingScreenServices.deliveryMethodsList.length != 1) {
        Navigator.push(
            context,
            new MaterialPageRoute(
                builder: (context) => new DeliveryMethodView()));
      } else {
        Navigator.push(context,
            new MaterialPageRoute(builder: (context) => new CartViewFinal()));
      }
    } else {
      Toast.show("يرجى إختيار أو إضافة عنوان للتوصيل", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
    }
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
                      isFromDeliveryScreen: true,
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
}
