import 'package:flutter/material.dart';
import 'package:kammun_app/utils/utils_importer.dart';
import 'package:kammun_app/views/widget/widgets_importer.dart';
import 'package:kammun_app/views/add_address/add_address_view.dart';
import 'package:kammun_app/views/deliver_to/services/delivery_method_services.dart';
import 'package:kammun_app/views/loading/LoadingServices.dart';
import 'package:kammun_app/views/orders/services/order_services.dart';
import '../../Services.dart';
import 'delivery_method.dart';

class DeliverToView extends StatefulWidget {
  static int selectedIndex;

  const DeliverToView({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return DeliverToViewState();
  }
}

class DeliverToViewState extends State<DeliverToView> {
  bool isLoading = false;
  bool isError = false;
  int selectedAddress = -1;
  void onrRemove(item) async {
    setState(() {
      isLoading = true;
      isError = false;
    });
    bool addressDeleted = await Services.removeUserAddress(LoadingScreenServices.userAddress[item].id.toString());

    if (addressDeleted) {
      setState(() {
        LoadingScreenServices.userAddress.removeAt(item);

        if (DeliverToView.selectedIndex != null && DeliverToView.selectedIndex > 0) {
          DeliverToView.selectedIndex--;
        }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColorLight,
      body: SafeArea(
        child: isLoading
            ? const Loader()
            : Padding(
                padding: const EdgeInsets.only(left: 0, top: 10, right: 20, bottom: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        IconButton(
                            icon: Icon(Icons.arrow_back_ios, color: Theme.of(context).primaryColorDark, size: 45),
                            onPressed: () {
                              Navigator.of(context).pop();
                            }),
                        InkWell(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              StringUtils.deliverTo,
                              style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontFamily: StringUtils.fontFamilyHKGrotesk,
                                  fontSize: 30),
                            )),
                      ],
                    ),
                    isError
                        ? Padding(
                            padding: const EdgeInsets.only(left: 10, top: 0),
                            child: AlertMessages(
                              text: " يرجى المحاولى مرة أُخرى و التأكد من إتصالك بالإنترنت",
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
                              return RadioListTile(
                                controlAffinity: ListTileControlAffinity.leading,
                                autofocus: true,
                                selected: true,
                                toggleable: false,
                                activeColor: ColorUtils.primaryColor,
                                value: LoadingScreenServices.userAddress[index].id,
                                onChanged: (value) {
                                  setState(() {
                                    selectedAddress = value;
                                    DeliverToView.selectedIndex = index;
                                    OrderServices.deliverySupportedCityId = LoadingScreenServices
                                        .userAddress[DeliverToView.selectedIndex].supportedCityId
                                        .toString();
                                  });
                                },
                                groupValue: selectedAddress,
                                title: AddressWidget(
                                  onRemove: () {
                                    onrRemove(index);
                                  },
                                  index: index,
                                ),
                              );
                            },
                          ),
                          Align(
                              alignment: Alignment.center,
                              child: FlatButton(
                                padding: const EdgeInsets.only(left: 30.0, top: 10.0),
                                child: Text(StringUtils.addNewAddress,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: ColorUtils.greyColor,
                                        fontFamily: StringUtils.fontFamilyHKGrotesk,
                                        fontSize: 17)),
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => const AddAddressView(
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

  Widget _showProceedToPayButton() {
    final GestureDetector showProceedToPayButtonWithGesture = GestureDetector(
      onTap: _showProceedToPayBtnTapped,
      child: Container(
        margin: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 10.0),
        height: 50.0,
        decoration: BoxDecoration(
            color: DeliverToView.selectedIndex != null ? ColorUtils.primaryColor : Colors.grey[400],
            borderRadius: const BorderRadius.all(Radius.circular(6.0))),
        child: Center(
          child: Text(
            StringUtils.proceedToPay.toUpperCase(),
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
        padding: const EdgeInsets.only(left: 0.0, right: 0.0, top: 5.0), child: showProceedToPayButtonWithGesture);
  }

  void _showProceedToPayBtnTapped() {
    if (DeliverToView.selectedIndex != null) {
      if (DeliveryMethodServices.deliveryMethodsList.length != 1) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const DeliveryMethodView(),
          ),
        );
      }
    } else {
      Toast.show("يرجى إختيار أو إضافة عنوان للتوصيل", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
    }
  }
}
