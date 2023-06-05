import 'package:kammun_app/features/orders/domain/entities/order_entity.dart';
import 'package:map_launcher/map_launcher.dart';

import '../../core/core_importer.dart';
import '../cart/services/cart_services.dart';

class OrdersServices {
  static int orderUnderUpdateIndex = -1;
  static String updateOrderNote = '';
  static String orderUnderUpdateStatusId = '0';
  static String orderUnderUpdateId = '';
  static CancelToken cancelRequest = CancelToken();
}

String chooseOrderStatus(OrderEntity order) {
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
      orderStatus = 'تم إلغاء الطلب من قبلكم 🚫';
      break;
    case '7':
      orderStatus = '😔 لم نستطع تأمين الطلب 😔';
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

moveOrderProductsToCart({BuildContext context, List<OrderProduct> orderProducts}) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  CartServices.cartProducts.clear();
  String productsId = '';
  String productsQuantity = '';

  orderProducts.removeWhere((element) => element.pivot.deletedAt != 'null');

  for (int i = 0; i < orderProducts.length; i++) {
    ProductData product = ProductData();

    product.id = orderProducts[i].id;
    product.images = orderProducts[i].images;
    product.name = orderProducts[i].name;
    product.pivot = OrderProductPivot(
        subWarehouseId: orderProducts[i].pivot.subWarehouseId,
        quantity: orderProducts[i].pivot.quantity,
        increaseValue: orderProducts[i].pivot.increaseValue,
        purchasePrice: orderProducts[i].pivot.purchasePrice);
    product.price =
        (int.parse(orderProducts[i].pivot.purchasePrice.split('.')[0]) - orderProducts[i].pivot.increaseValue)
            .toString();

    product.productCount = int.parse(orderProducts[i].pivot.quantity);
    product.unit = orderProducts[i].unit;
    product.quantity = orderProducts[i].quantity;
    product.subWarehouseId = orderProducts[i].subWarehouseId ?? -1;
    product.pivot = orderProducts[i].pivot;
    CartServices.addProductToCart(product);
  }

  for (int i = 0; i < CartServices.cartProducts.length; i++) {
    productsId += CartServices.cartProducts[i].id.toString() + ';';
    productsQuantity += CartServices.cartProducts[i].productCount.toString() + ';';
  }
  prefs.setString('userCart', productsId + '@' + productsQuantity);

  Navigator.of(context).pushNamedAndRemoveUntil(CartView.fromUpdateRouteName, (Route<dynamic> route) => false);
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
  Level orderLevel;
  if (Services.hasRole(context, shopperRole)) {
    orderLevel = StaticVariables.shopper.level;
  } else {
    orderLevel = StaticVariables.levels.firstWhere((level) => level.id == levelId);
  }
  return (int.parse(orderLevel.pricePerKilo.split('.')[0]) * (int.parse(deliveryDistance) / 1000));
}

lockOrderService(
    {@required String orderId,
    @required String supportedCityCost,
    @required String deliveryMethodCost,
    @required String userNote}) async {
  try {
    var response = await ApiProvider.sendRequest(url: lockOrderApi + orderId, method: HttpMethods.put);
    if (response.data == null) return null;
    if (response.statusCode == successCode && response.data['success']) {
      OrdersServices.orderUnderUpdateIndex = int.parse(orderId);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('orderUnderUpdateId', orderId);

      OrdersServices.orderUnderUpdateId = orderId;

      StaticVariables.deliveryPrice =
          int.parse(supportedCityCost.split('.')[0]) + int.parse(deliveryMethodCost.split('.')[0]);

      OrdersServices.updateOrderNote = userNote;
    }
  } catch (e) {
    /**/
  }
}
