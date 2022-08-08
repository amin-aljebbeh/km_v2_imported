import 'package:package_info_plus/package_info_plus.dart';
import 'package:kammun_app/modules/startup/service/startup_service.dart';
import 'package:kammun_app/modules/supported_city/redux/supported_city_action.dart';
import '../../../core/core_importer.dart';
import '../../order/models/get_order_model.dart';
import '../../order/services/order_services.dart';
import '../../orders/redux/orders_action.dart';
import 'startup_action.dart';
import 'package:kammun_app/modules/address/redux/address_action.dart';
import 'package:kammun_app/modules/authentication/redux/authentication_action.dart';
import 'package:kammun_app/modules/authentication/view/authentication_view_importer.dart';
import 'package:kammun_app/modules/cart/redux/cart_action.dart';
import 'package:kammun_app/modules/payment/redux/payment_action.dart';
import '../../delivery_method/redux/delivery_method_action.dart';
import '../../products/redux/products_action.dart';
import '../../update/redux/update_action.dart';
import '../redux/startup_action.dart';

Future<void> startupMiddleware(Store<AppState> store, action, NextDispatcher next) async {
  if (action is FetchStartInformation) {
    if (!store.state.startupState.requestSent) {
      if (!store.state.startupState.informationFetched) {
        store.dispatch(StartLoading());
        StartModel startModel = await StartupService.getStartScreenInformation();
        store.dispatch(RequestSent());
        if (startModel != null) {
          if (startModel.user.isBanned == 1) {
            store.dispatch(SetStartingRout(startingRout: BlockedUserView.routeName));
          } else {
            PackageInfo packageInfo = await PackageInfo.fromPlatform();
            String buildNumber = packageInfo.buildNumber;
            int lastSupported;
            int currentVersion;
            if (Platform.isIOS) {
              lastSupported = int.parse(startModel.mobileAppConfigs.iosLastSupportedVersion);
              currentVersion = int.parse(startModel.mobileAppConfigs.iosCurrentVersion);
              store.dispatch(SetUpdateUrl(updateUrl: startModel.mobileAppConfigs.appStoreUrl));
            } else {
              lastSupported = int.parse(startModel.mobileAppConfigs.androidLastSupportedVersion);
              currentVersion = int.parse(startModel.mobileAppConfigs.androidCurrentVersion);
              store.dispatch(SetUpdateUrl(updateUrl: startModel.mobileAppConfigs.googlePlayUrl));
            }
            bool serverMaintain = false;
            if (startModel.mobileAppConfigs.id == 0) {
              serverMaintain = true;
            } else if (int.parse(buildNumber) < lastSupported) {
              store.dispatch(SetStartingRout(startingRout: UpdateScreen.routeName));
              store.dispatch(RequiredUpdate());
            } else if (int.parse(buildNumber) < currentVersion) {
              store.dispatch(OptionalUpdate());
              store.dispatch(SetStartingRout(startingRout: UpdateScreen.routeName));
            }
            final supportedCitiesResponse = startModel.supportedCities;
            String systemMaintenanceMessages = '';
            store.dispatch(
                SupportedCitiesFetchedSuccessfully(supportedCities: supportedCitiesResponse, initPolygon: false));
            for (int i = 0; i < supportedCitiesResponse.length; i++) {
              if (supportedCitiesResponse[i].id == startModel.user.supportedCityId) {
                if (supportedCitiesResponse[i].isActive == 2 ||
                    (Platform.isIOS && startModel.mobileAppConfigs.iosIsActive == 0) ||
                    Platform.isAndroid && startModel.mobileAppConfigs.androidIsActive == 0) {
                  serverMaintain = true;
                  if (Platform.isIOS && startModel.mobileAppConfigs.iosIsActive == 0 ||
                      Platform.isAndroid && startModel.mobileAppConfigs.androidIsActive == 0) {
                    systemMaintenanceMessages = startModel.mobileAppConfigs.maintenanceMessages;
                  } else {
                    systemMaintenanceMessages = supportedCitiesResponse[i].maintenanceMessages;
                  }
                } else {
                  serverMaintain = false;
                }
              }
            }
            if (serverMaintain) {
              store.dispatch(ServerMaintain(message: systemMaintenanceMessages));
              store.dispatch(SetStartingRout(startingRout: ServerUpdate.routeName));
            }
            store.dispatch(EnterNumber(phoneNumber: startModel.user.phone));
            startModel.categories
                .removeWhere((category) => category.warehouses.isEmpty || category.warehouses[0].pivot.isActive == '0');
            startModel.categories.sort((a, b) {
              if ((int.parse(a.warehouses[0].pivot.priority)) > (int.parse(b.warehouses[0].pivot.priority))) {
                return 1;
              } else if ((int.parse(a.warehouses[0].pivot.priority) < (int.parse(b.warehouses[0].pivot.priority)))) {
                return -1;
              } else {
                return 0;
              }
            });
            Future.delayed(const Duration(seconds: 2),
                () => store.dispatch(InformationFetchedSuccessfully(startModel: startModel)));
            List<UserFavorite> userFavorites = [];
            userFavorites.addAll(startModel.userFavorites);
            List<int> favoritesIds = [];
            favoritesIds.addAll(userFavorites.map((product) => product.productId));
            store.dispatch(SaveFavorites(favorites: favoritesIds));
            await store.dispatch(GetPaymentMethods());
            OrdersOriginalData order;
            order = startModel.orderUnderUpdate;
            if (startModel.user.isBanned != 1) {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              int addressId = prefs.getInt('selectedAddressId');
              int indexId = -1;
              List<AddressModel> addresses = startModel.user.addresses;
              for (var address in addresses) {
                address.supportedCityName = startModel.supportedCities
                    .firstWhere((supportedCity) => supportedCity.id.toString() == address.supportedCityId)
                    .name;
              }
              store.dispatch(SaveAddresses(addresses: addresses));
              if (addressId != null) {
                indexId = startModel.user.addresses.indexWhere((address) => address.id == addressId);
              } else {
                indexId = startModel.user.addresses
                    .indexWhere((address) => address.supportedCityId == startModel.user.supportedCityId.toString());
              }
              if (indexId != -1 && order == null) {
                store.dispatch(SelectAddress(selectedAddress: indexId, firebaseToken: startModel.user.firebaseToken));
                await store.dispatch(GetDeliveryMethods(addressId: startModel.user.addresses[indexId].id));
              } else if (startModel.user.addresses.isNotEmpty && order == null) {
                await store.dispatch(GetDeliveryMethods(addressId: startModel.user.addresses[0].id));
              }
              if (order != null) {
                GetOrderResponse orderResponse = await OrderServices.getOrder(orderId: order.id.toString());
                if (order != null) {
                  await store.dispatch(GetDeliveryMethods(addressId: int.parse(orderResponse.order.addressId)));
                  store.dispatch(SetUpdateOrder(order: orderResponse.order));
                }
              } else {
                store.dispatch(LoadCart());
              }
              store.dispatch(StopLoading());
            }
          }
        }
      }
    }
  } else if (action is InformationFetchedSuccessfully) {
    if (!store.state.startupState.informationFetched) {
      List<AddressModel> addresses = action.startModel.user.addresses;
      for (var address in addresses) {
        address.supportedCityName = action.startModel.supportedCities
            .firstWhere((supportedCity) => supportedCity.id.toString() == address.supportedCityId)
            .name;
      }
      store.dispatch(SaveAddresses(addresses: addresses));
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String city = prefs.getString('supportedCitySelected');
      if (addresses.isEmpty && city == null) {
        await store.dispatch(GetSupportedCities(initial: true));
      } else {
        Navigator.of(navigatorKey.currentContext)
            .pushNamedAndRemoveUntil(store.state.startupState.startingRout, (Route<dynamic> route) => false);
      }
      store.dispatch(NoError());
    }
  }
  next(action);
}
