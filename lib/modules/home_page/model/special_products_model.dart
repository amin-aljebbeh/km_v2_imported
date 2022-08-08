import '../../../core/common_models/product_model.dart';

class SpecialProductsModel {
  String title;
  String url;
  List<ProductData> products;
  String totalNumber;
  int nonActiveNumber;
  bool hasNext;

  SpecialProductsModel({this.totalNumber, this.products, this.title, this.url, this.hasNext, this.nonActiveNumber});
}
