import 'package:flutter/material.dart';
import '../../../core/core_importer.dart';
import '../redux/address_action.dart';

class AddAddressView extends StatefulWidget {
  static const String routeName = '/AddAddressView';

  const AddAddressView({Key key}) : super(key: key);

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

  double lat, lng;
  String cityName;
  String cityId;
  int addressIndex;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      StoreProvider.of<AppState>(context).dispatch(NoError());
      addressIndex = StoreProvider.of<AppState>(context).state.addressState.editingIndex;
      List<AddressModel> addresses = StoreProvider.of<AppState>(context).state.addressState.addresses;
      List<SupportedCityModel> supportedCities =
          StoreProvider.of<AppState>(context).state.supportedCityState.supportedCities;
      if (addressIndex != -1) {
        streetController.text = addresses[addressIndex].street;
        cityController.text = addresses[addressIndex].building;
        stateController.text = addresses[addressIndex].floor;
        countryController.text = addresses[addressIndex].description;
        entranceController.text = addresses[addressIndex].entrance;
        lat = addresses[addressIndex].lat;
        lng = addresses[addressIndex].lon;
        cityId = supportedCities
            .firstWhere((city) => city.id.toString() == addresses[addressIndex].supportedCityId)
            .id
            .toString();
        cityName =
            supportedCities.firstWhere((city) => city.id.toString() == addresses[addressIndex].supportedCityId).name;
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      builder: (context, state) {
        return TemporaryLoading(
          child: Scaffold(
            resizeToAvoidBottomInset: true,
            backgroundColor: Theme.of(context).primaryColorLight,
            appBar: NormalAppBar(title: StringUtils.addNewAddress),
            body: Column(
              children: [
                Expanded(
                  child: ListView(
                    physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 20, top: 10, right: 20, bottom: 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 25, bottom: 10),
                              child: Text(
                                  'المدينة : ' +
                                      (addressIndex == -1
                                          ? state.mapState.addressLocationModel.polygonModel.supportedCityName
                                          : cityName),
                                  style: informationStyle.copyWith(fontSize: 20)),
                            ),
                            AddAddressTextField(
                              controller: streetController,
                              onChanged: () => setState(() {}),
                              focusNode: _streetFocus,
                              onSubmitted: (term) => FocusScope.of(context).requestFocus(_cityFocus),
                              hintText: 'مثال: بيت الجبه منزل الدكتور محمد',
                              labelText: StringUtils.familyName,
                            ),
                            AddAddressTextField(
                              onChanged: () => setState(() {}),
                              controller: cityController,
                              focusNode: _cityFocus,
                              onSubmitted: (term) => FocusScope.of(context).requestFocus(_stateFocus),
                              hintText: 'بناء رقم 15، بناء المهندسين',
                              labelText: StringUtils.buildingName,
                            ),
                            AddAddressTextField(
                              controller: stateController,
                              focusNode: _stateFocus,
                              onChanged: () => setState(() {}),
                              onSubmitted: (term) => FocusScope.of(context).requestFocus(_entranceFocus),
                              hintText: 'الطابق الأرضي، الطابق الخامس',
                              labelText: StringUtils.floor,
                            ),
                            AddAddressTextField(
                              controller: entranceController,
                              focusNode: _entranceFocus,
                              onChanged: () => setState(() {}),
                              onSubmitted: (term) => FocusScope.of(context).requestFocus(_countryFocus),
                              hintText: 'المدخل اليميني',
                              labelText: StringUtils.entrance,
                            ),
                            AddAddressTextField(
                              controller: countryController,
                              maxLines: 4,
                              onChanged: () => setState(() {}),
                              focusNode: _countryFocus,
                              onSubmitted: (term) => _countryFocus.unfocus(),
                              hintText: 'مقابل جامع النعمان',
                              labelText: StringUtils.closeSign,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 35),
                    ],
                  ),
                ),
                KCard(
                  radius: 0,
                  color: ColorUtils.silverColor,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 20, top: 10, left: 20, right: 20),
                    child: KButton(
                      text: StringUtils.save + ' ' + StringUtils.address,
                      height: 50,
                      color: completedData() ? ColorUtils.primaryColor : ColorUtils.searchGreyColor,
                      onTap: () => completedData()
                          ? _addAddressBtnTapped(
                              supportedCityId: addressIndex != -1
                                  ? cityId
                                  : state.mapState.addressLocationModel.polygonModel.supportedCityId,
                              lng: addressIndex != -1 ? lng : state.mapState.addressLocationModel.coords.longitude,
                              lat: addressIndex != -1 ? lat : state.mapState.addressLocationModel.coords.latitude,
                            )
                          : _showToast(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showToast() {
    if (streetController.text == '') {
      flushbar(message: 'يرجى تعبئة حقل اسم صاحب الطلب', color: Colors.red, icon: Icons.error, duration: 2);
    } else if (stateController.text == '') {
      flushbar(message: 'يرجى تحديد الطابق', color: Colors.red, icon: Icons.error, duration: 2);
    } else if (countryController.text == '') {
      flushbar(message: 'يرجى كتابة علامة قريبة للاستدلال', color: Colors.red, icon: Icons.error, duration: 2);
    } else if (entranceController.text == '') {
      flushbar(message: 'يرجى كتابة المدخل', color: Colors.red, icon: Icons.error, duration: 2);
    }
  }

  Future<void> _addAddressBtnTapped({String supportedCityId, double lat, double lng}) async {
    AddressModel newUserAddress = AddressModel();

    newUserAddress.supportedCityName = cityName;
    newUserAddress.street = streetController.text;
    newUserAddress.building = cityController.text.isEmpty ? 'لايوجد رقم بناء' : cityController.text;
    newUserAddress.floor = stateController.text;
    newUserAddress.description = countryController.text;
    newUserAddress.supportedCityId = supportedCityId;
    newUserAddress.lat = lat;
    newUserAddress.lon = lng;
    newUserAddress.entrance = entranceController.text;
    if (StoreProvider.of<AppState>(context).state.addressState.editingIndex != -1) {
      newUserAddress.id = StoreProvider.of<AppState>(context)
          .state
          .addressState
          .addresses[StoreProvider.of<AppState>(context).state.addressState.editingIndex]
          .id;
    }
    int addressIndex = StoreProvider.of<AppState>(context).state.addressState.editingIndex;
    if (addressIndex != -1) {
      StoreProvider.of<AppState>(context)
          .dispatch(UpdateAddress(selectedAddress: addressIndex, address: newUserAddress));
    } else {
      StoreProvider.of<AppState>(context).dispatch(AddAddress(
          address: newUserAddress,
          getDeliveryMethods: StoreProvider.of<AppState>(context).state.addressState.addresses.isEmpty));
    }
  }

  bool completedData() {
    return countryController.text != '' &&
        stateController.text != '' &&
        streetController.text != '' &&
        entranceController.text != '';
  }
}
