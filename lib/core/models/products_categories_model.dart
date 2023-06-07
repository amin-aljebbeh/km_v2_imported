import 'package:kammun_app/core/models/models_importer.dart';

import '../../features/products/data/models/product_model.dart';
import '../core_importer.dart';

CategoryProducts categoryProductFromJson(String str) => CategoryProducts.fromJson(json.decode(str));

List<ProductModel> syncCartFromJson(String str) =>
    List<ProductModel>.from(json.decode(str).map((x) => ProductModel.fromJson(x)));

// CategoryProduct publicParameterFromJson(String str) =>
//     CategoryProduct.fromJson(json.decode(str));

class CategoryProducts {
  CategoryProducts({this.success, this.data});

  bool success;
  ProductResponse data;

  factory CategoryProducts.fromJson(Map<String, dynamic> json) =>
      CategoryProducts(success: json['success'], data: ProductResponse.fromJson(json['data']));

  Map<String, dynamic> toJson() => {'success': success, 'data': data.toJson()};
}

class ProductResponse {
  ProductResponse({
    this.currentPage,
    this.data,
    this.firstPageUrl,
    this.from,
    this.lastPage,
    this.lastPageUrl,
    this.nextPageUrl,
    this.path,
    this.perPage,
    this.prevPageUrl,
    this.to,
    this.total,
  });

  int currentPage;
  List<ProductModel> data;
  String firstPageUrl;
  int from;
  int lastPage;
  String lastPageUrl;
  String nextPageUrl;
  String path;
  int perPage;
  dynamic prevPageUrl;
  int to;
  int total;

  factory ProductResponse.fromJson(Map<String, dynamic> json) => ProductResponse(
        currentPage: json['current_page'],
        data: List<ProductModel>.from(json['data'].map((x) => x == null ? null : ProductModel.fromJson(x))),
        firstPageUrl: json['first_page_url'],
        from: json['from'],
        lastPage: json['last_page'],
        lastPageUrl: json['last_page_url'],
        nextPageUrl: json['next_page_url'],
        path: json['path'],
        perPage: json['per_page'],
        prevPageUrl: json['prev_page_url'],
        to: json['to'],
        total: json['total'],
      );

  Map<String, dynamic> toJson() => {
        'current_page': currentPage,
        'first_page_url': firstPageUrl,
        'from': from,
        'last_page': lastPage,
        'last_page_url': lastPageUrl,
        'next_page_url': nextPageUrl,
        'path': path,
        'per_page': perPage,
        'prev_page_url': prevPageUrl,
        'to': to,
        'total': total,
      };
}
