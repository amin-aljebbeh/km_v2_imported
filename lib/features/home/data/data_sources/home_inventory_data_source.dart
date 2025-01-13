import '../../../../core/core_importer.dart';
import '../models/banner_model.dart';

abstract class HomeRemoteDataSource {
  Future<List<BannerModel>>getBanners();
}

class HomeRemoteDataSourceImplement implements HomeRemoteDataSource {
  @override
  Future<List<BannerModel>> getBanners() async{
    Response response =
    await ApiProvider.sendRequest(url: bannerApi, method: HttpMethods.get);
    try {
      if (response != null) {
        if (response.statusCode == successCode) return bannerResponseFromJson(jsonEncode(response.data)).banners;
      }
    } catch (e) {
      throw (InternalException(message: e.toString()));
    }
    throw (ServerException());
  }
}
