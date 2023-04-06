import 'package:http/http.dart' as http;
import 'package:kammun_app/core/core_importer.dart';

import '../full_screen_image.dart';

class OrderDetailsServices {
  static Future<bool> updateOrder(
      {String orderId, String updateKey, String updateValue, String productId, @required BuildContext context}) async {
    try {
      Map updateOrderBody = {updateKey: updateValue, 'product_id': productId};
      var response = await ApiProvider.sendRequest(
          url: updateOrderProducts + orderId, method: HttpMethods.put, body: jsonEncode(updateOrderBody));
      if (response != null) {
        if (response.statusCode == successCode) {
          snackBar(success: true, message: 'نجحت عملية تعديل الطلب', context: context);
        } else {
          snackBar(success: false, message: 'فشلت عملية تعديل الطلب يرجى المحاولة مجدداً', context: context);
        }
        return response.statusCode == successCode;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> addImageToOrderService({String orderId, File image}) async {
    try {
      var headers = {'Authorization': LoadingScreen.userToken.length > 10 ? LoadingScreen.userToken : ""};
      var request = http.MultipartRequest('POST', Uri.parse(baseUrl + '/api/' + orderImage));
      request.fields.addAll({'order_id': orderId});
      request.files.add(await http.MultipartFile.fromPath('image', image.path));
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();
      return response.statusCode == successCode;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> deleteImageFromOrderService({String imageId}) async {
    try {
      var response = await ApiProvider.sendRequest(url: orderImage + imageId, method: HttpMethods.delete);
      return response.statusCode == successCode;
    } catch (e) {
      return false;
    }
  }

  static List<InkWell> getImages({List<OrderImage> images, BuildContext context, Function(int) onDelete}) {
    List<InkWell> imageWidgets = [];
    for (int i = 0; i < images.length; i++) {
      imageWidgets.add(InkWell(
        onLongPress: () async {
          List<DialogButton> dialogButtons = [
            DialogButton(
              text: yes,
              onTap: () async {
                Navigator.of(context).pop();
                bool result = await OrderDetailsServices.deleteImageFromOrderService(imageId: images[i].id.toString());
                if (result) {
                  snackBar(success: result, message: 'تم حذف الصورة من الطلب', context: context);
                  onDelete(i);
                } else {
                  snackBar(success: result, message: 'فشلت عملية حذف الصورة', context: context);
                }
              },
            ),
            DialogButton(text: no, onTap: () => Navigator.of(context).pop()),
          ];
          if (Services.hasRole(context, operationManagerRole)) {
            showMyDialog(context: context, title: '', text: 'هل تريد حذف الفاتورة ؟', dialogButtons: dialogButtons);
          }
        },
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => FullScreenImage(
                      imageUrl: StaticVariables.imagePrefixUrl + 'orders/' + images[i].imageFileName,
                      tag: 'generate_a_unique_tag')));
        },
        child: images != null && images.isNotEmpty
            ? KCacheImage(
                tag: images[i].imageFileName,
                image: StaticVariables.imagePrefixUrl + 'orders/' + images[i].imageFileName)
            : const AssetImage('assets/kmIcon.png'),
      ));
    }
    return imageWidgets;
  }

  static List<Widget> calculate({OrdersOriginalData order, BuildContext context}) {
    List<Widget> subWarehouseTotal = [];
    subWarehouseTotal.add(KTableRow(
      children: [
        const KTableElement(text: 'المورد'),
        const KTableElement(text: 'الدفع للمورد'),
        if (Services.hasRole(context, accountingRole)) const KTableElement(text: 'نسبة الزيادة'),
        const KTableElement(text: 'السعر الصافي')
      ],
    ));
    for (int i = 0; i < order.orderAccountingRows.length; i++) {
      if (order.orderAccountingRows[i].payToSubWarehouse != 0) {
        subWarehouseTotal.add(KTableRow(
          children: [
            KTableElement(text: order.orderAccountingRows[i].subWarehouseName),
            KTableElement(
              text: StringUtils().oCcy.format(order.orderAccountingRows[i].directDiscount == 1
                  ? Services.kRound(order.orderAccountingRows[i].payToSubWarehouse)
                  : order.orderAccountingRows[i].payToSubWarehouse),
            ),
            if (Services.hasRole(context, accountingRole))
              KTableElement(text: StringUtils().oCcy.format(order.orderAccountingRows[i].increaseValuesSum)),
            KTableElement(text: StringUtils().oCcy.format(order.orderAccountingRows[i].netPrice)),
          ],
        ));
      }
    }
    if (!Services.hasRole(context, supplierRol)) {
      int delivery = int.parse(order.supportedCityCost.split('.')[0]) +
          int.parse(order.deliveryCost.split('.')[0]) +
          int.parse(order.collectingCost.split('.')[0]);
      int subTotal = int.parse(order.total.split('.')[0]) - delivery;
      subWarehouseTotal.add(KTableRow(
          children: [KTableElement(text: subtotalString), KTableElement(text: StringUtils().oCcy.format(subTotal))]));
      subWarehouseTotal.add(KTableRow(children: [
        const KTableElement(text: 'أجور التوصيل'),
        KTableElement(text: StringUtils().oCcy.format(delivery))
      ]));
      if (order.tips != 0) {
        subWarehouseTotal.add(KTableRow(children: [
          const KTableElement(text: 'الإكرامية'),
          KTableElement(text: StringUtils().oCcy.format(order.tips))
        ]));
      }
      if (int.parse(order.couponValue.split('.')[0]) != 0) {
        subWarehouseTotal.add(KTableRow(children: [
          const KTableElement(text: 'قيمة كود الحسم'),
          KTableElement(
              text: StringUtils().oCcy.format(int.parse(order.couponValue.split('.')[0])), style: lightLoseStyle)
        ]));
      }
      if (int.parse(order.walletValue.split('.')[0]) != 0) {
        subWarehouseTotal.add(KTableRow(children: [
          const KTableElement(text: 'قيمة المحفظة'),
          KTableElement(
              text: StringUtils().oCcy.format(int.parse(order.walletValue.split('.')[0])), style: lightLoseStyle)
        ]));
      }
      subWarehouseTotal.add(KTableRow(children: [
        KTableElement(text: totalString),
        KTableElement(
            text: StringUtils()
                .oCcy
                .format(int.parse(order.total.split('.')[0]) - int.parse(order.walletValue.split('.')[0])))
      ]));
      subWarehouseTotal.add(KTableRow(children: [
        KTableElement(text: 'القبض من الزبون', style: informationStyle),
        KTableElement(
            text: StringUtils().oCcy.format(int.parse(order.cashValue.split('.')[0])),
            style: int.parse(order.cashValue.split('.')[0]).isNegative
                ? informationStyle.copyWith(color: Colors.red)
                : informationStyle)
      ]));
    } else {
      subWarehouseTotal.add(KTableRow(children: [
        KTableElement(text: totalString),
        KTableElement(
            text: StringUtils()
                .oCcy
                .format(Services.kRound(order.orderAccountingRows.fold(0, (sum, row) => sum + row.payToSubWarehouse))))
      ]));
    }
    return subWarehouseTotal;
  }
}
