import '../../../core/core_importer.dart';
import '../redux/product_action.dart';
import '../view/choose_alert_type_view.dart';

class ProductService {
  static Future<int> userVisitProduct(String productId) async {
    try {
      var response = await ApiProvider.sendRequest(url: getProduct + productId, method: HttpMethods.post);
      if (response != null) {
        if (response.statusCode == successCode) {
          return successCode;
        }
        return response.statusCode;
      }
      return internalServerError;
    } catch (e) {
      return internalServerError;
    }
  }

  static Future<ProductAlert> alertProductService({int productId, int isAlways}) async {
    try {
      Map body = {
        'product_id': productId,
        'is_always': isAlways,
        'warehouse_id':
            StoreProvider.of<AppState>(navigatorKey.currentContext).state.startupState.startModel.user.warehouseId
      };
      var response = await ApiProvider.sendRequest(url: alertProduct, method: HttpMethods.post, body: body);
      if (response.data['success']) {
        return ProductAlert.fromJson(response.data['data']);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  static Future<int> deleteAlertProductService({int alertId}) async {
    try {
      var response = await ApiProvider.sendRequest(url: alertProduct + alertId.toString(), method: HttpMethods.delete);
      if (response != null) {
        if (response.statusCode == successCode) {
          return successCode;
        }
      }
      return internalServerError;
    } catch (e) {
      return internalServerError;
    }
  }

  static Future<bool> updateAlertProductService({int alertId, int status, int isAlways}) async {
    try {
      Map body = {'status': status, 'is_always': isAlways};
      await ApiProvider.sendRequest(url: alertProduct + alertId.toString(), method: HttpMethods.put, body: body);
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<int> addToFavorites(String productsId) async {
    try {
      var response = await ApiProvider.sendRequest(url: addToFavorite + productsId, method: HttpMethods.put);

      if (response != null) {
        if (response.statusCode == successCode) {
          return successCode;
        }
      }
      return internalServerError;
    } catch (e) {
      return internalServerError;
    }
  }

  static Future<int> removeFromFavorites(String productsId) async {
    try {
      var response = await ApiProvider.sendRequest(url: removeFromFavorite + productsId, method: HttpMethods.put);

      if (response != null) {
        if (response.statusCode == successCode) {
          return successCode;
        }
      }
      return internalServerError;
    } catch (e) {
      return internalServerError;
    }
  }

  static getProductImages({List<ProductImage> images}) {
    List<Widget> newImages = [];
    if (images.isNotEmpty) {
      newImages.addAll(images
          .map((image) => KCacheImage(tag: images.indexOf(image), image: image.imageFileName, fit: BoxFit.contain))
          .toList());
    } else {
      newImages.add(Image.asset('assets/logobw.png'));
    }
    return newImages;
  }

  static notifyMeDialog({int productId, String productName}) {
    showMyDialog(
      dialogButtons: [
        const CloseWidget(),
        DialogButton(
          text: StringUtils.notifyMe,
          onTap: () {
            Navigator.of(navigatorKey.currentContext).pop();
            chooseAlertType(productId: productId, context: navigatorKey.currentContext);
          },
        ),
      ],
      title: 'نفذ المنتح من المستودعات',
      text:
          '$productName غير متوفر في المستودعات\nإذا كنت ترغب باستلام إشعار عند توفره مرة أخرى اضغط على ${StringUtils.notifyMe}.',
    );
  }

  static doNotNotifyMeDialog({int alertId, String productName, int productId}) {
    showMyDialog(
      dialogButtons: [
        const CloseWidget(),
        DialogButton(
          text: ' إلغاء الإشعار',
          onTap: () {
            StoreProvider.of<AppState>(navigatorKey.currentContext).dispatch(StartLoading());
            StoreProvider.of<AppState>(navigatorKey.currentContext)
                .dispatch(DoNotNotifyMe(alertId: alertId, productId: productId));

            Navigator.of(navigatorKey.currentContext).pop();
          },
        ),
      ],
      title: 'إلغاء الإشعار',
      text: 'أنت بانتظار إشعار توافر ' +
          productName +
          '\n' +
          ' إذا كنت لا ترغب باستلام إشعار عند توافره اضغط على إلغاء الإشعار.',
    );
  }
}
