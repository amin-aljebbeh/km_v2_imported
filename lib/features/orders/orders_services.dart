import 'package:kammun_app/features/home/presentation/redux/home_action.dart';
import 'package:kammun_app/features/orders/domain/entities/order_entity.dart';
import 'package:kammun_app/features/products/domain/entities/product_entity.dart';
import 'package:kammun_app/features/shoppers/domain/entities/shopper_level_entity.dart';
import 'package:map_launcher/map_launcher.dart';

import '../../core/core_importer.dart';
import '../cart/presentation/redux/cart_action.dart';
import 'data/models/cancel_reason_model.dart';

class OrdersServices {
  static CancelToken cancelRequest = CancelToken();
}

String chooseOrderStatus(OrderEntity order, BuildContext context) {
  String orderStatus = 'طلبك قيد المعالجة ⌛️';
  switch (order.orderStatusId) {
    case '2':
      orderStatus = 'تم قبول الطلب ✅';
      break;
    case '3':
      orderStatus = 'تم تجهيز الطلب 😎';
      break;
    case '4':
      orderStatus = 'تم إرسال الطلب مع كابتن التوصيل';
      break;
    case '5':
      orderStatus = 'تم توصيل الطلب بنجاح';
      break;
    case '6':
      orderStatus = cancelReason('تم إلغاء الطلب من قبلكم 🚫', order, context);
      break;
    case '7':
      orderStatus = cancelReason('😔 لم نستطع تأمين الطلب 😔', order, context);
      break;
    case '8':
      orderStatus = 'معلق بانتظار الدفع الإلكتروني';
      break;
    case '9':
      orderStatus = 'فشل في الدفع الإلكتروني';
      break;
  }
  switch (order.underUpdate) {
    case '1':
      orderStatus = 'الطلب معلق حتى يأكد الزبون التعديل';
      break;
    case '2':
      orderStatus = 'الطلب معلق حتى تقوم بتأكيد التعديل';
      break;
  }
  return orderStatus;
}

String cancelReason(String orderStatus, OrderEntity order, BuildContext context) {
  String cancelReason = StoreProvider.of<AppState>(context)
      .state
      .ordersState
      .cancelReasons
      .firstWhere((reason) => reason.id == order.cancelReasonID, orElse: () => const CancelReasonModel(name: ''))
      .name;
  if (cancelReason != '') orderStatus += "، $cancelReason، ${order.cancelReasonOther}";
  return orderStatus;
}

Color frameColor({OrderEntity order, BuildContext context}) {
  return Services.hasRole(context, supplierRole)
      ? Colors.transparent
      : order.user.orderCount <= 3 && !order.user.orderCount.isNegative
          ? kmColors2
          : order.deliveryMethodId == '2'
              ? Colors.red[700]
              : order.deliveryMethodId == '3'
                  ? Colors.green
                  : Colors.red[500];
}

openMapSheet({context, double lat, double lon}) async {
  try {
    final coords = Coords(lat, lon);
    const title = 'Ocean Beach';
    final availableMaps = await MapLauncher.installedMaps;

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: SingleChildScrollView(
            child: Wrap(
              children: <Widget>[
                for (var map in availableMaps)
                  ListTile(
                      onTap: () => map.showMarker(coords: coords, title: title),
                      title: Text(map.mapName),
                      leading: const Icon(Icons.map))
              ],
            ),
          ),
        );
      },
    );
    return 0;
  } catch (e) {
/**/
  }
}

moveOrderProductsToCart({BuildContext context, List<ProductEntity> orderProducts}) async {
  orderProducts.removeWhere((element) => element.pivot.deletedAt != 'null');
  for (int i = 0; i < orderProducts.length; i++) {
    orderProducts[i].price =
        (int.parse(orderProducts[i].purchasePrice.split('.')[0]) - orderProducts[i].pivot.increaseValue).toString();

    orderProducts[i].productCount = int.parse(orderProducts[i].pivot.quantity);
    orderProducts[i].subWarehouseId = orderProducts[i].subWarehouseId ?? -1;
  }
  if (StoreProvider.of<AppState>(context).state.generalInformationState.subWarehouses.length == 1) {
    orderProducts.sort((a, b) {
      if (a.subWarehouseId > b.subWarehouseId) {
        return -1;
      } else if (a.subWarehouseId < b.subWarehouseId) {
        return 1;
      } else {
        return 0;
      }
    });
  } else {
    orderProducts.sort((a, b) {
      if (a.subWarehouseId > b.subWarehouseId) {
        return 1;
      } else if (a.subWarehouseId < b.subWarehouseId) {
        return -1;
      } else {
        return 0;
      }
    });
  }

  StoreProvider.of<AppState>(context).dispatch(SetCartProducts(products: orderProducts));
  StoreProvider.of<AppState>(context).dispatch(SetPageIndex(index: 1));

  Navigator.of(context).pushNamedAndRemoveUntil(HomePage.routeName, (Route<dynamic> route) => false);
}

String changeStatusButtonText(String status) {
  return status == '1'
      ? 'قبول الطلب'
      : status == '2'
          ? 'الطلب جاهز'
          : status == '3'
              ? 'مع التوصيل'
              : 'تم التوصيل';
}

Color changeStatusButtonColor(String status) {
  return status == '1'
      ? Colors.green[700]
      : status == '2'
          ? Colors.yellow[700]
          : Colors.cyan[700];
}

int newStatus(String status) {
  int changeStatus = 0;
  if (status == '1') {
    changeStatus = 2;
  } else if (status == '2') {
    changeStatus = 3;
  } else if (status == '3') {
    changeStatus = 4;
  } else if (status == '4') {
    changeStatus = 5;
  }
  return changeStatus;
}

gasAllowance({String deliveryDistance, int levelId, BuildContext context}) {
  ShopperLevelEntity orderLevel;
  if (Services.hasRole(context, shopperRole)) {
    orderLevel = StoreProvider.of<AppState>(context).state.shoppersState.shopper.level;
  } else {
    orderLevel =
        StoreProvider.of<AppState>(context).state.shoppersState.levels.firstWhere((level) => level.id == levelId);
  }
  return (int.parse(orderLevel.pricePerKilo.split('.')[0]) * (int.parse(deliveryDistance) / 1000));
}

lockOrderService(
    {@required int orderId,
    @required String supportedCityCost,
    @required String deliveryMethodCost,
    @required BuildContext context,
    @required String userNote}) async {
  try {
    StoreProvider.of<AppState>(context).dispatch(SetOrderId(orderId: orderId));
    StoreProvider.of<AppState>(context).dispatch(SetDeliveryPrice(
        deliveryPrice: int.parse(supportedCityCost.split('.')[0]) + int.parse(deliveryMethodCost.split('.')[0])));

    StoreProvider.of<AppState>(context).dispatch(SetUserNote(note: userNote));
  } catch (e) {
    /**/
  }
}
