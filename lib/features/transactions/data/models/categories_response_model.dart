import '../../../../core/core_importer.dart';
import 'transaction_category_model.dart';

CategoriesResponseModel categoriesResponseModelFromJson(String str) =>
    CategoriesResponseModel.fromJson(json.decode(str));

class CategoriesResponseModel {
  CategoriesResponseModel({this.success, this.categories});

  bool success;
  List<TransactionCategoryModel> categories;

  factory CategoriesResponseModel.fromJson(Map<String, dynamic> json) => CategoriesResponseModel(
        success: json['success'],
        categories: List<TransactionCategoryModel>.from(json['data'].map((x) => TransactionCategoryModel.fromJson(x))),
      );
}
