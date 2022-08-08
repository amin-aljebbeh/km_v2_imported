import '../../../core/core_importer.dart';
import '../model/special_products_model.dart';

class FirstPaginationPage {}

class SetSpecialProducts {
  final List<SpecialProductsModel> specialProducts;

  SetSpecialProducts({this.specialProducts});
}

class GetSpecialProducts {
  final List<KeyValueModel> specialProduct;

  GetSpecialProducts({this.specialProduct});
}

class StartStoreLoading {}

class StopStoreLoading {}

class Subscribe {
  final String firebaseToken;
  final String topic;

  Subscribe({this.topic, this.firebaseToken});
}

class UnSubscribe {
  final String topic;
  final String firebaseToken;

  UnSubscribe({this.topic, this.firebaseToken});
}
