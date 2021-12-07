import 'package:flutter/material.dart';
import 'package:kammun_app/utils/tools.dart';
import 'package:kammun_app/models/start_model.dart';
import 'package:kammun_app/utils/Loader.dart';
import 'package:kammun_app/utils/utils_importer.dart';
import 'package:kammun_app/views/Wedgit/AlertMessages.dart';
import 'package:kammun_app/views/Wedgit/kammun_button.dart';
import 'package:kammun_app/views/Wedgit/k_text_field.dart';
import 'package:kammun_app/views/loading/LoadingServices.dart';
import 'package:location/location.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';

import '../../Services.dart';

class AddAddressView extends StatefulWidget {
  int addressIndex;
  bool isFromDeliveryScreen;

  AddAddressView({this.addressIndex, @required this.isFromDeliveryScreen});

  @override
  State<StatefulWidget> createState() {
    return AddAddressViewState();
  }
}

class AddAddressViewState extends State<AddAddressView> {
  final streetController = TextEditingController();
  final cityController = TextEditingController();
  final stateController = TextEditingController();
  final countryController = TextEditingController();
  final entranceController = TextEditingController();

  final FocusNode _streetFocus = FocusNode();
  final FocusNode _cityFocus = FocusNode();
  final FocusNode _stateFocus = FocusNode();
  final FocusNode _countryFocus = FocusNode();
  final FocusNode _entranceFocus = FocusNode();

  bool isLoading = false;
  bool isError = false;
  bool userIgnorShareLocation;
  String selectedValue;

  double lat;
  double lon;

  @override
  void initState() {
    super.initState();
    if (widget.addressIndex != null) {
      streetController.text =
          LoadingScreenServices.userAddress[widget.addressIndex].street;
      cityController.text =
          LoadingScreenServices.userAddress[widget.addressIndex].building;
      stateController.text =
          LoadingScreenServices.userAddress[widget.addressIndex].floor;
      countryController.text =
          LoadingScreenServices.userAddress[widget.addressIndex].description;
      entranceController.text =
          LoadingScreenServices.userAddress[widget.addressIndex].entrance;
      for (int i = 0;
          i < LoadingScreenServices.supportedCitiesList.length;
          i++) {
        Tools.logToConsole(LoadingScreenServices.supportedCitiesList[i].value);
        if (LoadingScreenServices.supportedCitiesList[i].value.split("id")[1] ==
            LoadingScreenServices
                .userAddress[widget.addressIndex].supportedCityId
                .toString()) {
          selectedValue = LoadingScreenServices.supportedCitiesList[i].value;
        }
      }

      // Tools.logToConsole(Services.userAddress[widget.addressIndex].supportedCityName);
      // Tools.logToConsole(Services.userAddress[widget.addressIndex].supportedCityId);

      // selectedValue =
      //     Services.userAddress[widget.addressIndex].supportedCityName;

      userIgnorShareLocation = false;
      Tools.logToConsole(userIgnorShareLocation);
      Tools.logToConsole("userIgnorShareLocation Changed Value ");
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColorLight,
      body: SafeArea(
        child: isLoading
            ? Center(child: Loader())
            : SingleChildScrollView(
                child: Container(
                  padding:
                      EdgeInsets.only(left: 20, top: 10, right: 20, bottom: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          InkWell(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: Icon(
                              Icons.arrow_back_ios,
                              size: 35,
                            ),
                          ),
                          SizedBox(width: 5),
                          Text(
                            UtilsImporter().stringUtils.add_address,
                            style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontFamily:
                                    UtilsImporter().stringUtils.HKGrotesk,
                                fontSize: 30),
                          )
                        ],
                      ),
                      isError
                          ? AlertMessages(
                              text:
                                  " يرجى المحاولى مرة أُخرى و التأكد من إتصالك بالإنترنت",
                              messageType: "internetError",
                              headerText: " حدث خطأ اثناء محاولة إضافة عنوان ",
                            )
                          : Container(),
                      _showStreetInput(),
                      KTextField(
                        controller: streetController,
                        maxLine: 1,
                        focusNode: _streetFocus,
                        onSubmitted: (term) {
                          FocusScope.of(context).requestFocus(_cityFocus);
                        },
                        hintText: "مثال: بيت الجبه منزل الدكتور محمد",
                        labelText: UtilsImporter().stringUtils.familyName,
                      ),
                      KTextField(
                        controller: cityController,
                        maxLine: 1,
                        focusNode: _cityFocus,
                        onSubmitted: (term) {
                          FocusScope.of(context).requestFocus(_stateFocus);
                        },
                        hintText: "بناء رقم 15، بناء المهندسين",
                        labelText: UtilsImporter().stringUtils.buildingName,
                      ),
                      KTextField(
                        controller: stateController,
                        maxLine: 1,
                        focusNode: _stateFocus,
                        onSubmitted: (term) {
                          FocusScope.of(context).requestFocus(_countryFocus);
                        },
                        hintText: "الطابق الأرضي، الطابق الخامس",
                        labelText: UtilsImporter().stringUtils.floor,
                      ),
                      KTextField(
                        controller: entranceController,
                        maxLine: 1,
                        focusNode: _entranceFocus,
                        onSubmitted: (term) {
                          FocusScope.of(context).requestFocus(_entranceFocus);
                        },
                        hintText: "المدخل اليميني",
                        labelText: UtilsImporter().stringUtils.HKGrotesk,
                      ),
                      KTextField(
                        controller: countryController,
                        maxLine: 4,
                        focusNode: _countryFocus,
                        onSubmitted: (term) {
                          _countryFocus.unfocus();
                        },
                        hintText: "مقابل جامع النعمان،",
                        labelText: UtilsImporter().stringUtils.closeSign,
                      ),
                      KammunButton(
                        text: "حفظ العنوان",
                        height: 50,
                        color: UtilsImporter().colorUtils.primarycolor,
                        onTap: _addAddressBtnTapped,
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  Widget _showStreetInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 0.0),
      child: Column(
        children: <Widget>[
          Align(
              alignment: Alignment.centerRight,
              child: Text(
                "المدينة :",
                style: TextStyle(
                    fontFamily: UtilsImporter().stringUtils.HKGrotesk,
                    fontSize: 20,
                    color: UtilsImporter().colorUtils.primarycolor,
                    fontWeight: FontWeight.w500),
              )),
          Container(
            padding: EdgeInsets.only(left: 5, right: 5),
            decoration: BoxDecoration(
              border: Border.all(
                  width: 5, color: UtilsImporter().colorUtils.kmColors),
            ),
            child: new SearchableDropdown(
              isCaseSensitiveSearch: false,
              underline: Container(),
              isExpanded: true,
              items: LoadingScreenServices.supportedCitiesList,
              value: selectedValue,
              hint: new Text(
                'يرجى إختيار المدينة التابع لها ',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: UtilsImporter().stringUtils.HKGrotesk,
                ),
              ),
              searchHint: new Text(
                'إختيار المنطقة',
                style: new TextStyle(
                    fontSize: 20,
                    fontFamily: UtilsImporter().stringUtils.HKGrotesk),
              ),
              onChanged: (value) {
                setState(() {
                  selectedValue = value;
                  Tools.logToConsole(value);
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  void _settingModalBottomSheet(context) {
    double screenHeight = MediaQuery.of(context).size.height;
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext bc) {
          return SafeArea(
            child: StatefulBuilder(builder: (BuildContext context, setState) {
              return ListView(
                shrinkWrap: true,
                children: [
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.fromLTRB(
                        0, screenHeight * 0.02, 0, screenHeight * 0.02),
                    decoration: BoxDecoration(
                      border: Border(bottom: BorderSide()),
                    ),
                    child: Text('هل تريد مشاركة موقعك؟',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: UtilsImporter().stringUtils.HKGrotesk,
                            color: UtilsImporter().colorUtils.kmColors,
                            fontWeight: FontWeight.bold,
                            fontSize: 25)), //font color is diffrent
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(17, screenHeight * 0.03, 17, 0),
                    child: Text(
                      UtilsImporter().stringUtils.loaction_request_info,
                      style: TextStyle(
                          fontFamily: UtilsImporter().stringUtils.HKGrotesk,
                          color: UtilsImporter().colorUtils.primarycolor,
                          fontSize: 18),
                    ), //font color is diffrent
                  ),

                  Container(
                    margin: EdgeInsets.fromLTRB(17, screenHeight * 0.03, 17, 0),
                    child: Text(
                      UtilsImporter().stringUtils.location_request_note,
                      style: TextStyle(
                          fontFamily: UtilsImporter().stringUtils.HKGrotesk,
                          color: Colors.red),
                    ), //font color is diffrent
                  ),
                  //   _submitRating(),

                  Padding(
                    padding: const EdgeInsets.only(
                        top: 8.0, left: 8, right: 8, bottom: 3),
                    child: KammunButton(
                      text: "مشاركة الموقع",
                      height: 50,
                      color: Colors.green,
                      onTap: () {
                        _getUserLocation();
                        Navigator.of(context).pop();
                      },
                    ), /*_showGetUserLocation(ctx: context)*/
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 0.0, left: 8, right: 8, bottom: 40),
                    child: KammunButton(
                      text: "حفظ العنوان",
                      height: 50,
                      color: UtilsImporter().colorUtils.primarycolor,
                      onTap: () {
                        setState(() {
                          userIgnorShareLocation = true;
                        });
                        Navigator.of(context).pop();

                        _addAddressBtnTapped();
                      },
                    ),
                  ),
                ],
              );
            }),
          );
        });
  }

  Map<String, double> userLocation;

  // bool bottomSheetLoading = false;

  Future<void> _getUserLocation() async {
    Tools.logToConsole("---- _getUserLocation function ----");

    var location = new Location();

    setState(() {
      isLoading = true;
    });

    try {
      if (await location.hasPermission() == PermissionStatus.granted &&
          await location.requestService() == true) {
        try {
          Tools.logToConsole("---- Location Garented ----");
          Tools.logToConsole(await location.hasPermission());
          await location.getLocation().then((onValue) {
            setState(() {
              userLocation = {
                "latitude": onValue.latitude,
                "longitude": onValue.longitude
              };
              lat = onValue.latitude;
              lon = onValue.longitude;
              Tools.logToConsole("----- the lat , lon is ------");
              Tools.logToConsole(lat);
              Tools.logToConsole(lon);
            });
          });

          _addAddressBtnTapped();
        } catch (e) {
          Tools.logToConsole("error getting user location");
          Tools.logToConsole(e.toString());
        }
      } else {
        Tools.logToConsole("---- address no granted ----");
        await location.requestPermission().then((onValue) =>
            onValue == PermissionStatus.granted ? _getUserLocation() : {});
      }
    } catch (e) {
      Tools.logToConsole("----- error before if --------");
      Tools.logToConsole(e.toString());
    }
  }

  Future<void> _addAddressBtnTapped() async {
    Tools.logToConsole("selectedValue $selectedValue");
    Tools.logToConsole("countryController + ${countryController.text}");
    Tools.logToConsole("stateController + ${stateController.text}");
    Tools.logToConsole("streetController + ${streetController.text}");
    if (userIgnorShareLocation == null) {
      userIgnorShareLocation = false;
    }

    if (userLocation == null && !userIgnorShareLocation) {
      _settingModalBottomSheet(context);
    } else {
      Address newUserAddress = new Address();

      //     final streetController = TextEditingController();
      // final cityController = TextEditingController();
      // final stateController = TextEditingController();
      // final countryController = TextEditingController();
      Tools.logToConsole("city id " + selectedValue.split("id")[1].toString());

      newUserAddress.deliveryPrice = int.parse(
          selectedValue.split("price")[1].split("id")[0].split(".")[0]);
      newUserAddress.supportedCityName = selectedValue.split("price")[0];
      newUserAddress.street = streetController.text;
      newUserAddress.building = cityController.text.length == 0
          ? "لايوجد رقم بناء"
          : cityController.text;
      newUserAddress.floor = stateController.text;
      newUserAddress.description = countryController.text;
      newUserAddress.supportedCityId = selectedValue.split("id")[1];
      newUserAddress.lat = lat.toString();
      newUserAddress.lon = lon.toString();
      newUserAddress.entrance = entranceController.text;

      if (widget.addressIndex != null) {
        LoadingScreenServices.userAddress[widget.addressIndex]
            .supportedCityName = newUserAddress.supportedCityName;
        LoadingScreenServices.userAddress[widget.addressIndex].street =
            newUserAddress.street;
        LoadingScreenServices.userAddress[widget.addressIndex].building =
            newUserAddress.building;
        LoadingScreenServices.userAddress[widget.addressIndex].floor =
            newUserAddress.floor;
        LoadingScreenServices.userAddress[widget.addressIndex].description =
            newUserAddress.description;
        LoadingScreenServices.userAddress[widget.addressIndex].supportedCityId =
            newUserAddress.supportedCityId.toString();
        LoadingScreenServices.userAddress[widget.addressIndex].lat =
            newUserAddress.lat;
        LoadingScreenServices.userAddress[widget.addressIndex].lon =
            newUserAddress.lat;
        LoadingScreenServices.userAddress[widget.addressIndex].entrance =
            newUserAddress.entrance;
        setState(() {
          isLoading = true;
          isError = false;
        });

        bool addressUpdted = await Services.updateAddress(
            addressId: LoadingScreenServices.userAddress[widget.addressIndex].id
                .toString(),
            city: newUserAddress.supportedCityName,
            street: newUserAddress.street,
            building: newUserAddress.building,
            floor: newUserAddress.floor,
            description: newUserAddress.description,
            supportedCityId: newUserAddress.supportedCityId.toString(),
            lat: lat,
            lon: lon,
            entrance: newUserAddress.entrance);

        if (addressUpdted) {
          setState(() {
            isLoading = false;
            isError = false;
          });
          Navigator.pop(context);
          Navigator.pop(context);
          if (widget.isFromDeliveryScreen) {
            Navigator.pushNamed(context, '/delivery');
          } else {
            Navigator.pushNamed(context, '/profile');
          }
        } else {
          setState(() {
            isLoading = false;
            isError = true;
          });
        }
      } else {
        LoadingScreenServices.userAddress.insert(0, newUserAddress);

        setState(() {
          isLoading = true;
          isError = false;
        });
        bool successAddingAddress = await Services.addNewAddress(
            newUserAddress.supportedCityName,
            newUserAddress.street,
            newUserAddress.building,
            newUserAddress.floor,
            newUserAddress.description,
            newUserAddress.supportedCityId.toString(),
            lat,
            lon,
            newUserAddress.entrance);

        if (successAddingAddress) {
          setState(() {
            isLoading = false;
            isError = false;
          });
          Navigator.pop(context);
          Navigator.pop(context);
          if (widget.isFromDeliveryScreen) {
            Navigator.pushNamed(context, '/delivery');
          } else {
            Navigator.pushNamed(context, '/profile');
          }
        } else {
          setState(() {
            isLoading = false;
            isError = true;
          });
        }
      }
    }
  }
}
