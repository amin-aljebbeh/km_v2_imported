import 'package:auto_size_text_field/auto_size_text_field.dart';
import 'package:flutter/material.dart';
import 'package:kammun_app/models/start_model.dart';
import 'package:kammun_app/utils/Loader.dart';
import 'package:kammun_app/utils/utils_importer.dart';
import 'package:kammun_app/views/Wedgit/AlertMessagess.dart';
import 'package:kammun_app/views/loading/LoadingServices.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';
import 'package:toast/toast.dart';

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

  final FocusNode _streetFocus = FocusNode();
  final FocusNode _cityFocus = FocusNode();
  final FocusNode _stateFocus = FocusNode();
  final FocusNode _countryFocus = FocusNode();

  bool isLoading = false;
  bool isError = false;

  String selectedValue;

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

      for (int i = 0;
          i < LoadingScreenServices.supportedCitiesList.length;
          i++) {
        print(LoadingScreenServices.supportedCitiesList[i].value);
        if (LoadingScreenServices.supportedCitiesList[i].value.split("id")[1] ==
            LoadingScreenServices
                .userAddress[widget.addressIndex].supportedCityId
                .toString()) {
          selectedValue = LoadingScreenServices.supportedCitiesList[i].value;
        }
      }

      // print(Services.userAddress[widget.addressIndex].supportedCityName);
      // print(Services.userAddress[widget.addressIndex].supportedCityId);

      // selectedValue =
      //     Services.userAddress[widget.addressIndex].supportedCityName;
    }
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
                        padding: EdgeInsets.only(
                            left: 20, top: 10, right: 20, bottom: 10),
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
                                        fontFamily: UtilsImporter()
                                            .stringUtils
                                            .HKGrotesk,
                                        fontSize: 30),
                                  )
                                ],
                              ),
                              isError
                                  ? AlertMessages(
                                      text:
                                          " يرجى المحاولى مرة أُخرى و التأكد من إتصالك بالإنترنت",
                                      messageType: "internetError",
                                      headerText:
                                          " حدث خطأ اثناء محاولة إضافة عنوان ",
                                    )
                                  : Container(),
                              _ShowStreetInput(),
                              _ShowSupportedCities(),
                              _ShowCityInput(),
                              _ShowStateInput(),
                              _ShowCountryInput(),
                              _showAddAddressButton()
                            ])))));
  }

  Widget _ShowStreetInput() {
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
                  print(value);
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _ShowSupportedCities() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 0.0),
      child: new AutoSizeTextField(
        scrollPadding: EdgeInsets.all(5),
        cursorColor: UtilsImporter().colorUtils.kmColors,
        controller: streetController,
        maxLines: 1,
        focusNode: _streetFocus,
        textInputAction: TextInputAction.next,
        autofocus: true,
        onSubmitted: (term) {
          FocusScope.of(context).requestFocus(_cityFocus);
        },
        style: new TextStyle(
            fontFamily: UtilsImporter().stringUtils.HKGrotesk,
            fontWeight: FontWeight.w500,
            fontSize: 16.0,
            color: Colors.black),
        decoration: InputDecoration(
            hintText: "مثال: بيت الجبه�� منزل الدكتور محمد",
            hintStyle: TextStyle(
                color: Colors.black26,
                fontSize: 15,
                fontFamily: UtilsImporter().stringUtils.HKGrotesk),
            labelText: UtilsImporter().stringUtils.street,
            labelStyle: TextStyle(
              color: UtilsImporter().colorUtils.greycolor,
              fontFamily: UtilsImporter().stringUtils.HKGrotesk,
              fontSize: 25,
            ),
            border: new UnderlineInputBorder(
                borderSide: new BorderSide(
                    color: UtilsImporter().colorUtils.primarycolor))),
      ),
    );
  }

  Widget _ShowCityInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 25.0, 0.0, 0.0),
      child: new AutoSizeTextField(
        cursorColor: UtilsImporter().colorUtils.kmColors,
        controller: cityController,
        maxLines: 1,
        focusNode: _cityFocus,
        textInputAction: TextInputAction.next,
        autofocus: true,
        onSubmitted: (term) {
          FocusScope.of(context).requestFocus(_stateFocus);
        },
        style: new TextStyle(
            fontFamily: UtilsImporter().stringUtils.HKGrotesk,
            fontWeight: FontWeight.w500,
            fontSize: 16.0,
            color: Theme.of(context).primaryColorDark),
        decoration: InputDecoration(
            hintText: "بناء رقم 15، بناء المهندسين",
            hintStyle: TextStyle(
                color: Colors.black26,
                fontSize: 15,
                fontFamily: UtilsImporter().stringUtils.HKGrotesk),
            labelText: UtilsImporter().stringUtils.city,
            labelStyle: TextStyle(
              fontSize: 25,
              color: UtilsImporter().colorUtils.greycolor,
              fontFamily: UtilsImporter().stringUtils.HKGrotesk,
            ),
            border: new UnderlineInputBorder(
                borderSide: new BorderSide(
                    color: UtilsImporter().colorUtils.primarycolor))),
      ),
    );
  }

  Widget _ShowStateInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 25.0, 0.0, 0.0),
      child: new AutoSizeTextField(
        cursorColor: UtilsImporter().colorUtils.kmColors,
        controller: stateController,
        maxLines: 1,
        focusNode: _stateFocus,
        textInputAction: TextInputAction.next,
        autofocus: true,
        onSubmitted: (term) {
          FocusScope.of(context).requestFocus(_countryFocus);
        },
        style: new TextStyle(
            fontFamily: UtilsImporter().stringUtils.HKGrotesk,
            fontWeight: FontWeight.w500,
            fontSize: 16.0,
            color: Theme.of(context).primaryColorDark),
        decoration: InputDecoration(
            hintText: "الطابق الأرضي، الطابق الخامس",
            hintStyle: TextStyle(
                color: Colors.black26,
                fontSize: 15,
                fontFamily: UtilsImporter().stringUtils.HKGrotesk),
            labelText: UtilsImporter().stringUtils.state,
            labelStyle: TextStyle(
              fontSize: 25,
              color: UtilsImporter().colorUtils.greycolor,
              fontFamily: UtilsImporter().stringUtils.HKGrotesk,
            ),
            border: new UnderlineInputBorder(
                borderSide: new BorderSide(
                    color: UtilsImporter().colorUtils.primarycolor))),
      ),
    );
  }

  Widget _ShowCountryInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 25.0, 0.0, 0.0),
      child: new AutoSizeTextField(
        cursorColor: UtilsImporter().colorUtils.kmColors,
        controller: countryController,
        maxLines: 4,
        focusNode: _countryFocus,
        textInputAction: TextInputAction.next,
        autofocus: true,
        onSubmitted: (term) {
          _countryFocus.unfocus();
        },
        style: new TextStyle(
            fontFamily: UtilsImporter().stringUtils.HKGrotesk,
            fontWeight: FontWeight.w500,
            fontSize: 16.0,
            color: Theme.of(context).primaryColorDark),
        decoration: InputDecoration(
            hintText: "مقابل جامع النعمان،",
            hintStyle: TextStyle(
                color: Colors.black26,
                fontSize: 15,
                fontFamily: UtilsImporter().stringUtils.HKGrotesk),
            labelText: UtilsImporter().stringUtils.country,
            labelStyle: TextStyle(
              fontSize: 25,
              color: UtilsImporter().colorUtils.greycolor,
              fontFamily: UtilsImporter().stringUtils.HKGrotesk,
            ),
            border: new UnderlineInputBorder(
                borderSide: new BorderSide(
                    color: UtilsImporter().colorUtils.primarycolor))),
      ),
    );
  }

  Widget _showAddAddressButton() {
    final GestureDetector loginButtonWithGesture = new GestureDetector(
      onTap: _addAddressBtnTapped,
      child: new Container(
        height: 50.0,
        decoration: new BoxDecoration(
            color: UtilsImporter().colorUtils.primarycolor,
            borderRadius: new BorderRadius.all(Radius.circular(6.0))),
        child: new Center(
          child: new Text(
            "حفظ العنوان",
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
        padding: EdgeInsets.only(left: 0.0, right: 0.0, top: 35.0),
        child: selectedValue == null ||
                countryController.text == "" ||
                stateController.text == "" ||
                streetController.text == ""
            ? InkWell(
                onTap: () => _showToast(),
                child: new Container(
                  height: 50.0,
                  decoration: new BoxDecoration(
                      color: Colors.grey[400],
                      borderRadius: new BorderRadius.all(Radius.circular(6.0))),
                  child: new Center(
                    child: new Text(
                      "حفظ العنوان",
                      style: new TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                          fontWeight: FontWeight.w500,
                          fontFamily: UtilsImporter().stringUtils.HKGrotesk),
                    ),
                  ),
                ),
              )
            : loginButtonWithGesture);
  }

  void _showToast() {
    if (selectedValue == null) {
      Toast.show("يرجى إختيار المدينة", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
    } else if (streetController.text == "")
      Toast.show("يرجى تعبئة حقل اسم صاحب الطلب", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
    // else if (cityController.text == "")
    //   Toast.show("يرجى تعبئة حقل اسم او رقم البناء", context,
    //       duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
    else if (stateController.text == "")
      Toast.show("برجى تحديد الطابق", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
    else if (countryController.text == "")
      Toast.show("يرجى كتابة علامة قريبة للإستدلال", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
  }

  Future<void> _addAddressBtnTapped() async {
    Address newUserAddress = new Address();

    //     final streetController = TextEditingController();
    // final cityController = TextEditingController();
    // final stateController = TextEditingController();
    // final countryController = TextEditingController();
    print("city id " + selectedValue.split("id")[1].toString());

    newUserAddress.deliveryPrice =
        int.parse(selectedValue.split("price")[1].split("id")[0].split(".")[0]);
    newUserAddress.supportedCityName = selectedValue.split("price")[0];
    newUserAddress.street = streetController.text;
    newUserAddress.building = cityController.text.length == 0
        ? "لايوجد رقم بناء"
        : cityController.text;
    newUserAddress.floor = stateController.text;
    newUserAddress.description = countryController.text;
    newUserAddress.supportedCityId = selectedValue.split("id")[1];

    if (widget.addressIndex != null) {
      LoadingScreenServices.userAddress[widget.addressIndex].supportedCityName =
          newUserAddress.supportedCityName;
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
          supportedCityId: newUserAddress.supportedCityId.toString());

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
          newUserAddress.supportedCityId.toString());

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
