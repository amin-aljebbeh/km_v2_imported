import 'package:kammun_app/core/core_importer.dart';
import 'package:kammun_app/features/prices_changes/model/prices_changes_model.dart';

class PricesChangesServices {
  static Future<PricesChanges> loadData() async {
    var response = await ApiProvider.sendRequest(url: getPriceChanged, method: HttpMethods.get);

    if (response.statusCode == successCode && response.data["success"]) {
      return pricesChangesFromJson(jsonEncode(response.data));
    }
    return null;
  }

  static Future<bool> deleteImage({int imageId}) async {
    try {
      var response = await ApiProvider.sendRequest(url: productImage + imageId.toString(), method: HttpMethods.delete);
      return response.statusCode == successCode && response.data["success"];
    } catch (e) {
      return false;
    }
  }
}
