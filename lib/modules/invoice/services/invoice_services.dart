import '../../../core/core_importer.dart';
import 'package:intl/intl.dart';

class InvoiceServices {
  static Future<CheckInvoiceResponseModel> checkOrderInvoice({CheckInvoiceModel invoiceModel}) async {
    try {
      var response =
          await ApiProvider.sendRequest(url: checkInvoiceUrl, method: HttpMethods.post, body: jsonEncode(invoiceModel));
      if (response != null) {
        if (response.statusCode == 410) {
          return CheckInvoiceResponseModel(
              reason: response.data['reason'] ?? 'user could not use coupon',
              message: response.data['message'] ?? 'عذراً لا يمكن استخدام الكوبون',
              success: false,
              statusCode: 410,
              inactiveProducts: [],
              changedPriceProducts: []);
        }
        return checkInvoiceResponseModelFromJson(jsonEncode(response.data));
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  static Future<CheckInvoiceResponseModel> checkOrderInvoiceOnUpdate(
      {CheckInvoiceModel invoiceModel, String orderId}) async {
    Map invoice = invoiceModel.toJson();
    invoice.remove('delivery_method_id');
    invoice.remove('address_id');
    invoice.remove('supported_city_id');
    invoice.remove('payment_method_id');
    invoice.remove('use_wallet');
    invoice.remove('coupon_code');
    try {
      var response = await ApiProvider.sendRequest(
          url: checkInvoiceOnUpdateUrl + orderId, method: HttpMethods.post, body: jsonEncode(invoice));
      if (response != null) {
        if (response.statusCode == 410) {
          return CheckInvoiceResponseModel(
              reason: response.data['reason'] ?? 'user could not use coupon',
              message: response.data['message'] ?? 'عذراً لا يمكن استخدام الكوبون',
              success: false,
              statusCode: 410,
              inactiveProducts: [],
              changedPriceProducts: []);
        }
        return checkInvoiceResponseModelFromJson(jsonEncode(response.data));
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  static Future<CheckInvoiceResponseModel> cancelCoupon({String orderId}) async {
    try {
      var response = await ApiProvider.sendRequest(url: cancelCouponOnOrder + orderId, method: HttpMethods.post);
      if (response != null) {
        return checkInvoiceResponseModelFromJson(jsonEncode(response.data));
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  static Map<String, String> checkDate() {
    StartModelWarehouse warehouse = StoreProvider.of<AppState>(navigatorKey.currentContext)
        .state
        .startupState
        .startModel
        .warehouses
        .firstWhere(
            (warehouse) =>
                warehouse.id ==
                StoreProvider.of<AppState>(navigatorKey.currentContext)
                    .state
                    .supportedCityState
                    .supportedCities
                    .firstWhere(
                        (city) =>
                            city.id.toString() ==
                            StoreProvider.of<AppState>(navigatorKey.currentContext)
                                .state
                                .addressState
                                .addresses
                                .elementAt(StoreProvider.of<AppState>(navigatorKey.currentContext)
                                    .state
                                    .addressState
                                    .selectedIndex)
                                .supportedCityId,
                        orElse: () => StoreProvider.of<AppState>(navigatorKey.currentContext)
                            .state
                            .supportedCityState
                            .supportedCities
                            .first)
                    .warehouseId,
            orElse: () =>
                StoreProvider.of<AppState>(navigatorKey.currentContext).state.startupState.startModel.warehouses.first);
    String start;
    String end;
    if (DateTime.now().weekday == DateTime.friday) {
      start = warehouse.fridayStartTime;
      end = warehouse.fridayEndTime;
    } else {
      start = warehouse.workStartTime;
      end = warehouse.workEndTime;
    }
    DateTime startDate = DateFormat('h:mm').parse(start);
    DateTime endDate = DateFormat('h:mm').parse(end);
    if (startDate == endDate) {
      if (DateTime.now().weekday == DateTime.thursday) {
        if (warehouse.fridayStartTime == warehouse.fridayEndTime) return {'سيصل طلبك السبت بين': start};
      }
      return {'سيصل طلبك غداً بين': start};
    }
    if ((DateTime.now().hour < startDate.hour) ||
        (DateTime.now().hour == startDate.hour && DateTime.now().minute < startDate.minute)) {
      return {'سيصل طلبك اليوم بين': start};
    }
    if ((DateTime.now().hour > endDate.hour) ||
        (DateTime.now().hour == endDate.hour && DateTime.now().minute > endDate.minute)) {
      if (DateTime.now().weekday == DateTime.thursday) {
        if (warehouse.fridayStartTime == warehouse.fridayEndTime) return {'سيصل طلبك السبت بين': start};
      }
      return {'سيصل طلبك غداً بين': start};
    }
    return {'سيصل طلبك غداً بين': 'd'};
  }
}
