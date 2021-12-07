import 'package:flutter/material.dart';
import 'package:kammun_app/utils/tools.dart';
import 'package:kammun_app/utils/Loader.dart';
import 'package:kammun_app/utils/utils_importer.dart';
import 'package:kammun_app/views/Wedgit/AlertMessages.dart';
import 'package:kammun_app/views/Wedgit/kammun_button.dart';
import 'package:kammun_app/views/cart/CartViewFinal.dart';
import 'package:kammun_app/views/deliver_to/services/delivery_method_services.dart';
import 'package:kammun_app/views/loading/LoadingServices.dart';
import 'package:group_button/group_button.dart';
import 'package:toast/toast.dart';

import 'deliver_to_view.dart';

class DeliveryMethodView extends StatefulWidget {
  static int selectedDeliveryIndex = 0;

  @override
  _DeliveryMethodViewState createState() => _DeliveryMethodViewState();
}

class _DeliveryMethodViewState extends State<DeliveryMethodView> {
  int selectedIndex = 0;

  Future getDeliveryMethods;

  bool isLoading = false;
  bool error;
  String errorMessage;

  @override
  void initState() {
    selectedIndex = 0;
    getDeliveryMethods = _getDeliveryMethods();
    DeliveryMethodView.selectedDeliveryIndex = selectedIndex;
    super.initState();
  }

  _getDeliveryMethods() async {
    setState(() {
      isLoading = true;
    });

    bool response = await DeliveryMethodServices.getUserDeliveryMethod(
        addressId: LoadingScreenServices
            .userAddress[DeliverToView.selectedIndex].id
            .toString());

    if (response != null && response) {
      setState(() {
        isLoading = false;
        error = false;
        errorMessage = "";
      });
    } else {
      setState(() {
        isLoading = false;
        error = true;
        errorMessage =
            "حدث خطأ أثناء محاولة جلب طرق التوصيل المتاحة يرجى التأكد من إتصالك بالإنترنت و المحاولة مجدداً";
      });
    }
  }

  void _showGoToReviewPage() {
    if (selectedIndex != null) {
      Navigator.push(context,
          new MaterialPageRoute(builder: (context) => CartViewFinal()));
    } else {
      Toast.show("يرجى اختيار طريقة التوصيل ", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColorLight,
      body: SafeArea(
        child: isLoading
            ? Center(child: Loader())
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
                              UtilsImporter().stringUtils.deliverMethod,
                              style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontFamily:
                                      UtilsImporter().stringUtils.HKGrotesk,
                                  fontSize: 30),
                            )),
                      ],
                    ),
                    error
                        ? Column(
                            children: [
                              Container(
                                margin: EdgeInsets.only(
                                    left: 15.0, right: 15.0, bottom: 10.0),
                                child: AlertMessages(
                                  messageType: "internetError",
                                  headerText: "حدث خطأ",
                                  text: errorMessage,
                                ),
                              ),
                            ],
                          )
                        : Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(30.0),
                                  child: Container(
                                    padding: const EdgeInsets.all(10.0),
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(
                                                5.0) //         <--- border radius here
                                            ),
                                        border: Border.all(
                                          width: 2,
                                          color: UtilsImporter()
                                              .colorUtils
                                              .kmColors,
                                        )),
                                    child: GroupButton(
                                      unselectedTextStyle: TextStyle(
                                          //color: UtilsImporter().colorUtils.primarycolor,
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.w500,
                                          fontFamily: UtilsImporter()
                                              .stringUtils
                                              .HKGrotesk),
                                      selectedTextStyle: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.w500,
                                          fontFamily: UtilsImporter()
                                              .stringUtils
                                              .HKGrotesk),
                                      direction: Axis.vertical,
                                      isRadio: true,
                                      spacing: 10,

                                      onSelected: (index, isSelected) {
                                        Tools.logToConsole(index);
                                        setState(() {
                                          selectedIndex = index;
                                          DeliveryMethodView
                                              .selectedDeliveryIndex = index;
                                        });
                                      },

                                      // buttons: ['توصيل فوري', 'توصيل عادي'],
                                      buttons: DeliveryMethodServices
                                          .deliveryMethodsList
                                          .map((f) => f.name)
                                          .toList(),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text("اجرةالتوصيل النهائية",
                                      style: TextStyle(
                                          color: UtilsImporter()
                                              .colorUtils
                                              .primarycolor,
                                          fontSize: 25.0,
                                          fontWeight: FontWeight.w500,
                                          fontFamily: UtilsImporter()
                                              .stringUtils
                                              .HKGrotesk)),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                      "${int.parse(DeliveryMethodServices.deliveryMethodsList[selectedIndex].pivot.price.split(".")[0]) + LoadingScreenServices.userAddress[DeliverToView.selectedIndex].deliveryPrice} ${LoadingScreenServices.companyInformation.currency}",
                                      style: TextStyle(
                                          color: UtilsImporter()
                                              .colorUtils
                                              .primarycolor,
                                          fontSize: 25.0,
                                          fontWeight: FontWeight.w500,
                                          fontFamily: UtilsImporter()
                                              .stringUtils
                                              .HKGrotesk)),
                                ),
                                Center(
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 18.0),
                                    child: AlertMessages(
                                      messageType: "Successfully",
                                      headerText: "شرح عن طريقة التوصيل",
                                      text: DeliveryMethodServices
                                          .deliveryMethodsList[selectedIndex]
                                          .pivot
                                          .message,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                    error
                        ? KammunButton(
                            text: "المحاولة مرة أخرى",
                            height: 50,
                            color: Colors.green,
                            onTap: _getDeliveryMethods,
                          )
                        : KammunButton(
                            text: UtilsImporter()
                                .stringUtils
                                .proceed_to_pay
                                .toUpperCase(),
                            height: 50,
                            color: selectedIndex != null
                                ? UtilsImporter().colorUtils.primarycolor
                                : Colors.grey[400],
                            onTap: _showGoToReviewPage,
                          ),
                  ],
                ),
              ),
      ),
    );
  }
}
